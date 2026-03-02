// ci/build.dart

// ignore_for_file: avoid_print, constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

// --- 脚本配置常量 (请根据你的实际情况修改) ---

/// 上传 Apk 的私有服务器相关配置
// 注意：这里将端口修改为 Go 应用的端口 1234
const SERVER_IP = '172.18.254.96'; // 如果 Go 应用运行在本地，可以改为 'localhost' 或 '127.0.0.1'
const GO_APP_PORT = 1234; // Go 应用的端口号

// WAN_SERVER_IP 保持不变，用于通知中的外部访问链接，如果 Go 应用有外部 IP，可以修改
const WAN_SERVER_IP = 'https://blog.u2828180.nyat.app:46793';

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
  _broadcastStdin = stdin.transform(utf8.decoder).transform(const LineSplitter()).asBroadcastStream();

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
  final String flavor;
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
    required this.entryPoint,
    required this.appName,
    required this.finalPackageId,
    required this.finalApkPath,
  });

  /// 从命令行参数和本地配置自动创建构建配置
  static Future<BuildConfig> fromArgs(List<String> args) async {
    // 1. 从 .run/*.xml 文件中选择一个运行配置
    final runConfig = await RunConfig.selectFromLocal();
    Logger.success('已选择构建配置: ${runConfig.name} (Flavor: ${runConfig.flavor})');

    // 2. 基于选择的 flavor，从 build.gradle.kts 解析详细信息
    final appName = await GradleParser.getAppName(runConfig.flavor) ?? runConfig.name;
    final packageId = await GradleParser.getFinalPackageId(runConfig.flavor);

    // 3. 确定最终构建产物的路径
    // Flutter 3.19+ aab/apk产物默认带flavor和build mode
    // e.g., build/app/outputs/flutter-apk/app-dev-release.apk
    final apkPath = 'build/app/outputs/flutter-apk/app-${runConfig.flavor}-release.apk';

    return BuildConfig(
      flavor: runConfig.flavor,
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
    Logger.info('开始构建APK (Flavor: ${config.flavor})...');

    final flutterBin = _getFlutterSdkPath() ?? 'flutter';
    // 新的构建命令，使用 flavor 和 target
    final buildArgs = [
      'build',
      'apk',
      '--release',
      '--flavor',
      config.flavor,
      '-t',
      config.entryPoint,
    ];

    Logger.info('执行命令: $flutterBin ${buildArgs.join(' ')}');

    final process = await Process.start(flutterBin, buildArgs, runInShell: true);
    final stdoutSubscription = process.stdout.transform(utf8.decoder).listen(Logger.info);
    final stderrSubscription = process.stderr.transform(utf8.decoder).listen(Logger.error);

    final exitCode = await process.exitCode;
    await stdoutSubscription.cancel();
    await stderrSubscription.cancel();

    if (exitCode != 0) {
      throw ProcessException(flutterBin, buildArgs, 'Flutter构建失败，退出码: $exitCode', exitCode);
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
      await _performCustomServerUpload(apkFile, updateLog);
    }
  }

  /// 提示用户输入更新日志
  Future<String> _promptForUpdateLog() async {
    String suggestedLog = '常规优化及Bug修复';
    Logger.info('正在获取最新的 Git 提交日志...');
    try {
      final result = await Process.run('git', ['log', '-1', '--pretty=%B'], stdoutEncoding: utf8, stderrEncoding: utf8);
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
    final input = (await _ioPromptWithTimeout(prompt, timeout)).toLowerCase().trim();

    if (input == _TIMED_OUT) {
      Logger.info('输入超时，将自动选择 "y"。');
      return false;
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

  /// 执行自定义服务器上传
  Future<void> _performCustomServerUpload(File apkFile, String updateLog) async {
    Logger.info('开始上传到自定义服务器...');
    await _uploadToCustomServer(apkFile, updateLog);
    Logger.success('上传到自定义服务器成功！');

    final size = await apkFile.length() / 1024 / 1024;
    final buildTime = _fmtTime(DateTime.now());

    // 自定义服务器的下载链接结构
    final detailPageUrl = 'http://$SERVER_IP:$GO_APP_PORT/app/${config.finalPackageId}';
    final publicDownloadUrl = '$WAN_SERVER_IP/app/${config.finalPackageId}';

    final results = <String, dynamic>{
      '项目': config.appName,
      '环境': config.flavor,
      '大小': '${size.toStringAsFixed(2)}MB',
      '包名': config.finalPackageId,
      '构建时间': buildTime,
      '更新日志': updateLog,
      '下载链接': '[内网](${Uri.encodeFull(detailPageUrl)})  [外网](${Uri.encodeFull(publicDownloadUrl)})',
    };

    Logger.info('构建结果详情:');
    Logger.info(ENCODER.convert(results));
    await _sendWeChatNotification(results);
  }

  /// 上传文件到自定义服务器的具体实现
  Future<void> _uploadToCustomServer(File apkFile, String updateLog) async {
    Logger.info('上传中 (请耐心等待)...');
    try {
      final dio = Dio();
      final originalFilename = apkFile.path.split(Platform.pathSeparator).last;

      final formData = FormData.fromMap({
        'projectName': config.appName,
        'channel': config.flavor, // 使用 flavor 作为 channel
        'releaseNotes': updateLog,
        'source': 'app', // 你可以自定义这个字段
        'file': await MultipartFile.fromFile(
          apkFile.path,
          filename: originalFilename,
          contentType: MediaType('application', 'vnd.android.package-archive'),
        ),
      });

      final resp = await dio.post(
        'http://$SERVER_IP:$GO_APP_PORT/api/upload', // 自定义服务器的上传接口
        data: formData,
        onSendProgress: (sent, total) {
          if (total != -1) {
            final percentage = (sent / total * 100).toStringAsFixed(1);
            stdout.write('\r上传进度: $percentage%');
          }
        },
      );
      stdout.writeln(); // 进度条完成后换行

      if (resp.statusCode == 200) {
        Logger.info('上传成功，服务器响应: ${resp.data}');
      } else {
        throw Exception('服务器返回错误: ${resp.statusCode}, ${resp.data}');
      }
    } catch (e) {
      Logger.error('上传到自定义服务器时发生错误: $e');
      rethrow;
    }
  }

  /// 发送企业微信通知
  Future<void> _sendWeChatNotification(Map<String, dynamic> data) async {
    const prompt = '是否发送企业微信消息 (y/n, 默认 y)';
    const timeout = Duration(seconds: 30);
    final input = (await _ioPromptWithTimeout(prompt, timeout)).toLowerCase().trim();

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

  /// 获取指定 Flavor 的最终包名
  static Future<String> getFinalPackageId(String flavor) async {
    final content = await _getGradleContent();

    // 1. 获取默认包名
    final baseIdMatch = RegExp(r'applicationId\s*=\s*"([^"]+)"').firstMatch(content);
    final baseId = baseIdMatch?.group(1);
    if (baseId == null) throw Exception('在 build.gradle.kts 中找不到默认的 applicationId');

    // 2. 查找指定 flavor 的配置块
    final flavorBlockMatch = RegExp('create\\("$flavor"\\)\\s*\\{([\\s\\S]*?)\\}').firstMatch(content);
    if (flavorBlockMatch == null) {
      // 如果没有找到独立的 flavor 块 (例如 prod flavor 可能直接使用默认值)，则返回基础ID
      return baseId;
    }

    final flavorBlock = flavorBlockMatch.group(1)!;

    // 3. 查找 applicationIdSuffix
    final suffixMatch = RegExp(r'applicationIdSuffix\s*=\s*"([^"]+)"').firstMatch(flavorBlock);
    if (suffixMatch != null) {
      return '$baseId${suffixMatch.group(1)}';
    }

    // 4. 查找完整的 applicationId 覆盖
    final overrideMatch = RegExp(r'applicationId\s*=\s*"([^"]+)"').firstMatch(flavorBlock);
    if (overrideMatch != null) {
      return overrideMatch.group(1)!;
    }

    // 5. 如果都没有，返回基础ID
    return baseId;
  }

  /// 获取指定 Flavor 的应用名称
  static Future<String?> getAppName(String flavor) async {
    final content = await _getGradleContent();
    final flavorBlockMatch = RegExp('create\\("$flavor"\\)\\s*\\{([\\s\\S]*?)\\}').firstMatch(content);
    if (flavorBlockMatch == null) return null;

    final flavorBlock = flavorBlockMatch.group(1)!;
    final appNameMatch = RegExp(r'resValue\("string",\s*"app_name",\s*"([^"]+)"\)').firstMatch(flavorBlock);

    return appNameMatch?.group(1);
  }
}

/// 解析 .run/*.xml IDEA/Android Studio 运行配置
class RunConfig {
  final String name;
  final String flavor;
  final String entryPoint;

  const RunConfig({required this.name, required this.flavor, required this.entryPoint});

  static final _nameReg = RegExp(r'<configuration .*name="([^"]+)"');
  static final _flavorReg = RegExp(r'<option name="buildFlavor" value="([^"]+)" />');
  static final _entryPointReg = RegExp(r'<option name="filePath" value="\$PROJECT_DIR\$([^"]+)" />');

  /// 从文件中解析配置
  static RunConfig? fromFile(File file) {
    final content = file.readAsStringSync();
    final name = _nameReg.firstMatch(content)?.group(1);
    final flavor = _flavorReg.firstMatch(content)?.group(1);
    final entryPoint = _entryPointReg.firstMatch(content)?.group(1)?.substring(1); // 移除开头的 '/'

    if (name != null && flavor != null && entryPoint != null) {
      return RunConfig(name: name, flavor: flavor, entryPoint: entryPoint);
    }
    return null;
  }

  /// 从本地 .run 目录中扫描并让用户选择一个配置
  static Future<RunConfig> selectFromLocal() async {
    final dir = Directory('.run');
    if (!await dir.exists()) throw const FileSystemException('找不到 .run 目录');

    final files = await dir.list().where((f) => f.path.endsWith('.run.xml')).toList();
    if (files.isEmpty) throw const FileSystemException('在 .run/ 目录中未找到任何 *.run.xml 配置文件');

    final configs = files.map((f) => fromFile(File(f.path))).whereType<RunConfig>().toList();
    if (configs.isEmpty) throw Exception('在 .run/ 目录中未找到有效的 Flutter 运行配置');
    if (configs.length == 1) return configs.first;

    Logger.prompt('检测到多个运行配置，请选择一个:');
    for (var i = 0; i < configs.length; i++) {
      Logger.info('$i: ${configs[i].name} (Flavor: ${configs[i].flavor})');
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
  static final _dio = Dio(BaseOptions(
    headers: {'Content-Type': 'application/json'},
    validateStatus: (status) => status != null && status < 500,
  ));

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
  static const String _pgyerApiKey = '51703a1d7b85abc64a6727ab4a9d7812'; // TODO: 替换为你的蒲公英 API Key
  // ... (此类与你之前的脚本完全相同，这里省略了具体实现以保持简洁，你可以直接复制过来)
  // ... (请确保将 _getCOSToken, _uploadFile, _pollBuildInfo 等方法完整复制)
  static final _dio = Dio(BaseOptions(
    baseUrl: 'https://www.pgyer.com/apiv2/',
    headers: {'Content-Type': 'multipart/form-data'},
  ));

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

  static Future<Map<String, dynamic>> _getCOSToken(String? updateDescription) async {
    final response = await _dio.post('app/getCOSToken', data: FormData.fromMap({
      '_api_key': _pgyerApiKey,
      'buildType': 'android',
      'buildInstallType': 1,
      if (updateDescription != null) 'buildUpdateDescription': updateDescription,
    }));
    if (response.statusCode == 200 && response.data['code'] == 0) {
      return response.data['data'] as Map<String, dynamic>;
    }
    throw Exception('获取蒲公英COSToken失败: ${response.data}');
  }

  static Future<void> _uploadFile(String url, String path, Map<String, dynamic> params) async {
    final file = File(path);
    final formData = FormData.fromMap({
      ...params,
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    });

    final response = await Dio().post(url, data: formData, onSendProgress: (sent, total) {
      final percentage = (sent / total * 100).toStringAsFixed(1);
      stdout.write('\r上传进度: $percentage%');
    });
    stdout.writeln();
    if (response.statusCode != 204) {
      throw Exception('上传文件到蒲公英COS失败, HTTP status: ${response.statusCode}');
    }
  }

  static Future<void> _pollBuildInfo(String buildKey, {int maxRetries = 10, int currentRetry = 0}) async {
    if (currentRetry >= maxRetries) {
      throw Exception('获取构建信息超时，请稍后前往蒲公英网站查看。');
    }
    await Future.delayed(const Duration(seconds: 3));
    Logger.info('正在查询构建状态 (第 ${currentRetry + 1} 次)...');

    final response = await _dio.post('app/buildInfo', data: FormData.fromMap({
      '_api_key': _pgyerApiKey,
      'buildKey': buildKey,
    }));

    if (response.statusCode == 200 && response.data['code'] == 0) {
      final buildData = response.data['data'];
      Logger.success('蒲公英处理完成！');
      Logger.info('应用信息:');
      Logger.info(ENCODER.convert(buildData));
      Logger.info('下载短链接: https://www.pgyer.com/${buildData['buildShortcutUrl']}');
    } else if (response.data['code'] == 1247 || response.data['code'] == 1246) {
      await _pollBuildInfo(buildKey, maxRetries: maxRetries, currentRetry: currentRetry + 1);
    } else {
      throw Exception('获取构建信息失败: ${response.data}');
    }
  }
}
