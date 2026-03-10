// ci/build.dart

// ignore_for_file: avoid_print, constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

// --- 脚本配置常量 (请根据你的实际情况修改) ---

/// S3 相关配置（建议通过环境变量注入，避免明文密钥）
/// PowerShell 示例：
/// $env:S3_ENDPOINT='http://111.9.22.231:50134'
/// $env:S3_ACCESS_KEY='你的AccessKey'
/// $env:S3_SECRET_KEY='你的SecretKey'
/// $env:S3_BUCKET='你的bucket'
const DEFAULT_S3_ENDPOINT = 'http://111.9.22.231:50134';
const DEFAULT_S3_REGION = 'us-east-1';
const DEFAULT_S3_BUCKET = 'app';
const DEFAULT_S3_PUBLIC_INCLUDE_BUCKET = true;

/// 企业微信 Webhook 相关配置
const WECHAT_WEBHOOK_URL = 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send';
const WECHAT_TOKEN = '7abe9e0e-d5a4-4938-af16-33a8a6987a0c';

/// 默认@的手机号列表
final List<String> atMobiles = ['19982626354'];

/// JSON编码器，用于格式化输出
const ENCODER = JsonEncoder.withIndent('  ');

/// 全局标准输入流广播
late final Stream<String> _broadcastStdin;

/// 主入口函数
void main(List<String> args) async {
  // 初始化标准输入流
  _broadcastStdin = stdin
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .asBroadcastStream();

  try {
    // 1. 解析参数并创建构建配置
    final config = await BuildConfig.fromArgs(args);
    // 2. 创建并执行构建流程
    await BuildRunner(config).run();
  } catch (e, s) {
    Logger.error('脚本执行失败: $e');
    if (e is ArgumentError) {
      Logger.info('请在 .run/ 目录下检查或创建有效的 Flutter 运行配置 (*.run.xml)');
    } else {
      Logger.error('堆栈信息:\n$s');
    }
    exit(1);
  }
}

// --- 核心逻辑类 ---

/// 封装了脚本的所有配置项
class BuildConfig {
  /// Flavor 名称 (例如: dev, prod)
  final String? flavor;

  /// 构建渠道标识（用于日志与上传），不一定等于 Gradle flavor
  final String channel;

  /// Dart 入口文件路径 (例如: lib/main_dev.dart)
  final String entryPoint;

  /// 应用显示名称 (从 resValue 中获取)
  final String appName;

  /// 最终的包名 (例如: com.hyzh.industrial_alarm.dev)
  final String finalPackageId;

  /// 构建产物APK的路径
  final String finalApkPath;

  BuildConfig({
    required this.flavor,
    required this.channel,
    required this.entryPoint,
    required this.appName,
    required this.finalPackageId,
    required this.finalApkPath,
  });

  /// 从命令行参数和本地配置自动创建构建配置
  static Future<BuildConfig> fromArgs(List<String> args) async {
    // 1. 从 .run/*.xml 文件中选择一个运行配置
    final runConfig = await RunConfig.selectFromLocal();
    Logger.success(
      '已选择构建配置: ${runConfig.name} (Flavor: ${runConfig.flavor ?? 'default'})',
    );

    final hasValidFlavor = await GradleParser.supportsFlavor(runConfig.flavor);
    final effectiveFlavor = hasValidFlavor ? runConfig.flavor : null;
    if (runConfig.flavor != null && !hasValidFlavor) {
      Logger.warn(
        'Gradle 中未定义 flavor "${runConfig.flavor}"，将自动以无 flavor 模式构建。',
      );
    }

    // 2. 基于选择的 flavor，从 build.gradle.kts 解析详细信息
    final appName =
        await GradleParser.getAppName(effectiveFlavor) ?? runConfig.name;
    final packageId = await GradleParser.getFinalPackageId(effectiveFlavor);

    // 3. 确定最终构建产物的路径
    // Flutter 3.19+ aab/apk产物默认带flavor和build mode
    // e.g., build/app/outputs/flutter-apk/app-dev-release.apk
    final apkPath = (effectiveFlavor == null || effectiveFlavor.isEmpty)
        ? 'build/app/outputs/flutter-apk/app-release.apk'
        : 'build/app/outputs/flutter-apk/app-$effectiveFlavor-release.apk';

    return BuildConfig(
      flavor: effectiveFlavor,
      channel: runConfig.flavor ?? 'default',
      entryPoint: runConfig.entryPoint,
      appName: appName,
      finalPackageId: packageId,
      finalApkPath: apkPath,
    );
  }
}

/// 负责执行整个构建和上传流程
class BuildRunner {
  BuildRunner(this.config);

  final BuildConfig config;

  Future<void> run() async {
    await _checkPrerequisites();
    await _buildApk();
    await _processAndUploadApk();
    await _pushCurrentBranchIfNeeded();
  }

  /// 检查脚本运行环境
  Future<void> _checkPrerequisites() async {
    final isAtProjRoot = await File('pubspec.yaml').exists();
    if (!isAtProjRoot) {
      throw const FileSystemException('请在Flutter项目根目录下运行此脚本。', 'pubspec.yaml');
    }
    Logger.success('环境检查通过。');
  }

  // 获取当前项目选择的flutter路径
  String? _getFlutterSdkPath() {
    final file = File('android/local.properties');
    if (!file.existsSync()) return null;

    final properties = file.readAsLinesSync();
    for (var line in properties) {
      if (line.startsWith('flutter.sdk=')) {
        final path = line.split('=')[1].trim();
        return '$path/bin/flutter';
      }
    }
    return null;
  }

  /// 执行 Flutter 构建命令
  Future<void> _buildApk() async {
    final startTime = DateTime.now();
    Logger.info('开始构建APK (Flavor: ${config.flavor ?? 'default'})...');

    final flutterBin = _getFlutterSdkPath() ?? 'flutter';
    // 构建命令：有 flavor 才追加 --flavor
    final buildArgs = <String>[
      'build',
      'apk',
      '--release',
      '-t',
      config.entryPoint,
    ];
    if (config.flavor != null && config.flavor!.isNotEmpty) {
      buildArgs.insertAll(3, ['--flavor', config.flavor!]);
    }

    Logger.info('执行命令: $flutterBin ${buildArgs.join(' ')}');

    final process = await Process.start(
      flutterBin,
      buildArgs,
      runInShell: true,
    );
    final stdoutSubscription = process.stdout
        .transform(utf8.decoder)
        .listen(Logger.info);
    final stderrSubscription = process.stderr
        .transform(utf8.decoder)
        .listen(Logger.error);

    final exitCode = await process.exitCode;
    await stdoutSubscription.cancel();
    await stderrSubscription.cancel();

    if (exitCode != 0) {
      throw ProcessException(
        flutterBin,
        buildArgs,
        'Flutter构建失败，退出码: $exitCode',
        exitCode,
      );
    }
    final duration = DateTime.now().difference(startTime);
    Logger.success('APK构建成功！耗时: ${duration.inSeconds}秒');
  }

  /// 处理并上传构建产物
  Future<void> _processAndUploadApk() async {
    final apkFile = File(config.finalApkPath);
    if (!await apkFile.exists()) {
      throw FileSystemException('构建产物未找到', config.finalApkPath);
    }

    final updateLog = await _promptForUpdateLog();
    final uploadToPgyer = await _promptForUploadTarget();

    if (uploadToPgyer) {
      await _performPgyerUpload(apkFile, updateLog);
    } else {
      await _performS3Upload(apkFile, updateLog);
    }
  }

  /// 提示用户输入更新日志
  Future<String> _promptForUpdateLog() async {
    String suggestedLog = '常规优化及Bug修复';
    Logger.info('正在获取最新的 Git 提交日志...');
    try {
      final result = await Process.run(
        'git',
        ['log', '-1', '--pretty=%B'],
        stdoutEncoding: utf8,
        stderrEncoding: utf8,
      );
      if (result.exitCode == 0 && result.stdout.toString().trim().isNotEmpty) {
        suggestedLog = result.stdout.toString().trim();
        Logger.success('成功获取到 Git 日志。');
      } else {
        Logger.error('获取 Git 日志失败或日志为空，将使用默认值。');
      }
    } catch (e) {
      Logger.error('获取 Git 日志时发生异常: $e');
    }

    Logger.info('');
    Logger.prompt('======== 以下是建议的更新日志 ========');
    Logger.info(suggestedLog);
    Logger.prompt('======================================');
    Logger.info('');

    const timeout = Duration(seconds: 30);
    final prompt = '请直接回车以使用上述日志，或输入新的日志内容';
    final userInput = await _ioPromptWithTimeout(prompt, timeout);
    String finalLog;

    if (userInput == _TIMED_OUT) {
      Logger.info('输入超时，将使用建议的日志。');
      finalLog = suggestedLog;
    } else {
      finalLog = userInput.trim().isEmpty ? suggestedLog : userInput.trim();
    }

    Logger.success('最终确认的更新日志为:');
    Logger.info(finalLog);
    return finalLog;
  }

  /// 提示用户选择上传目标
  Future<bool> _promptForUploadTarget() async {
    const prompt = '是否上传到蒲公英 (y/n, 默认 y, 上传到私有服务器)';
    const timeout = Duration(seconds: 30);
    final input = (await _ioPromptWithTimeout(
      prompt,
      timeout,
    )).toLowerCase().trim();

    if (input == _TIMED_OUT) {
      Logger.info('输入超时，将自动选择 "y"（上传到蒲公英）。');
      return true;
    }

    return !input.contains('n');
  }

  /// 执行蒲公英上传
  Future<void> _performPgyerUpload(File apkFile, String updateLog) async {
    // ... (这部分逻辑与你之前的脚本完全相同，直接复用)
    Logger.info('开始上传到蒲公英...');
    final success = await AppUploader.uploadToPgyer(
      path: apkFile.path,
      updateDescription: updateLog,
    );
    if (success) {
      Logger.success('蒲公英上传流程已启动，请在蒲公英后台查看详情。');
    } else {
      Logger.error('上传到蒲公英失败。');
    }
  }

  /// 执行 S3 上传
  Future<void> _performS3Upload(File apkFile, String updateLog) async {
    Logger.info('开始上传到公司生产 S3...');
    final uploadedUrl = await S3Uploader.uploadApk(
      filePath: apkFile.path,
      packageId: config.finalPackageId,
      channel: config.channel,
    );
    Logger.success('上传到公司生产 S3 成功！');

    final size = await apkFile.length() / 1024 / 1024;
    final buildTime = _fmtTime(DateTime.now());

    final results = <String, dynamic>{
      '项目': config.appName,
      '环境': config.channel,
      '大小': '${size.toStringAsFixed(2)}MB',
      '包名': config.finalPackageId,
      '构建时间': buildTime,
      '更新日志': updateLog,
      '下载链接': Uri.encodeFull(uploadedUrl),
    };

    Logger.info('构建结果详情:');
    Logger.info(ENCODER.convert(results));
    await _sendWeChatNotification(results);
  }

  /// 发送企业微信通知
  Future<void> _sendWeChatNotification(Map<String, dynamic> data) async {
    const prompt = '是否发送企业微信消息 (y/n, 默认 y)';
    const timeout = Duration(seconds: 30);
    final input = (await _ioPromptWithTimeout(
      prompt,
      timeout,
    )).toLowerCase().trim();

    if (input == 'n') {
      Logger.info('用户取消发送企业微信消息。');
      return;
    }

    if (input == _TIMED_OUT) {
      Logger.info('输入超时，将自动发送。');
    }

    Logger.info('正在发送企业微信通知...');
    await WeChat.send(
      title: '新的构建已完成: ${config.appName}',
      data: data,
      atMobiles: atMobiles,
    );
  }

  /// 如有未推送提交，则自动 push 当前分支
  Future<void> _pushCurrentBranchIfNeeded() async {
    Logger.info('检查当前分支是否需要自动 push...');

    final branchResult = await Process.run(
      'git',
      ['rev-parse', '--abbrev-ref', 'HEAD'],
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );
    if (branchResult.exitCode != 0) {
      Logger.warn('获取当前分支失败，跳过自动 push。');
      return;
    }

    final branch = branchResult.stdout.toString().trim();
    if (branch.isEmpty || branch == 'HEAD') {
      Logger.warn('当前处于 detached HEAD，跳过自动 push。');
      return;
    }

    final dirtyResult = await Process.run(
      'git',
      ['status', '--short'],
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );
    if (dirtyResult.exitCode == 0 &&
        dirtyResult.stdout.toString().trim().isNotEmpty) {
      Logger.warn('检测到未提交改动，自动 push 只会推送已提交内容，不会自动 commit。');
    }

    final aheadResult = await Process.run(
      'git',
      ['rev-list', '--count', '@{u}..HEAD'],
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );
    if (aheadResult.exitCode != 0) {
      Logger.warn('当前分支可能尚未设置 upstream，尝试直接推送到 origin/$branch ...');
      await _pushBranch(branch);
      return;
    }

    final aheadCount = int.tryParse(aheadResult.stdout.toString().trim()) ?? 0;
    if (aheadCount <= 0) {
      Logger.success('当前分支没有未推送提交，无需 push。');
      return;
    }

    Logger.info('检测到当前分支有 $aheadCount 个未推送提交，开始自动 push...');
    await _pushBranch(branch);
  }

  Future<void> _pushBranch(String branch) async {
    final pushResult = await Process.start('git', [
      'push',
      'origin',
      branch,
    ], runInShell: true);
    final stdoutSubscription = pushResult.stdout
        .transform(utf8.decoder)
        .listen(Logger.info);
    final stderrSubscription = pushResult.stderr
        .transform(utf8.decoder)
        .listen(Logger.error);

    final exitCode = await pushResult.exitCode;
    await stdoutSubscription.cancel();
    await stderrSubscription.cancel();

    if (exitCode != 0) {
      throw ProcessException(
        'git',
        ['push', 'origin', branch],
        '自动 push 失败，退出码: $exitCode',
        exitCode,
      );
    }

    Logger.success('自动 push 完成：origin/$branch');
  }
}

// --- 新增和修改的辅助类 ---

/// 解析 android/app/build.gradle.kts 文件
abstract final class GradleParser {
  static String? _contentCache;

  static Future<String> _getGradleContent() async {
    if (_contentCache != null) return _contentCache!;
    final file = File('android/app/build.gradle.kts');
    if (!await file.exists()) {
      throw FileSystemException('Gradle配置文件未找到', file.path);
    }
    _contentCache = await file.readAsString();
    return _contentCache!;
  }

  /// 检查指定 flavor 是否在 Gradle 的 productFlavors 中定义
  static Future<bool> supportsFlavor(String? flavor) async {
    if (flavor == null || flavor.isEmpty) return false;
    final content = await _getGradleContent();
    if (!content.contains('productFlavors')) return false;
    return RegExp('create\\("$flavor"\\)\\s*\\{').hasMatch(content);
  }

  /// 获取指定 Flavor 的最终包名
  static Future<String> getFinalPackageId(String? flavor) async {
    final content = await _getGradleContent();

    // 1. 获取默认包名
    final baseIdMatch = RegExp(
      r'applicationId\s*=\s*"([^"]+)"',
    ).firstMatch(content);
    final baseId = baseIdMatch?.group(1);
    if (baseId == null)
      throw Exception('在 build.gradle.kts 中找不到默认的 applicationId');

    // 2. 查找指定 flavor 的配置块
    if (flavor == null || flavor.isEmpty) {
      return baseId;
    }
    final flavorBlockMatch = RegExp(
      'create\\("$flavor"\\)\\s*\\{([\\s\\S]*?)\\}',
    ).firstMatch(content);
    if (flavorBlockMatch == null) {
      // 如果没有找到独立的 flavor 块 (例如 prod flavor 可能直接使用默认值)，则返回基础ID
      return baseId;
    }

    final flavorBlock = flavorBlockMatch.group(1)!;

    // 3. 查找 applicationIdSuffix
    final suffixMatch = RegExp(
      r'applicationIdSuffix\s*=\s*"([^"]+)"',
    ).firstMatch(flavorBlock);
    if (suffixMatch != null) {
      return '$baseId${suffixMatch.group(1)}';
    }

    // 4. 查找完整的 applicationId 覆盖
    final overrideMatch = RegExp(
      r'applicationId\s*=\s*"([^"]+)"',
    ).firstMatch(flavorBlock);
    if (overrideMatch != null) {
      return overrideMatch.group(1)!;
    }

    // 5. 如果都没有，返回基础ID
    return baseId;
  }

  /// 获取指定 Flavor 的应用名称
  static Future<String?> getAppName(String? flavor) async {
    if (flavor == null || flavor.isEmpty) return null;
    final content = await _getGradleContent();
    final flavorBlockMatch = RegExp(
      'create\\("$flavor"\\)\\s*\\{([\\s\\S]*?)\\}',
    ).firstMatch(content);
    if (flavorBlockMatch == null) return null;

    final flavorBlock = flavorBlockMatch.group(1)!;
    final appNameMatch = RegExp(
      r'resValue\("string",\s*"app_name",\s*"([^"]+)"\)',
    ).firstMatch(flavorBlock);

    return appNameMatch?.group(1);
  }
}

/// 解析 .run/*.xml IDEA/Android Studio 运行配置
class RunConfig {
  final String name;
  final String? flavor;
  final String entryPoint;

  const RunConfig({
    required this.name,
    required this.flavor,
    required this.entryPoint,
  });

  static final _nameReg = RegExp(r'<configuration .*name="([^"]+)"');
  static final _flavorReg = RegExp(
    r'<option name="buildFlavor" value="([^"]+)" />',
  );
  static final _additionalArgsReg = RegExp(
    r'<option name="additionalArgs" value="([^"]+)" />',
  );
  static final _entryPointReg = RegExp(
    r'<option name="filePath" value="\$PROJECT_DIR\$([^"]+)" />',
  );

  /// 从文件中解析配置
  static RunConfig? fromFile(File file) {
    final content = file.readAsStringSync();
    final name = _nameReg.firstMatch(content)?.group(1);
    var flavor = _flavorReg.firstMatch(content)?.group(1);
    final additionalArgs =
        _additionalArgsReg.firstMatch(content)?.group(1) ?? '';
    final entryPoint = _entryPointReg
        .firstMatch(content)
        ?.group(1)
        ?.substring(1); // 移除开头的 '/'

    if (flavor == null || flavor.isEmpty) {
      flavor = RegExp(
        r'--flavor\s+([A-Za-z0-9_-]+)',
      ).firstMatch(additionalArgs)?.group(1);
    }
    if ((flavor == null || flavor.isEmpty) && entryPoint != null) {
      flavor = _inferFlavorFromEntryPoint(entryPoint);
    }

    if (name != null && entryPoint != null) {
      return RunConfig(name: name, flavor: flavor, entryPoint: entryPoint);
    }
    return null;
  }

  static String? _inferFlavorFromEntryPoint(String entryPoint) {
    final fileName = entryPoint.split('/').last;
    final match = RegExp(r'^main_([A-Za-z0-9_-]+)\.dart$').firstMatch(fileName);
    return match?.group(1);
  }

  /// 从本地 .run 目录中扫描并让用户选择一个配置
  static Future<RunConfig> selectFromLocal() async {
    final dir = Directory('.run');
    if (!await dir.exists()) throw const FileSystemException('找不到 .run 目录');

    final files = await dir
        .list()
        .where((f) => f.path.endsWith('.run.xml'))
        .toList();
    if (files.isEmpty)
      throw const FileSystemException('在 .run/ 目录中未找到任何 *.run.xml 配置文件');

    final configs = files
        .map((f) => fromFile(File(f.path)))
        .whereType<RunConfig>()
        .toList();
    if (configs.isEmpty) throw Exception('在 .run/ 目录中未找到有效的 Flutter 运行配置');
    if (configs.length == 1) return configs.first;

    Logger.prompt('检测到多个运行配置，请选择一个:');
    for (var i = 0; i < configs.length; i++) {
      Logger.info(
        '$i: ${configs[i].name} (Flavor: ${configs[i].flavor ?? 'default'})',
      );
    }

    const prompt = '请输入序号 (默认 0)';
    const timeout = Duration(seconds: 30);
    final userInput = await _ioPromptWithTimeout(prompt, timeout);
    int index;

    if (userInput == _TIMED_OUT || userInput.isEmpty) {
      Logger.info('输入超时，将自动选择 "0"。');
      index = 0;
    } else {
      index = int.tryParse(userInput) ?? 0;
    }

    if (index < 0 || index >= configs.length) {
      Logger.error('无效的选项索引，将使用默认选项 0。');
      index = 0;
    }
    return configs[index];
  }
}

// --- 以下是可复用的工具类 (与你之前的脚本基本相同) ---

const String _TIMED_OUT = '__TIMED_OUT__';

/// 从控制台读取用户输入，并带有后台超时功能。
Future<String> _ioPromptWithTimeout(String prompt, Duration timeout) async {
  Logger.prompt('$prompt (将在 ${timeout.inSeconds} 秒后自动确认): ', ln: false);

  final inputFuture = _broadcastStdin.first;
  final timeoutFuture = Future.delayed(timeout, () => _TIMED_OUT);

  final result = await Future.any([inputFuture, timeoutFuture]);

  if (result == _TIMED_OUT) {
    stdout.writeln(); // 超时后换行，保持格式整洁
  }

  return result;
}

/// 简单的日志工具类
abstract final class Logger {
  static const String _reset = '\x1b[0m';
  static const String _green = '\x1b[32m';
  static const String _red = '\x1b[31m';
  static const String _yellow = '\x1b[33m';

  static void info(Object? obj) => stdout.writeln(obj);
  static void success(Object? obj) => stdout.writeln('$_green$obj$_reset');
  static void error(Object? obj) => stderr.writeln('$_red$obj$_reset');
  static void warn(Object? obj) => stdout.writeln('$_yellow$obj$_reset');
  static void prompt(String message, {bool ln = true}) {
    final coloredMessage = '$_yellow$message$_reset';
    if (ln) {
      stdout.writeln(coloredMessage);
    } else {
      stdout.write(coloredMessage);
    }
  }
}

/// 格式化日期时间
String _fmtTime(DateTime time) {
  return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

/// 企业微信通知模块
abstract final class WeChat {
  static final _dio = Dio(
    BaseOptions(
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  static Future<void> send({
    required String title,
    required Map<String, dynamic> data,
    List<String>? atMobiles,
  }) async {
    // ... (逻辑与你之前的脚本完全相同)
    if (WECHAT_WEBHOOK_URL.isEmpty || WECHAT_TOKEN.isEmpty) {
      Logger.error('企业微信的 URL 或 Token 未配置。');
      return;
    }
    try {
      final resp = await _dio.post(
        WECHAT_WEBHOOK_URL,
        data: {
          'msgtype': 'markdown',
          'markdown': {
            'content': _toMarkdown(title, data),
            'mentioned_mobile_list': atMobiles,
          },
        },
        queryParameters: {'key': WECHAT_TOKEN},
      );
      if (resp.statusCode == 200 && resp.data['errcode'] == 0) {
        Logger.success('企业微信消息发送成功！');
      } else {
        throw Exception('发送失败: ${resp.statusCode}, ${resp.data}');
      }
    } catch (e) {
      Logger.error('发送企业微信消息时发生网络错误: $e');
    }
  }

  static String _toMarkdown(String title, Map<String, dynamic> data) {
    final buf = StringBuffer();
    buf.writeln('## $title\n');
    for (final entry in data.entries) {
      buf.writeln('> **${entry.key}**: ${entry.value}');
    }
    return buf.toString();
  }
}

/// 蒲公英上传模块
class AppUploader {
  static const String _pgyerApiKey =
      '51703a1d7b85abc64a6727ab4a9d7812'; // TODO: 替换为你的蒲公英 API Key
  // ... (此类与你之前的脚本完全相同，这里省略了具体实现以保持简洁，你可以直接复制过来)
  // ... (请确保将 _getCOSToken, _uploadFile, _pollBuildInfo 等方法完整复制)
  static final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.pgyer.com/apiv2/',
      headers: {'Content-Type': 'multipart/form-data'},
    ),
  );

  static Future<bool> uploadToPgyer({
    required String path,
    String? updateDescription,
  }) async {
    try {
      Logger.info('正在向蒲公英获取上传凭证...');
      final cosTokenData = await _getCOSToken(updateDescription);
      final uploadUrl = cosTokenData['endpoint'] as String;
      final params = cosTokenData['params'] as Map<String, dynamic>;

      Logger.info('凭证获取成功，开始上传文件至蒲公英...');
      await _uploadFile(uploadUrl, path, params);
      Logger.success('文件上传完成，正在等待蒲公英处理...');
      await _pollBuildInfo(params['key'] as String);
      return true;
    } catch (e) {
      Logger.error('蒲公英上传过程中出错: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> _getCOSToken(
    String? updateDescription,
  ) async {
    final response = await _dio.post(
      'app/getCOSToken',
      data: FormData.fromMap({
        '_api_key': _pgyerApiKey,
        'buildType': 'android',
        'buildInstallType': 1,
        'buildUpdateDescription': ?updateDescription,
      }),
    );
    if (response.statusCode == 200 && response.data['code'] == 0) {
      return response.data['data'] as Map<String, dynamic>;
    }
    throw Exception('获取蒲公英COSToken失败: ${response.data}');
  }

  static Future<void> _uploadFile(
    String url,
    String path,
    Map<String, dynamic> params,
  ) async {
    final file = File(path);
    final formData = FormData.fromMap({
      ...params,
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    });

    final response = await Dio().post(
      url,
      data: formData,
      onSendProgress: (sent, total) {
        final percentage = (sent / total * 100).toStringAsFixed(1);
        stdout.write('\r上传进度: $percentage%');
      },
    );
    stdout.writeln();
    if (response.statusCode != 204) {
      throw Exception('上传文件到蒲公英COS失败, HTTP status: ${response.statusCode}');
    }
  }

  static Future<void> _pollBuildInfo(
    String buildKey, {
    int maxRetries = 10,
    int currentRetry = 0,
  }) async {
    if (currentRetry >= maxRetries) {
      throw Exception('获取构建信息超时，请稍后前往蒲公英网站查看。');
    }
    await Future.delayed(const Duration(seconds: 3));
    Logger.info('正在查询构建状态 (第 ${currentRetry + 1} 次)...');

    final response = await _dio.post(
      'app/buildInfo',
      data: FormData.fromMap({'_api_key': _pgyerApiKey, 'buildKey': buildKey}),
    );

    if (response.statusCode == 200 && response.data['code'] == 0) {
      final buildData = response.data['data'];
      Logger.success('蒲公英处理完成！');
      Logger.info('应用信息:');
      Logger.info(ENCODER.convert(buildData));
      Logger.info(
        '下载短链接: https://www.pgyer.com/${buildData['buildShortcutUrl']}',
      );
    } else if (response.data['code'] == 1247 || response.data['code'] == 1246) {
      await _pollBuildInfo(
        buildKey,
        maxRetries: maxRetries,
        currentRetry: currentRetry + 1,
      );
    } else {
      throw Exception('获取构建信息失败: ${response.data}');
    }
  }
}

/// S3 上传模块（Signature V4）
abstract final class S3Uploader {
  static Future<String> uploadApk({
    required String filePath,
    required String packageId,
    required String channel,
  }) async {
    final endpoint =
        (Platform.environment['S3_ENDPOINT'] ?? DEFAULT_S3_ENDPOINT).trim();
    var accessKey = (Platform.environment['S3_ACCESS_KEY'] ?? '').trim();
    var secretKey = (Platform.environment['S3_SECRET_KEY'] ?? '').trim();
    final bucket = (Platform.environment['S3_BUCKET'] ?? DEFAULT_S3_BUCKET)
        .trim();
    final region = (Platform.environment['S3_REGION'] ?? DEFAULT_S3_REGION)
        .trim();
    final publicBaseUrl =
        (Platform.environment['S3_PUBLIC_BASE_URL'] ?? endpoint).trim();
    final includeBucketInPublicUrl = _parseBoolEnv(
      Platform.environment['S3_PUBLIC_INCLUDE_BUCKET'],
      fallback: DEFAULT_S3_PUBLIC_INCLUDE_BUCKET,
    );

    if (accessKey.isEmpty) {
      accessKey = await _promptS3AccessKey();
    }
    if (secretKey.isEmpty) {
      secretKey = await _promptS3SecretKey();
    }

    if (accessKey.isEmpty || secretKey.isEmpty || bucket.isEmpty) {
      throw Exception(
        '缺少 S3 配置。请在控制台输入或设置环境变量：S3_ACCESS_KEY、S3_SECRET_KEY、S3_BUCKET（可选 S3_ENDPOINT、S3_REGION）。',
      );
    }

    final endpointUri = Uri.parse(endpoint);
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('待上传文件不存在', filePath);
    }

    final bytes = await file.readAsBytes();
    final fileName = file.path.split(RegExp(r'[\\/]')).last;
    final now = DateTime.now().toUtc();
    final dateStamp = _yyyyMMdd(now);
    final amzDate = _amzDate(now);

    final objectKey = '$packageId/$channel/$dateStamp/$fileName';
    final encodedKey = objectKey.split('/').map(Uri.encodeComponent).join('/');
    final uri = endpointUri.replace(path: '/$bucket/$encodedKey');

    final payloadHash = sha256.convert(bytes).toString();
    final canonicalUri = '/$bucket/$encodedKey';
    final host = endpointUri.hasPort
        ? '${endpointUri.host}:${endpointUri.port}'
        : endpointUri.host;
    final canonicalHeaders =
        'host:$host\nx-amz-content-sha256:$payloadHash\nx-amz-date:$amzDate\n';
    final signedHeaders = 'host;x-amz-content-sha256;x-amz-date';
    final canonicalRequest = [
      'PUT',
      canonicalUri,
      '',
      canonicalHeaders,
      signedHeaders,
      payloadHash,
    ].join('\n');

    final credentialScope = '$dateStamp/$region/s3/aws4_request';
    final stringToSign = [
      'AWS4-HMAC-SHA256',
      amzDate,
      credentialScope,
      sha256.convert(utf8.encode(canonicalRequest)).toString(),
    ].join('\n');

    final signingKey = _getSigningKey(secretKey, dateStamp, region, 's3');
    final signature = _hmacHex(signingKey, stringToSign);
    final authorization =
        'AWS4-HMAC-SHA256 Credential=$accessKey/$credentialScope, SignedHeaders=$signedHeaders, Signature=$signature';

    final httpClient = HttpClient();
    try {
      Logger.info('上传中 (S3, 请耐心等待)...');
      final request = await httpClient.openUrl('PUT', uri);
      request.headers.set(HttpHeaders.hostHeader, host);
      request.headers.set('x-amz-content-sha256', payloadHash);
      request.headers.set('x-amz-date', amzDate);
      request.headers.set(HttpHeaders.authorizationHeader, authorization);
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        'application/vnd.android.package-archive',
      );
      request.contentLength = bytes.length;
      request.add(bytes);

      final response = await request.close();
      final body = await utf8.decodeStream(response);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('S3 上传失败: HTTP ${response.statusCode}, body: $body');
      }
    } finally {
      httpClient.close(force: true);
    }

    final publicUri = _buildPublicUri(
      publicBaseUrl: publicBaseUrl,
      bucket: bucket,
      encodedKey: encodedKey,
      includeBucket: includeBucketInPublicUrl,
    );
    return publicUri.toString();
  }

  static List<int> _getSigningKey(
    String secretKey,
    String dateStamp,
    String region,
    String service,
  ) {
    final kDate = _hmacBytes(utf8.encode('AWS4$secretKey'), dateStamp);
    final kRegion = _hmacBytes(kDate, region);
    final kService = _hmacBytes(kRegion, service);
    return _hmacBytes(kService, 'aws4_request');
  }

  static List<int> _hmacBytes(List<int> key, String data) {
    final hmac = Hmac(sha256, key);
    return hmac.convert(utf8.encode(data)).bytes;
  }

  static String _hmacHex(List<int> key, String data) {
    final hmac = Hmac(sha256, key);
    return hmac.convert(utf8.encode(data)).toString();
  }

  static String _yyyyMMdd(DateTime t) {
    final m = t.month.toString().padLeft(2, '0');
    final d = t.day.toString().padLeft(2, '0');
    return '${t.year}$m$d';
  }

  static String _amzDate(DateTime t) {
    final m = t.month.toString().padLeft(2, '0');
    final d = t.day.toString().padLeft(2, '0');
    final h = t.hour.toString().padLeft(2, '0');
    final min = t.minute.toString().padLeft(2, '0');
    final s = t.second.toString().padLeft(2, '0');
    return '${t.year}$m${d}T$h$min${s}Z';
  }

  static bool _parseBoolEnv(String? raw, {required bool fallback}) {
    if (raw == null) return fallback;
    final value = raw.trim().toLowerCase();
    if (value == '1' || value == 'true' || value == 'yes' || value == 'y')
      return true;
    if (value == '0' || value == 'false' || value == 'no' || value == 'n')
      return false;
    return fallback;
  }

  static Uri _buildPublicUri({
    required String publicBaseUrl,
    required String bucket,
    required String encodedKey,
    required bool includeBucket,
  }) {
    final base = Uri.parse(publicBaseUrl);
    final basePath = base.path.endsWith('/')
        ? base.path.substring(0, base.path.length - 1)
        : base.path;
    final suffix = includeBucket ? '/$bucket/$encodedKey' : '/$encodedKey';
    return base.replace(path: '$basePath$suffix');
  }

  static Future<String> _promptS3AccessKey() async {
    const timeout = Duration(minutes: 10);
    final value = await _ioPromptWithTimeout('请输入 S3_ACCESS_KEY', timeout);
    return value == _TIMED_OUT ? '' : value.trim();
  }

  static Future<String> _promptS3SecretKey() async {
    const timeout = Duration(minutes: 10);
    final value = await _ioPromptWithTimeout('请输入 S3_SECRET_KEY', timeout);
    return value == _TIMED_OUT ? '' : value.trim();
  }
}
