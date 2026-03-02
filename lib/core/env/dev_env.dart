import 'env.dart';

/// 开发环境配置。
class DevEnv implements Env {
  @override
  String get title => '[DEV] Flutter Base';

  @override
  String get apiBaseUrl => 'https://example-dev.com';

  @override
  bool get debug => true;
}
