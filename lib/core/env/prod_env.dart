import 'env.dart';

/// 生产环境配置。
class ProdEnv implements Env {
  @override
  String get title => 'Google AdMob Demo';

  @override
  String get apiBaseUrl => 'http://111.9.22.231:50511';

  @override
  String get appCode => 'closed-off-mgt';

  @override
  bool get debug => false;
}
