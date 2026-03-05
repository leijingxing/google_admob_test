import '../env/env.dart';
import 'user_manager.dart';

/// 图片相关工具：统一处理 URL 拼接与鉴权请求头。
class ImageFileUtil {
  ImageFileUtil._();

  /// 将后端返回的图片标识转换为可访问的完整 URL。
  ///
  /// 兼容以下场景：
  /// - 完整 http/https 链接：原样返回
  /// - 文件 id：拼接为 `/api/system/file/download/{id}`
  /// - 以 `/` 开头路径：拼接 `apiBaseUrl`
  /// - 相对路径：拼接 `apiBaseUrl/xxx`
  static String? buildImageUrl(String? rawValue) {
    final raw = (rawValue ?? '').trim();
    if (raw.isEmpty || raw == '-' || raw.toLowerCase() == 'null') return null;
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;

    final base = Environment.currentEnv.apiBaseUrl.trim();
    if (base.isEmpty) return null;

    if (!raw.contains('/') && !raw.contains('.')) {
      return '$base/api/system/file/download/$raw';
    }
    if (raw.startsWith('/')) return '$base$raw';
    return '$base/$raw';
  }

  /// 网络图片请求头（用于需要 token 才能访问图片的场景）。
  static Map<String, String>? imageHeaders() {
    final token = (UserManager.token ?? '').trim();
    if (token.isEmpty) return null;
    return {'Authorization': token};
  }
}
