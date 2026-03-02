import 'env.dart';

/// 生产环境配置。
class ProdEnv implements Env {
  @override
  String get title => 'Flutter Base';

  @override
  String get apiBaseUrl => 'https://example.com';

  @override
  bool get debug => false;
}
