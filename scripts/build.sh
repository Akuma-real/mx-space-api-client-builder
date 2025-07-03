#!/bin/bash

# MX Space API Client 构建脚本
set -e

echo "🚀 开始构建 @mx-space/api-client..."

# 配置
SOURCE_REPO="mx-space/core"
SOURCE_PATH="packages/api-client"
BUILD_DIR="src"
OUTPUT_DIR="dist"

# 清理旧文件
echo "🧹 清理旧文件..."
rm -rf $BUILD_DIR $OUTPUT_DIR temp

# 创建目录
mkdir -p $BUILD_DIR temp

echo "📥 下载源码..."
cd temp

# 克隆源仓库
git clone --depth 1 --filter=blob:none --sparse https://github.com/$SOURCE_REPO.git
cd core
git sparse-checkout set $SOURCE_PATH

# 复制源码
cp -r $SOURCE_PATH/* ../../$BUILD_DIR/
cd ../../

# 清理临时文件
rm -rf temp

echo "🔧 修复 Windows 兼容性..."
cd $BUILD_DIR

# 修复 package.json 中的命令
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    # Windows 环境
    sed -i 's/rm -rf dist/rmdir \/s \/q dist 2>nul || echo ""/g' package.json
else
    # Unix 环境保持原样
    echo "Unix 环境，保持原有命令"
fi

# 确保使用 npx 运行 tsup
sed -i 's/ tsup/ npx tsup/g' package.json

echo "📦 安装依赖..."
npm install

echo "🧪 运行测试..."
npm test || echo "⚠️  测试失败，继续构建..."

echo "🔨 构建项目..."
npm run build

echo "✅ 检查构建输出..."
if [ -d "dist" ]; then
    echo "📁 dist 目录内容:"
    ls -la dist/
    
    if [ -f "dist/index.js" ]; then
        echo "✅ index.js 存在"
    else
        echo "❌ index.js 缺失"
        exit 1
    fi
    
    if [ -f "dist/index.d.ts" ]; then
        echo "✅ index.d.ts 存在"
    else
        echo "❌ index.d.ts 缺失"
        exit 1
    fi
else
    echo "❌ dist 目录不存在"
    exit 1
fi

# 复制到输出目录
echo "📋 准备发布包..."
cd ..
mkdir -p $OUTPUT_DIR
cp -r $BUILD_DIR/dist/* $OUTPUT_DIR/
cp $BUILD_DIR/package.json $OUTPUT_DIR/
cp $BUILD_DIR/README.md $OUTPUT_DIR/ 2>/dev/null || echo "README.md 不存在"

echo "🎉 构建完成！"
echo "📦 构建产物位于: $OUTPUT_DIR/"
echo "📄 包信息:"
cd $OUTPUT_DIR
npm pack --dry-run