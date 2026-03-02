# build_ci.dart S3 上传配置说明

本文档用于配置 `ci/build_ci.dart` 的公司 S3 上传参数。

## 1. 当前会话临时生效（推荐先用这个验证）

在 PowerShell 执行：

```shell
$env:S3_ENDPOINT="http://111.9.22.231:50134"
$env:S3_ACCESS_KEY="PRPXPXC1190RAGKDG45X"
$env:S3_SECRET_KEY="2Ug4HRryOSypBMfwA1PsF7dvx31ZRB14LuFJ3FFu"
$env:S3_BUCKET="app"
$env:S3_REGION="us-east-1"
```

然后执行构建脚本：

```powershell
D:/flutter_3_32_4/flutter/bin/cache/dart-sdk/bin/dart.exe --enable-asserts --no-serve-devtools D:/FlutterProject/flutter_base/ci/build_ci.dart
```

## 2. 永久生效（新终端也可用）

在 PowerShell 执行：

```powershell
setx S3_ENDPOINT "http://111.9.22.231:50134"
setx S3_ACCESS_KEY "PRPXPXC1190RAGKDG45X"
setx S3_SECRET_KEY "2Ug4HRryOSypBMfwA1PsF7dvx31ZRB14LuFJ3FFu"
setx S3_BUCKET "你的bucket名"
setx S3_REGION "us-east-1"
```

执行后请关闭并重新打开终端，再运行脚本。

## 3. 参数说明

- `S3_ENDPOINT`：S3 服务地址（公司生产地址）。
- `S3_ACCESS_KEY`：S3 访问 Key。
- `S3_SECRET_KEY`：S3 密钥。
- `S3_BUCKET`：目标 bucket 名称（必填）。
- `S3_REGION`：区域，默认 `us-east-1`。

## 4. 常见问题

- 报错缺少配置：确认 `S3_ACCESS_KEY`、`S3_SECRET_KEY`、`S3_BUCKET` 是否已设置。
- 上传 403：确认 AK/SK 是否有效，bucket 权限是否允许 `PutObject`。
- 路径找不到：确认在项目根目录执行脚本。
