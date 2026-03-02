---
name: flutter-project-guidelines
description: Enforce flutter_base project architecture and coding constraints for feature development, refactor, bugfix, model/repository updates, and AI-generated code review. Use when working in this repository to keep GetX layering, HttpService flow, parser rules, codegen boundaries, and quality gates consistent.
---

# Flutter Project Guidelines

遵循本仓库规范完成 Flutter 业务开发任务。  
在实现前后都读取并执行 [`references/project_rules.md`](references/project_rules.md)。

## Workflow

1. 读取项目规则并识别本次任务涉及的约束（分层、GetX、网络、模型、生成文件、质量门禁）。
2. 设计改动时优先复用现有 `core/` 与 `data/` 能力，禁止在 `modules/**` 直接实现网络细节。
3. 实现时保持 Controller/Binding 分文件，依赖注入通过 Binding，避免在 View 中 `Get.put` 页面级 Controller。
4. 模型和仓库改动严格使用显式 parser；列表接口显式解析 `List<T>`，禁止 `dynamic` 透传 UI。
5. 若涉及模型、资源、序列化，执行代码生成；完成后执行静态检查并汇报结果。

## Output Contract

1. 先给出改动摘要，再给出关键文件与原因。
2. 明确列出执行过的验证命令及结果。
3. 若无法执行命令，明确说明阻塞原因与替代验证。
4. 严禁建议或提交手改生成文件。

## Required Checks

按任务范围选择并执行：

- `flutter analyze`
- `dart run build_runner build --delete-conflicting-outputs`
- `dart format --set-exit-if-changed .`

如果任务只改文档，可跳过代码检查，但需要在结果中声明。
