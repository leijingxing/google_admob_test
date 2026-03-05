import 'env.dart';

/// 开发环境配置。
class DevEnv implements Env {
  @override
  String get title => '[DEV] 封闭化';

  @override
  String get apiBaseUrl => 'http://10.1.34.16:31641';

  @override
  String get appCode => 'closed-off-mgt';

  @override
  bool get debug => true;
}
