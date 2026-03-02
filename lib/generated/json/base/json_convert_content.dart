// ignore_for_file: avoid_dynamic_calls

/// 轻量版 JsonConvert，占位对齐老项目接口签名。
/// 业务接入真实模型后，可替换为代码生成产物。
class JsonConvert {
  static M? fromJsonAsT<M>(dynamic json) {
    if (json is M) {
      return json;
    }
    if (M == dynamic) {
      return json as M?;
    }
    if (M.toString().startsWith('Map<') && json is Map) {
      return Map<String, dynamic>.from(json) as M;
    }
    if (M.toString().startsWith('List<') && json is List) {
      return json as M;
    }
    return null;
  }
}
