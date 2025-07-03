# MX Space API Client Builder

这是一个专门用于构建和发布 `@adminlaowang/mx-space-api-client` 包的独立仓库。

> **项目说明**: 这是为未发布的 `@mx-space/api-client` 创建的构建系统。由于原始包在mx-space/core仓库中但未发布到npm，本项目为开发者提供了可安装的版本。

## 功能特性

- ✅ 自动从 [mx-space/core](https://github.com/mx-space/core) 仓库获取最新的 api-client 源码
- ✅ 自动构建 TypeScript 项目并生成类型声明文件
- ✅ 自动发布到 NPM 或 GitHub Packages
- ✅ 支持版本管理和标签发布
- ✅ 多 Node.js 版本测试

## 使用方法

### 手动触发构建

1. 进入 Actions 页面
2. 选择 "Build and Publish API Client" workflow
3. 点击 "Run workflow"
4. 选择是否发布到 NPM

### 自动构建

- 每天 UTC 00:00 自动检查源码更新并构建
- 当检测到源码变化时自动触发构建

## 环境变量配置

在仓库的 Settings > Secrets and variables > Actions 中配置以下环境变量：

- `NPM_TOKEN`: NPM 发布令牌（可选，用于发布到 NPM）
- `GITHUB_TOKEN`: GitHub 访问令牌（自动提供）

## 本地开发

```bash
# 克隆仓库
git clone https://github.com/Akuma-real/mx-space-api-client-builder.git
cd mx-space-api-client-builder

# 运行构建脚本
chmod +x scripts/build.sh
./scripts/build.sh
```

## 构建输出

构建完成后，产物将保存在：
- `dist/` - 编译后的 JavaScript 文件
- `types/` - TypeScript 类型声明文件
- `package/` - 打包后的 NPM 包文件

## 版本策略

- 版本号基于源码的 Git commit hash
- 支持语义化版本号
- 自动生成 changelog