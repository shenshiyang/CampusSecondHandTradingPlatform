<template>
  <div class="posts-detail">
    <!-- 骨架屏 -->
    <template v-if="loading">
      <el-card shadow="hover" class="post-card skeleton-card">
        <el-skeleton :rows="6" animated>
          <template slot="template">
            <el-skeleton-item variant="h1" style="width: 80%; margin: 0 auto 20px;" />
            <div style="text-align: center; margin-bottom: 30px;">
              <el-skeleton-item variant="text" style="width: 30%; margin: 0 10px;" />
              <el-skeleton-item variant="text" style="width: 30%; margin: 0 10px;" />
              <el-skeleton-item variant="text" style="width: 30%; margin: 0 10px;" />
            </div>
            <el-skeleton-item variant="p" style="margin-bottom: 15px;" v-for="i in 6" :key="i" />
          </template>
        </el-skeleton>
      </el-card>
    </template>

    <!-- 帖子内容 -->
    <template v-else>
      <el-card shadow="hover" class="post-card">
        <div class="post-header">
          <h1 class="post-title">{{ posts.title }}</h1>
          
          <div class="post-meta">
            <div class="meta-item">
              <i class="el-icon-user" />
              <span>{{ posts.userName }}</span>
            </div>
            <div class="meta-divider"></div>
            <div class="meta-item">
              <i class="el-icon-time" />
              <span>{{ posts.time }}</span>
            </div>
            <div class="meta-divider"></div>
            <div class="meta-item">
              <i class="el-icon-reading" />
              <span>{{ posts.readCount }} 次阅读</span>
            </div>
          </div>
        </div>

        <!-- 富文本内容 -->
        <div class="post-content-wrapper">
          <div
            class="post-content w-e-text"
            v-html="posts.content"
          />
        </div>
      </el-card>

      <!-- 评论区 -->
      <el-card shadow="hover" class="comment-card">
        <div class="comment-header">
          <i class="el-icon-chat-line-round"></i>
          <span>评论区</span>
        </div>
        <Comment :fid="id" module="posts" />
      </el-card>
    </template>
  </div>
</template>

<script>
import Comment from '@/components/Comment'

export default {
  name: 'PostsDetail',
  components: { Comment },
  data() {
    return {
      id: this.$route.query.id,
      posts: {},
      loading: false
    }
  },
  created() {
    this.init()
  },
  methods: {
    /** 初始化：先 +1 阅读量，再拉详情 */
    async init() {
      await this.$request.put(`/posts/updateCount/${this.id}`)
      this.fetchPost()
    },
    /** 拉取帖子详情 */
    async fetchPost() {
      this.loading = true
      const { code, data, msg } = await this.$request.get(
        `/posts/selectById/${this.id}`
      )
      this.loading = false
      code === '200' ? (this.posts = data || {}) : this.$message.error(msg)
    }
  }
}
</script>

<style scoped>
.posts-detail {
  width: 70%;
  max-width: 1000px;
  margin: 30px auto;
  padding: 0 20px;
}

/* 骨架屏样式 */
.skeleton-card {
  padding: 40px;
  border-radius: 8px;
  margin-bottom: 20px;
}

/* 帖子卡片 */
.post-card {
  padding: 40px;
  margin-bottom: 30px;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
}

.post-card:hover {
  box-shadow: 0 4px 16px 0 rgba(0, 0, 0, 0.1);
}

.post-header {
  border-bottom: 1px solid #f0f0f0;
  padding-bottom: 30px;
  margin-bottom: 30px;
}

.post-title {
  text-align: center;
  font-size: 28px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 24px;
  line-height: 1.4;
}

.post-meta {
  display: flex;
  justify-content: center;
  align-items: center;
  color: #909399;
  font-size: 14px;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 6px;
}

.meta-item i {
  font-size: 16px;
  color: #409EFF;
}

.meta-divider {
  width: 1px;
  height: 14px;
  background-color: #dcdfe6;
  margin: 0 20px;
}

.post-content-wrapper {
  padding: 0 20px;
}

.post-content {
  font-size: 16px;
  line-height: 1.8;
  color: #303133;
}

.post-content :deep(img) {
  max-width: 100%;
  height: auto;
  border-radius: 8px;
  margin: 10px 0;
}

.post-content :deep(p) {
  margin-bottom: 16px;
}

.post-content :deep(h1),
.post-content :deep(h2),
.post-content :deep(h3),
.post-content :deep(h4),
.post-content :deep(h5),
.post-content :deep(h6) {
  margin: 24px 0 16px;
  font-weight: 600;
  color: #303133;
}

.post-content :deep(a) {
  color: #409EFF;
  text-decoration: none;
  transition: color 0.3s ease;
}

.post-content :deep(a:hover) {
  color: #66b1ff;
}

.post-content :deep(pre) {
  background-color: #f5f7fa;
  padding: 15px;
  border-radius: 4px;
  overflow-x: auto;
  margin: 16px 0;
}

.post-content :deep(blockquote) {
  padding: 0 16px;
  color: #606266;
  border-left: 4px solid #409EFF;
  margin: 16px 0;
}

/* 评论卡片 */
.comment-card {
  padding: 30px;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
}

.comment-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 20px;
  font-size: 18px;
  font-weight: 500;
  color: #303133;
}

.comment-header i {
  color: #409EFF;
  font-size: 20px;
}

/* 响应式调整 */
@media screen and (max-width: 768px) {
  .posts-detail {
    width: 95%;
    padding: 0 10px;
  }

  .post-card,
  .comment-card {
    padding: 20px;
  }

  .post-title {
    font-size: 24px;
  }

  .post-meta {
    flex-direction: column;
    gap: 10px;
  }

  .meta-divider {
    display: none;
  }

  .post-content-wrapper {
    padding: 0;
  }
}
</style>
