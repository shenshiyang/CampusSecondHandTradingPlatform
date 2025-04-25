<template>
  <div class="posts-detail">
    <!-- ▍正文 -->
    <el-card shadow="never" class="post-card" v-if="!loading">
      <h2 class="post-title">{{ posts.title }}</h2>

      <div class="post-meta">
        <span><i class="el-icon-user" /> {{ posts.userName }}</span>
        <span><i class="el-icon-time" /> {{ posts.time }}</span>
        <span><i class="el-icon-reading" /> {{ posts.readCount }}</span>
      </div>

      <!-- 富文本内容 -->
      <div
        class="post-content w-e-text"
        v-html="posts.content"
      />
    </el-card>

    <!-- 骨架屏 -->
    <el-skeleton v-else :rows="6" animated />

    <!-- ▍评论区 -->
    <el-card shadow="never" class="comment-card">
      <Comment :fid="id" module="posts" />
    </el-card>
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
  width: 60%;
  margin: 20px auto;
}

/* 正文卡片 */
.post-card {
  padding: 30px 40px;
  margin-bottom: 20px;
}
.post-title {
  text-align: center;
  font-size: 22px;
  font-weight: 600;
  margin-bottom: 24px;
}
.post-meta {
  text-align: center;
  color: #8c8c8c;
  font-size: 13px;
  margin-bottom: 40px;
}
.post-meta span + span {
  margin-left: 22px;
}
.post-content {
  font-size: 15px;
  line-height: 1.8;
}

/* 评论卡片 */
.comment-card {
  padding: 20px 30px;
}
</style>
