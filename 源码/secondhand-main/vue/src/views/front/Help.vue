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
  width: 70%;
  max-width: 900px;
  margin: 40px auto;
  padding: 0 20px;
}

/* 查询栏 */
.search-bar {
  display: flex;
  align-items: center;
  margin-bottom: 30px;
  gap: 15px;
  background: #fff;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.search-input {
  width: 350px;
}

.search-input :deep(.el-input__inner) {
  border-radius: 8px;
  height: 42px;
  line-height: 42px;
  font-size: 14px;
  transition: all 0.3s;
  border-color: #e8e8e8;
  background: #f9f9f9;
}

.search-input :deep(.el-input__inner:hover) {
  border-color: #40a9ff;
  background: #fff;
}

.search-input :deep(.el-input__inner:focus) {
  background: #fff;
  border-color: #1890ff;
  box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.1);
}

.search-bar .el-button {
  padding: 12px 28px;
  border-radius: 8px;
  font-weight: 500;
  font-size: 14px;
  letter-spacing: 1px;
  transition: all 0.3s;
  background: linear-gradient(135deg, #1890ff 0%, #40a9ff 100%);
  border: none;
}

.search-bar .el-button:hover {
  transform: translateY(-1px);
  background: linear-gradient(135deg, #40a9ff 0%, #69c0ff 100%);
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.3);
}

/* 帮助卡片 */
.help-card {
  margin-bottom: 25px;
  border-radius: 16px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  transition: all 0.3s;
  border: 1px solid #f0f0f0;
  overflow: hidden;
  background: #fff;
}

.help-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
}

/* 头部样式 */
.help-header {
  display: flex;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #f0f0f0;
  background: linear-gradient(to right, #fafafa, #fff);
}

.avatar {
  width: 52px;
  height: 52px;
  border-radius: 50%;
  object-fit: cover;
  margin-right: 18px;
  border: 3px solid #fff;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  transition: all 0.3s;
}

.avatar:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.info {
  flex: 1;
  min-width: 0;
}

.title {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 8px;
}

.title strong {
  font-size: 17px;
  color: #2c3e50;
  font-weight: 600;
  flex: 1;
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

:deep(.el-tag) {
  padding: 4px 12px;
  border-radius: 6px;
  font-weight: 500;
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

:deep(.el-tag--success) {
  background: rgba(82, 196, 26, 0.1);
  border: none;
  color: #52c41a;
}

:deep(.el-tag--danger) {
  background: rgba(255, 77, 79, 0.1);
  border: none;
  color: #ff4d4f;
}

.meta {
  color: #8c8c8c;
  font-size: 13px;
  display: flex;
  gap: 20px;
  align-items: center;
}

.meta span {
  display: flex;
  align-items: center;
  gap: 6px;
}

/* 内容区域 */
.help-content {
  padding: 25px;
  line-height: 1.8;
  color: #3c4858;
  font-size: 15px;
  word-break: break-all;
  background: #fff;
}

/* 图片样式 */
.help-img {
  display: block;
  max-width: 400px;
  width: 100%;
  height: 300px;
  object-fit: contain;
  background: linear-gradient(135deg, #f8f9fa 0%, #fff 100%);
  border-radius: 12px;
  margin: 20px auto;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  cursor: pointer;
  transition: all 0.3s;
  padding: 15px;
  border: none;
}

.help-img:hover {
  transform: scale(1.02);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
}

/* 评论按钮 */
.help-card :deep(.el-button--primary.is-plain) {
  margin: 0 25px 20px;
  padding: 10px 24px;
  border-radius: 8px;
  transition: all 0.3s;
  border-color: #1890ff;
  color: #1890ff;
  font-weight: 500;
  letter-spacing: 0.5px;
}

.help-card :deep(.el-button--primary.is-plain:hover) {
  color: #fff;
  background: linear-gradient(135deg, #1890ff 0%, #40a9ff 100%);
  border-color: transparent;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.2);
}

/* 评论区域 */
.comment-area {
  padding: 25px;
  background: linear-gradient(to bottom, #fff, #fafafa);
  border-top: 1px solid #f0f0f0;
  margin-top: 15px;
}

/* 评论标题样式 */
.comment-title {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
  color: #2c3e50;
  font-size: 16px;
  font-weight: 600;
}

.comment-title::before {
  content: '';
  width: 4px;
  height: 16px;
  background: linear-gradient(to bottom, #1890ff, #40a9ff);
  border-radius: 2px;
  margin-right: 10px;
}

/* 评论输入框样式 */
:deep(.el-textarea__inner) {
  border-radius: 8px;
  padding: 12px 15px;
  min-height: 100px !important;
  resize: none;
  transition: all 0.3s;
  border-color: #e8e8e8;
  background: #fff;
  font-size: 14px;
  line-height: 1.6;
}

:deep(.el-textarea__inner:hover) {
  border-color: #40a9ff;
}

:deep(.el-textarea__inner:focus) {
  border-color: #1890ff;
  box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.1);
}

/* 评论按钮样式 */
.comment-btn {
  margin-top: 15px;
  text-align: right;
}

:deep(.comment-submit-btn) {
  padding: 10px 24px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  background: linear-gradient(135deg, #1890ff 0%, #40a9ff 100%);
  border: none;
  color: #fff;
  transition: all 0.3s;
}

:deep(.comment-submit-btn:hover) {
  transform: translateY(-1px);
  background: linear-gradient(135deg, #40a9ff 0%, #69c0ff 100%);
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.2);
}

/* 评论列表样式 */
.comment-list {
  margin-top: 25px;
}

.comment-item {
  display: flex;
  padding: 15px;
  margin-bottom: 15px;
  background: #fff;
  border-radius: 8px;
  transition: all 0.3s;
  border: 1px solid #f0f0f0;
}

.comment-item:hover {
  transform: translateX(5px);
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  border-color: #e8e8e8;
}

.comment-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin-right: 15px;
  border: 2px solid #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.comment-content {
  flex: 1;
}

.comment-user {
  margin-bottom: 6px;
  font-size: 14px;
  color: #2c3e50;
  font-weight: 500;
}

.comment-text {
  font-size: 14px;
  color: #3c4858;
  line-height: 1.6;
  margin-bottom: 8px;
}

.comment-time {
  font-size: 12px;
  color: #8c8c8c;
}

/* 评论数量标签 */
.comment-count {
  background: rgba(24, 144, 255, 0.1);
  color: #1890ff;
  padding: 2px 8px;
  border-radius: 10px;
  font-size: 12px;
  margin-left: 8px;
}

/* 无评论状态 */
.no-comment {
  text-align: center;
  padding: 30px 0;
  color: #8c8c8c;
  font-size: 14px;
}

.no-comment i {
  font-size: 24px;
  margin-bottom: 10px;
  color: #bfbfbf;
}

/* 分页器 */
.pager {
  margin: 40px 0;
  text-align: center;
  padding: 15px 0;
}

:deep(.el-pagination.is-background .el-pager li:not(.disabled)) {
  background-color: #fff;
  border: 1px solid #e8e8e8;
  transition: all 0.3s;
}

:deep(.el-pagination.is-background .el-pager li:not(.disabled).active) {
  background: linear-gradient(135deg, #1890ff 0%, #40a9ff 100%);
  border-color: transparent;
  color: #fff;
  font-weight: 500;
}

:deep(.el-pagination.is-background .el-pager li:not(.disabled):hover) {
  border-color: #1890ff;
  color: #1890ff;
  transform: translateY(-1px);
}

/* 动画效果 */
.fade-enter-active,
.fade-leave-active {
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.fade-enter,
.fade-leave-to {
  opacity: 0;
  transform: translateY(-15px);
}
</style>
