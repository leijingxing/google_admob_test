/// [功能]: 环境配置抽象，约束各环境必须提供的配置项。
abstract class Env {
  /// 应用标题。
  String get title;

  /// 接口基础地址。
  String get apiBaseUrl;

  /// 是否调试模式。
  bool get debug;
}

/// [功能]: 全局环境管理器（单例）。
/// [说明]: 应用启动时调用 [init] 一次，后续通过 [currentEnv] 读取。
class Environment {
  Environment._internal();

  static final Environment _instance = Environment._internal();

  factory Environment() => _instance;

  late Env _env;

  /// 注册当前环境配置。
  void init(Env env) {
    _env = env;
  }

  /// 获取当前环境。
  static Env get currentEnv => _instance._env;
}
