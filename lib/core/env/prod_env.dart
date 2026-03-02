import 'env.dart';

/// 生产环境配置。
class ProdEnv implements Env {
  @override
  String get title => 'Flutter Base';

  @override
  String get apiBaseUrl => 'http://111.9.22.231:50511';

  @override
  bool get debug => false;
}
