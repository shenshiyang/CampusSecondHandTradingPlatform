<template>
  <div class="notice-page">
    <!-- ▍标题区域 -->
    <div class="page-header">
      <h2 class="page-title">
        <i class="el-icon-message-solid" /> 系统公告
      </h2>
      <div class="header-right">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索公告"
          prefix-icon="el-icon-search"
          clearable
          @input="handleSearch"
          class="search-input"
        />
        <el-radio-group v-model="filterType" size="small" @change="handleFilterChange">
          <el-radio-button label="all">全部</el-radio-button>
          <el-radio-button label="today">今日</el-radio-button>
          <el-radio-button label="week">本周</el-radio-button>
          <el-radio-button label="month">本月</el-radio-button>
        </el-radio-group>
      </div>
    </div>

    <!-- ▍公告列表 -->
    <el-card shadow="hover" class="notice-card">
      <el-skeleton
        v-if="loading"
        :rows="4"
        animated
      />
      <template v-else>
        <!-- 无数据提示 -->
        <el-empty
          v-if="filteredNoticeList.length === 0"
          description="暂无公告"
        />
        
        <div v-else class="notice-list">
          <div 
            v-for="item in filteredNoticeList" 
            :key="item.id"
            class="notice-item"
          >
            <div class="notice-item-header">
              <div class="notice-header-left">
                <el-tag size="small" type="primary" effect="plain" class="notice-tag">公告</el-tag>
                <strong class="notice-title">{{ item.title }}</strong>
              </div>
              <div class="notice-header-right">
                <span class="notice-time">
                  <i class="el-icon-time"></i>
                  {{ formatTime(item.time) }}
                </span>
              </div>
            </div>
            
            <div class="notice-content-wrapper">
              <div
                class="notice-content"
                v-html="item.content"
              />
              <div class="notice-footer">
                <el-button 
                  type="text" 
                  icon="el-icon-share"
                  @click="shareNotice(item)"
                >分享</el-button>
              </div>
            </div>
          </div>
        </div>
      </template>
    </el-card>
  </div>
</template>

<script>
import dayjs from 'dayjs'

export default {
  name: 'Notice',
  data() {
    return {
      noticeList: [],
      filteredNoticeList: [],
      loading: false,
      searchKeyword: '',
      filterType: 'all'
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
      if (code === '200') {
        this.noticeList = data || []
        this.handleFilterChange(this.filterType)
      } else {
        this.$message.error(msg)
      }
    },
    
    formatTime(time) {
      if (!time) return ''
      return dayjs(time).format('YYYY-MM-DD HH:mm')
    },
    
    handleSearch() {
      this.handleFilterChange(this.filterType)
    },
    
    handleFilterChange(type) {
      let filtered = [...this.noticeList]
      
      if (this.searchKeyword) {
        filtered = filtered.filter(item => 
          item.title.toLowerCase().includes(this.searchKeyword.toLowerCase()) ||
          item.content.toLowerCase().includes(this.searchKeyword.toLowerCase())
        )
      }
      
      const now = dayjs()
      switch (type) {
        case 'today':
          filtered = filtered.filter(item => dayjs(item.time).isSame(now, 'day'))
          break
        case 'week':
          filtered = filtered.filter(item => dayjs(item.time).isAfter(now.subtract(7, 'day')))
          break
        case 'month':
          filtered = filtered.filter(item => dayjs(item.time).isAfter(now.subtract(1, 'month')))
          break
      }
      
      this.filteredNoticeList = filtered
    },
    
    shareNotice(notice) {
      const shareUrl = `${window.location.origin}${window.location.pathname}?notice=${notice.id}`
      const textarea = document.createElement('textarea')
      textarea.value = shareUrl
      document.body.appendChild(textarea)
      textarea.select()
      document.execCommand('copy')
      document.body.removeChild(textarea)
      this.$message.success('分享链接已复制到剪贴板')
    }
  }
}
</script>

<style scoped>
.notice-page {
  width: 80%;
  max-width: 1000px;
  margin: 30px auto;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.page-title {
  border-left: 4px solid #2656b5;
  padding-left: 16px;
  font-size: 22px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 6px;
  margin: 0;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 16px;
}

.search-input {
  width: 200px;
}

.notice-card {
  border-radius: 8px;
  margin-bottom: 20px;
}

.notice-list {
  max-height: 600px;
  overflow-y: auto;
  padding: 0 16px;
}

.notice-item {
  padding: 20px 0;
  border-bottom: 1px solid #EBEEF5;
}

.notice-item:last-child {
  border-bottom: none;
}

.notice-item-header {
  width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.notice-header-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.notice-tag {
  font-size: 12px;
}

.notice-title {
  font-size: 16px;
  color: #303133;
}

.notice-time {
  color: #909399;
  font-size: 13px;
  display: flex;
  align-items: center;
  gap: 4px;
}

.notice-content-wrapper {
  padding: 0;
}

.notice-content {
  line-height: 1.8;
  font-size: 14px;
  color: #606266;
  margin-bottom: 16px;
  padding: 0 12px;
}

.notice-footer {
  display: flex;
  justify-content: flex-end;
  padding-top: 16px;
  border-top: 1px solid #EBEEF5;
}

/* 自定义滚动条样式 */
.notice-list::-webkit-scrollbar {
  width: 6px;
}

.notice-list::-webkit-scrollbar-thumb {
  background-color: #E4E7ED;
  border-radius: 3px;
}

.notice-list::-webkit-scrollbar-track {
  background-color: #F5F7FA;
}
</style>
