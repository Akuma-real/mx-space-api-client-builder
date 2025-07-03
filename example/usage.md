# 使用示例

本文档展示如何在你的项目中使用构建好的 @adminlaowang/mx-space-api-client 包。

> **包说明**: 这是从mx-space/core仓库构建的@mx-space/api-client的可安装版本。由于原始包未发布到npm，本项目为开发者提供了便于使用的构建版本。

## 安装

### 从 GitHub Packages 安装
```bash
# 配置 npm registry
npm config set @adminlaowang:registry https://npm.pkg.github.com

# 安装包
npm install @adminlaowang/mx-space-api-client
```

### 从 NPM 安装（如果已发布）
```bash
npm install @adminlaowang/mx-space-api-client
```

## 基本使用

### 创建客户端
```typescript
import { createClient } from '@adminlaowang/mx-space-api-client';

const client = createClient({
  endpoint: 'https://your-mx-space-api.com'
});
```

### 获取文章列表
```typescript
// 获取所有文章
const posts = await client.post.getList();

// 获取分页文章
const paginatedPosts = await client.post.getList({
  page: 1,
  size: 10
});
```

### 获取单篇文章
```typescript
// 通过 ID 获取
const post = await client.post.getById('post-id');

// 通过 slug 获取
const post = await client.post.getBySlug('post-slug');
```

### 获取分类
```typescript
// 获取所有分类
const categories = await client.category.getList();

// 获取特定分类的文章
const categoryPosts = await client.category.getPostsBySlug('category-slug');
```

### 搜索功能
```typescript
// 搜索文章
const searchResults = await client.search.searchPost({
  keyword: '搜索关键词'
});
```

## 认证使用

### 配置认证
```typescript
const client = createClient({
  endpoint: 'https://your-mx-space-api.com',
  // 添加认证配置
  getAuthorizationToken: () => {
    return localStorage.getItem('auth_token');
  }
});
```

### 管理员操作
```typescript
// 创建文章（需要认证）
const newPost = await client.post.create({
  title: '新文章标题',
  text: '文章内容',
  categoryId: 'category-id'
});

// 更新文章
const updatedPost = await client.post.update('post-id', {
  title: '更新后的标题'
});

// 删除文章
await client.post.delete('post-id');
```

## 错误处理

```typescript
import { RequestError } from '@adminlaowang/mx-space-api-client';

try {
  const post = await client.post.getById('invalid-id');
} catch (error) {
  if (error instanceof RequestError) {
    console.error('API 错误:', error.message);
    console.error('状态码:', error.status);
    console.error('响应数据:', error.response);
  } else {
    console.error('未知错误:', error);
  }
}
```

## TypeScript 支持

```typescript
import {
  createClient,
  HTTPClient,
  PostModel,
  CategoryModel
} from '@adminlaowang/mx-space-api-client';

// 客户端类型
const client: HTTPClient = createClient({
  endpoint: 'https://your-mx-space-api.com'
});

// 数据模型类型
const post: PostModel = await client.post.getById('post-id');
const category: CategoryModel = await client.category.getById('category-id');
```

## 在不同框架中使用

### Vue.js
```typescript
// composables/useMxSpace.ts
import { createClient } from '@adminlaowang/mx-space-api-client';
import { ref, onMounted } from 'vue';

export function useMxSpace() {
  const client = createClient({
    endpoint: 'https://your-mx-space-api.com'
  });

  const posts = ref([]);
  const loading = ref(false);

  const fetchPosts = async () => {
    loading.value = true;
    try {
      posts.value = await client.post.getList();
    } catch (error) {
      console.error('获取文章失败:', error);
    } finally {
      loading.value = false;
    }
  };

  onMounted(fetchPosts);

  return {
    posts,
    loading,
    fetchPosts
  };
}
```

### React
```typescript
// hooks/useMxSpace.ts
import { createClient } from '@adminlaowang/mx-space-api-client';
import { useState, useEffect } from 'react';

const client = createClient({
  endpoint: 'https://your-mx-space-api.com'
});

export function useMxSpace() {
  const [posts, setPosts] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchPosts = async () => {
      try {
        const data = await client.post.getList();
        setPosts(data);
      } catch (error) {
        console.error('获取文章失败:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchPosts();
  }, []);

  return { posts, loading };
}
```

### Next.js (App Router)
```typescript
// app/posts/page.tsx
import { createClient } from '@adminlaowang/mx-space-api-client';

const client = createClient({
  endpoint: 'https://your-mx-space-api.com'
});

export default async function PostsPage() {
  const posts = await client.post.getList();

  return (
    <div>
      <h1>文章列表</h1>
      {posts.map((post) => (
        <article key={post.id}>
          <h2>{post.title}</h2>
          <p>{post.summary}</p>
        </article>
      ))}
    </div>
  );
}
```

## 配置选项

```typescript
const client = createClient({
  // API 端点
  endpoint: 'https://your-mx-space-api.com',
  
  // 超时时间（毫秒）
  timeout: 10000,
  
  // 自定义请求头
  headers: {
    'Custom-Header': 'value'
  },
  
  // 认证令牌获取函数
  getAuthorizationToken: () => {
    return localStorage.getItem('auth_token');
  },
  
  // 请求拦截器
  onRequest: (config) => {
    console.log('发送请求:', config);
    return config;
  },
  
  // 响应拦截器
  onResponse: (response) => {
    console.log('收到响应:', response);
    return response;
  },
  
  // 错误处理
  onError: (error) => {
    console.error('请求错误:', error);
    throw error;
  }
});
```

## 更多资源

- [API 文档](https://github.com/mx-space/core)
- [MX Space 官网](https://mx-space.js.org/)
- [示例项目](https://github.com/mx-space/mx-web)