# 设置指南

本文档指导你如何设置为 @mx-space/api-client 创建的独立构建器仓库。

## 1. 创建新仓库

1. 在 GitHub 上创建一个新的空仓库，例如 `mx-space-api-client-builder`
2. 将本目录中的所有文件推送到新仓库

```bash
git init
git add .
git commit -m "Initial commit: MX Space API Client Builder"
git branch -M main
git remote add origin https://github.com/Akuma-real/mx-space-api-client-builder.git
git push -u origin main
```

## 2. 配置仓库设置

### GitHub Secrets 配置

在仓库的 **Settings > Secrets and variables > Actions** 中添加以下密钥：

#### 必须配置的密钥：
- `GITHUB_TOKEN` - GitHub 自动提供，无需手动配置

#### 可选配置的密钥：
- `NPM_TOKEN` - 如果要发布到 NPM，需要配置你的 NPM 访问令牌

### NPM Token 获取方法：
1. 登录 [npmjs.com](https://www.npmjs.com/)
2. 进入 **Access Tokens** 页面
3. 点击 **Generate New Token**
4. 选择 **Automation** 类型
5. 复制生成的 token 并添加到 GitHub Secrets

## 3. 仓库权限设置

### Actions 权限：
1. 进入 **Settings > Actions > General**
2. 在 **Workflow permissions** 部分选择：
   - ✅ **Read and write permissions**
   - ✅ **Allow GitHub Actions to create and approve pull requests**

### Package 权限（如果发布到 GitHub Packages）：
1. 进入 **Settings > Actions > General**
2. 确保 **Workflow permissions** 包含包发布权限

## 4. 测试设置

### 手动触发构建：
1. 进入 **Actions** 页面
2. 选择 **Build and Publish API Client** workflow
3. 点击 **Run workflow**
4. 选择以下选项：
   - **是否发布到 NPM**: false（首次测试建议选择 false）
   - **版本类型**: patch

### 检查构建结果：
1. 等待 workflow 完成
2. 检查 **Artifacts** 中是否有构建产物
3. 查看日志确认构建过程无错误

## 5. 自动化配置

构建器会在以下情况自动运行：
- ✅ 每天 UTC 00:00 检查源码更新
- ✅ 推送到 main 分支时
- ✅ 手动触发时

## 6. 版本发布策略

### 自动版本：
- 定时任务会使用 Git commit hash 创建预发布版本
- 格式：`1.17.0-git-a1b2c3d4.0`

### 手动版本：
- 可选择 patch/minor/major/prerelease
- 会创建对应的 Git tag 和 GitHub Release

## 7. 包发布位置

### GitHub Packages（默认）：
- 包名：`@adminlaowang/mx-space-api-client`
- 安装：`npm install @adminlaowang/mx-space-api-client --registry=https://npm.pkg.github.com`
- 说明：这是从mx-space/core仓库构建的@mx-space/api-client的可安装版本

### NPM（可选）：
- 需要配置 `NPM_TOKEN`
- 包名：`@adminlaowang/mx-space-api-client`
- 安装：`npm install @adminlaowang/mx-space-api-client`
- 说明：为开发者提供便于安装的@mx-space/api-client版本

## 8. 使用发布的包

### 在你的项目中安装：
```bash
# 从 GitHub Packages 安装
npm config set @adminlaowang:registry https://npm.pkg.github.com
npm install @adminlaowang/mx-space-api-client

# 从 NPM 安装（如果已发布）
npm install @adminlaowang/mx-space-api-client
```

### 在代码中使用：
```typescript
import { createClient } from '@adminlaowang/mx-space-api-client';

const client = createClient({
  endpoint: 'https://your-api-endpoint.com'
});
```

## 9. 故障排除

### 构建失败：
1. 检查 Actions 日志中的错误信息
2. 确认源仓库 mx-space/core 的 api-client 目录结构没有改变
3. 检查依赖是否正确安装

### 发布失败：
1. 确认 NPM_TOKEN 配置正确
2. 检查包名是否冲突
3. 确认仓库权限设置正确

### 权限问题：
1. 确认 GITHUB_TOKEN 有足够权限
2. 检查仓库的 Actions 权限设置
3. 确认包发布权限配置

## 10. 自定义配置

可以通过修改 `.github/workflows/build-and-publish.yml` 来自定义：
- 构建频率（修改 cron 表达式）
- Node.js 版本
- 测试配置
- 发布策略

有问题可以查看 Actions 日志或在仓库中创建 Issue。