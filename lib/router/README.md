# Router 维护约定

## 目标
- 路由定义集中在 `lib/router/` 目录，避免散落到 `modules/**`。
- 路由按模块拆分为“一个模块一个文件”，统一使用 `Get.to/Get.off/Get.offAll` 页面跳转。

## 目录约定
- `app_pages.dart`：只做启动页聚合（`home` + `initialBinding`）。
- `module_routes/*.dart`：按模块拆分导航封装，一个模块一个文件，文件内维护：
  - 页面跳转方法（如 `to/off/offAll`）
  - 页面与 `Binding` 的关联
  - 示例：`module_routes/splash_routes.dart`

## 新增模块路由步骤
1. 在 `module_routes/` 下新增对应文件（如 `order_routes.dart`）。
2. 在该文件中声明 `to/off/offAll` 等导航方法，并绑定对应 `Binding`。
3. 在 `app_pages.dart` 中维护应用启动页与初始化 `Binding`。
4. 跨模块跳转时，调用目标模块的 `XxxRoutes` 方法，禁止使用命名路由字符串。
