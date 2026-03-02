import 'env.dart';

/// 开发环境配置。
class DevEnv implements Env {
  @override
  String get title => '[DEV] Flutter Base';

  @override
  String get apiBaseUrl => 'http://111.9.22.231:50511';

  @override
  bool get debug => true;
}
