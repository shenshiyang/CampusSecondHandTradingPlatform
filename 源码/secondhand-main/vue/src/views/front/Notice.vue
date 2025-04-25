<template>
  <div class="notice-page">
    <!-- ▍标题 -->
    <h2 class="page-title">
      <i class="el-icon-message-solid" /> 系统公告
    </h2>

    <!-- ▍公告列表 -->
    <el-card shadow="never">
      <el-skeleton
        v-if="loading"
        :rows="4"
        animated
      />
      <el-collapse
        v-else
        v-model="active"
        accordion
      >
        <el-collapse-item
          v-for="(item, idx) in noticeList"
          :key="item.id"
          :name="idx"
        >
          <!-- 标题插槽 -->
          <template #title>
            <strong class="notice-title">{{ item.title }}</strong>
            <span class="notice-time">{{ item.time }}</span>
          </template>

          <!-- 内容 -->
          <div
            class="notice-content"
            v-html="item.content"
          />
        </el-collapse-item>
      </el-collapse>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'Notice',
  data() {
    return {
      noticeList: [],
      active: 0,
      loading: false
    }
  },
  created() {
    this.fetchNotice()
  },
  methods: {
    async fetchNotice() {
      this.loading = true
      const { code, data, msg } = await this.$request.get('/notice/selectAll')
      this.loading = false
      code === '200'
        ? (this.noticeList = data || [])
        : this.$message.error(msg)
    }
  }
}
</script>

<style scoped>
.notice-page {
  width: 60%;
  margin: 30px auto;
}
.page-title {
  border-left: 4px solid #2656b5;
  padding-left: 16px;
  margin-bottom: 24px;
  font-size: 22px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 6px;
}
.notice-title {
  font-size: 16px;
}
.notice-time {
  margin-left: 16px;
  color: #999;
  font-size: 12px;
}
.notice-content {
  line-height: 1.6;
  font-size: 14px;
  color: #444;
}
</style>
