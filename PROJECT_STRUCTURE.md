# 项目结构说明

本文档说明为 @mx-space/api-client 创建的构建系统项目的完整结构和各文件的作用。

> **项目背景**: 由于 mx-space/core 仓库中的 @mx-space/api-client 包未发布到 npm，此项目为开发者提供了可安装的构建版本 @adminlaowang/mx-space-api-client。

## 📁 项目目录结构

```
mx-space-api-client-builder/
├── .github/
│   └── workflows/
│       └── build-and-publish.yml    # 主要的 GitHub Actions 工作流
├── example/
│   └── usage.md                     # 使用示例文档
├── scripts/
│   └── build.sh                     # 本地构建脚本
├── .gitignore                       # Git 忽略规则
├── last_build_commit.txt            # 记录上次构建的 commit hash
├── package.json                     # 项目配置文件
├── PROJECT_STRUCTURE.md             # 本文件 - 项目结构说明
├── README.md                        # 项目介绍和快速开始
└── SETUP.md                         # 详细设置指南
```

## 📝 文件详细说明

### 🚀 核心文件

#### `.github/workflows/build-and-publish.yml`
- **作用**: GitHub Actions 主工作流文件
- **功能**:
  - 自动检测 mx-space/core 仓库的 api-client 源码更新
  - 下载源码并构建 TypeScript 项目
  - 运行测试和类型检查
  - 发布为 @adminlaowang/mx-space-api-client 到 NPM 和 GitHub Packages
  - 创建 GitHub Release
- **触发条件**:
  - 手动触发 (workflow_dispatch)
  - 定时任务 (每天 UTC 00:00)
  - 推送到 main 分支

#### `scripts/build.sh`
- **作用**: 本地构建脚本
- **功能**:
  - 克隆 mx-space/core 仓库的 api-client 目录
  - 修复 Windows 兼容性问题
  - 安装依赖并构建项目
  - 验证构建输出
- **使用**: `chmod +x scripts/build.sh && ./scripts/build.sh`

### 📋 配置文件

#### `package.json`
- **作用**: 项目包配置文件
- **内容**:
  - 项目元信息 (名称、版本、描述)
  - 脚本命令定义
  - 开发依赖声明
  - 仓库信息

#### `.gitignore`
- **作用**: Git 版本控制忽略规则
- **忽略内容**:
  - 构建输出目录 (dist/, src/, temp/)
  - 依赖目录 (node_modules/)
  - 环境变量文件
  - 临时文件和缓存

#### `last_build_commit.txt`
- **作用**: 记录上次构建的源码 commit hash
- **用途**: 
  - 检测源码是否有更新
  - 避免重复构建相同版本
  - Actions 工作流自动维护

### 📖 文档文件

#### `README.md`
- **作用**: 项目主要介绍文档
- **内容**:
  - 项目概述和功能特性
  - 快速开始指南
  - 使用方法说明
  - 版本策略

#### `SETUP.md`
- **作用**: 详细设置指南
- **内容**:
  - 仓库创建步骤
  - GitHub Secrets 配置
  - 权限设置说明
  - 故障排除指南

#### `example/usage.md`
- **作用**: 使用示例文档
- **内容**:
  - 包安装方法
  - 基本 API 使用示例
  - 不同框架集成示例
  - TypeScript 类型支持

#### `PROJECT_STRUCTURE.md` (本文件)
- **作用**: 项目结构说明文档
- **内容**: 文件组织结构和各文件作用说明

## 🔄 工作流程

### 1. 源码检测
- Actions 定时检查 mx-space/core 仓库的更新
- 比较最新 commit hash 与 `last_build_commit.txt`
- 有更新时触发构建流程

### 2. 源码获取
- 使用 Git sparse-checkout 只克隆 packages/api-client 目录
- 复制源码到构建工作目录
- 清理临时文件

### 3. 环境准备
- 设置 Node.js 环境 (支持多版本测试)
- 安装 pnpm 包管理器
- 修复 Windows 命令兼容性问题

### 4. 项目构建
- 安装项目依赖 (`pnpm install`)
- 运行测试套件 (`npm test`)
- 执行构建命令 (`npm run build`)
- 验证构建输出文件

### 5. 包发布
- 准备发布包文件
- 更新版本号 (基于 commit hash 或手动指定)
- 发布到 GitHub Packages (默认)
- 发布到 NPM (可选，需配置 token)

### 6. 发布记录
- 创建 GitHub Release 和 Git tag
- 更新构建记录文件
- 上传构建产物作为 Artifacts

## 🔧 自定义配置

### 修改构建频率
编辑 `.github/workflows/build-and-publish.yml` 中的 cron 表达式:
```yaml
schedule:
  - cron: '0 0 * * *'  # 每天 UTC 00:00
```

### 修改 Node.js 版本
更新 strategy.matrix.node-version:
```yaml
strategy:
  matrix:
    node-version: [18.x, 20.x, 22.x]
```

### 添加额外的构建步骤
在构建作业中添加新的 steps:
```yaml
- name: 自定义步骤
  run: |
    echo "执行自定义操作"
```

## 🛠️ 维护说明

### 定期检查
- 监控 Actions 运行状态
- 检查构建日志和错误信息
- 关注源仓库结构变化

### 依赖更新
- 定期更新 Actions 版本 (actions/checkout, actions/setup-node 等)
- 更新 Node.js 版本支持
- 关注 mx-space/core 的依赖变化

### 故障处理
- 查看 Actions 日志分析错误
- 检查源仓库的结构变化
- 更新兼容性修复脚本

## 🔗 相关资源

- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [NPM 发布指南](https://docs.npmjs.com/packages-and-modules/contributing-packages-to-the-registry)
- [GitHub Packages 文档](https://docs.github.com/en/packages)
- [MX Space 官方仓库](https://github.com/mx-space/core)

这个项目结构设计使得整个构建和发布流程完全自动化，同时保持了足够的灵活性供用户自定义配置。