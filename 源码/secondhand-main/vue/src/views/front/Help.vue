<template>
  <div class="help-page">
    <!-- ▍查询栏 -->
    <div class="search-bar">
      <el-input
        v-model.trim="title"
        placeholder="请输入标题关键字查询"
        clearable
        class="search-input"
        @keyup.enter.native="load(1)"
      />
      <el-button type="primary" size="mini" @click="load(1)">查询</el-button>
    </div>

    <!-- ▍求助列表 -->
    <el-card
      v-for="item in tableData"
      :key="item.id"
      class="help-card"
      shadow="never"
    >
      <!-- 头部 -->
      <header class="help-header">
        <img :src="item.avatar" alt="用户头像" class="avatar" />
        <div class="info">
          <div class="title">
            <strong>{{ item.title }}</strong>
            <el-tag
              size="mini"
              :type="item.solved === '未解决' ? 'danger' : 'success'"
            >
              {{ item.solved }}
            </el-tag>
          </div>
          <div class="meta">
            <span>{{ item.userName }}</span>
            <span>{{ item.time }}</span>
          </div>
        </div>
      </header>

      <!-- 图片 -->
      <el-image
        v-if="item.img"
        :src="item.img"
        :preview-src-list="[item.img]"
        fit="cover"
        class="help-img"
      />

      <!-- 内容 -->
      <div
        class="help-content"
        v-html="item.content"
      />

      <!-- 评论按钮 -->
      <el-button
        size="mini"
        type="primary"
        plain
        @click="toggleComment(item)"
      >
        {{ item.showComment ? '收起评论' : '展开评论' }}
      </el-button>

      <!-- 评论区 -->
      <transition name="fade">
        <div v-if="item.showComment" class="comment-area">
          <Comment :fid="item.id" module="help" />
        </div>
      </transition>
    </el-card>

    <!-- ▍分页 -->
    <el-pagination
      v-if="total"
      class="pager"
      background
      layout="total, prev, pager, next"
      :current-page="pageNum"
      :page-size="pageSize"
      :total="total"
      :page-sizes="[5, 10, 20]"
      @current-change="handleCurrentChange"
    />
  </div>
</template>

<script>
import Comment from '@/components/Comment'
export default {
  name: 'Help',
  components: { Comment },
  data() {
    return {
      tableData: [],
      pageNum: 1,
      pageSize: 5,
      total: 0,
      title: ''
    }
  },
  created() {
    this.load()
  },
  methods: {
    /* ---------- 数据 ---------- */
    async load(page = this.pageNum) {
      this.pageNum = page
      const { code, data, msg } = await this.$request.get(
        '/help/selectFrontPage',
        {
          params: {
            pageNum: this.pageNum,
            pageSize: this.pageSize,
            title: this.title
          }
        }
      )
      if (code === '200') {
        this.tableData = (data.list || []).map((v) => ({
          ...v,
          showComment: v.showComment ?? false
        }))
        this.total = data.total
      } else {
        this.$message.error(msg)
      }
    },

    /* ---------- 评论折叠 ---------- */
    toggleComment(item) {
      this.$set(item, 'showComment', !item.showComment)
    },

    /* ---------- 分页 ---------- */
    handleCurrentChange(page) {
      this.load(page)
    }
  }
}
</script>

<style scoped>
/* 容器 */
.help-page {
  width: 60%;
  margin: 30px auto;
}
/* 查询栏 */
.search-bar {
  display: flex;
  align-items: center;
  margin-bottom: 18px;
}
.search-input {
  width: 300px;
  margin-right: 10px;
}
/* 卡片 */
.help-card {
  margin-bottom: 20px;
  padding: 20px;
}
/* 头部 */
.help-header {
  display: flex;
  align-items: center;
  margin-bottom: 12px;
}
.avatar {
  width: 46px;
  height: 46px;
  border-radius: 50%;
  object-fit: cover;
  margin-right: 14px;
}
.info {
  flex: 1;
}
.title {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 4px;
}
.meta {
  color: #8c8c8c;
  font-size: 13px;
  display: flex;
  gap: 18px;
}
/* 图片 */
.help-img {
  width: 100%;
  max-width: 320px;
  margin: 12px 0;
  border-radius: 4px;
}
/* 内容 */
.help-content {
  font-size: 14px;
  color: #444;
  margin-bottom: 10px;
}
/* 评论 */
.comment-area {
  margin-top: 15px;
  border-top: 1px dashed #e5e5e5;
  padding-top: 15px;
}
/* 分页 */
.pager {
  margin-top: 26px;
  text-align: center;
}
/* 动画 */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s;
}
.fade-enter,
.fade-leave-to {
  opacity: 0;
}
</style>
