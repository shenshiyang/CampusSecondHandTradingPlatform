<template>
  <div class="feedback-page">
    <el-card class="main-card" shadow="hover">
      <!-- 页面标题和搜索栏 -->
      <div class="header-section">
        <h2 class="page-title">
          <i class="el-icon-chat-line-round"></i>
          我的反馈
        </h2>
        <div class="search-bar">
          <el-input
            v-model.trim="keyword"
            placeholder="搜索反馈主题..."
            prefix-icon="el-icon-search"
            clearable
            class="search-input"
            @keyup.enter.native="load(1)"
          />
          <el-button 
            type="primary" 
            icon="el-icon-search"
            @click="load(1)"
          >查询</el-button>
          <el-button 
            type="warning" 
            icon="el-icon-refresh"
            @click="reset"
          >重置</el-button>
        </div>
      </div>

      <!-- 列表 -->
      <el-table
        :data="tableData"
        stripe
        style="width: 100%"
        :header-cell-style="{background:'#f5f7fa'}"
        size="mini"
      >
        <el-table-column prop="title" label="反馈主题" min-width="120">
          <template #default="{ row }">
            <el-tooltip :content="row.title" placement="top" :disabled="row.title.length < 15">
              <span class="ellipsis">{{ row.title }}</span>
            </el-tooltip>
          </template>
        </el-table-column>

        <el-table-column prop="content" label="反馈内容" min-width="180">
          <template #default="{ row }">
            <el-tooltip :content="row.content" placement="top">
              <span class="ellipsis">{{ row.content }}</span>
            </el-tooltip>
          </template>
        </el-table-column>

        <el-table-column label="联系方式" width="240">
          <template #default="{ row }">
            <div class="contact-info">
              <span class="contact-item">
                <i class="el-icon-mobile-phone"></i>
                {{ row.phone }}
              </span>
              <el-divider direction="vertical"></el-divider>
              <span class="contact-item">
                <i class="el-icon-message"></i>
                {{ row.email }}
              </span>
            </div>
          </template>
        </el-table-column>

        <el-table-column prop="reply" label="回复" min-width="150">
          <template #default="{ row }">
            <el-tooltip :content="row.reply" placement="top">
              <span class="ellipsis" :class="{'no-reply': !row.reply}">
                {{ row.reply || '暂无回复' }}
              </span>
            </el-tooltip>
          </template>
        </el-table-column>

        <el-table-column prop="createtime" label="时间" width="160">
          <template #default="{ row }">
            <i class="el-icon-time"></i>
            {{ row.createtime }}
          </template>
        </el-table-column>

        <el-table-column label="操作" width="80" align="center">
          <template #default="{ row }">
            <el-button
              type="danger"
              size="mini"
              icon="el-icon-delete"
              circle
              @click="del(row.id)"
            ></el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页器 -->
      <el-pagination
        v-if="total"
        class="pagination"
        background
        layout="total, prev, pager, next"
        :current-page="pageNum"
        :page-size="pageSize"
        :total="total"
        :page-sizes="[10, 20, 30]"
        @current-change="handleCurrentChange"
      />
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'FrontFeedback',
  data() {
    return {
      tableData: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
      keyword: this.$route.query.title || '',
      fromVisible: false,
      form: {},
      ids: [],
      user: JSON.parse(localStorage.getItem('xm-user') || '{}')
    }
  },
  created() {
    this.load()
  },
  methods: {
    /* ---------- 列表查询 ---------- */
    async load(page = this.pageNum) {
      this.pageNum = page
      const { code, data, msg } = await this.$request.get('/feedback/selectPage', {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          title: this.keyword
        }
      })
      if (code === '200') {
        this.tableData = data.list
        this.total = data.total
      } else {
        this.$message.error(msg)
      }
    },
    handleCurrentChange(page) {
      this.load(page)
    },
    reset() {
      this.keyword = ''
      this.load(1)
    },

    /* ---------- 单条删除 ---------- */
    del(id) {
      this.$confirm('您确定删除吗？', '确认删除', { type: 'warning' })
        .then(() => this.$request.delete(`/feedback/delete/${id}`))
        .then(({ code, msg }) => {
          code === '200'
            ? (this.$message.success('操作成功'), this.load(1))
            : this.$message.error(msg)
        })
        .catch(() => {})
    },

    /* ---------- 以下方法保持原逻辑(新增/编辑/批删) ---------- */
    handleAdd() {
      this.form = {}
      this.fromVisible = true
    },
    handleEdit(row) {
      this.form = { ...row }
      this.fromVisible = true
    },
    async save() {
      const valid = await this.$refs.formRef?.validate().catch(() => false)
      if (!valid) return
      const url = this.form.id ? '/feedback/update' : '/feedback/add'
      const method = this.form.id ? 'PUT' : 'POST'
      const { code, msg } = await this.$request({ url, method, data: this.form })
      code === '200'
        ? (this.$message.success('保存成功'), this.load(1), (this.fromVisible = false))
        : this.$message.error(msg)
    },
    handleSelectionChange(rows) {
      this.ids = rows.map((v) => v.id)
    },
    async delBatch() {
      if (!this.ids.length) {
        this.$message.warning('请选择数据')
        return
      }
      const ok = await this.$confirm('您确定批量删除这些数据吗？', '确认删除', {
        type: 'warning'
      }).catch(() => false)
      if (!ok) return
      const { code, msg } = await this.$request.delete('/feedback/delete/batch', {
        data: this.ids
      })
      code === '200'
        ? (this.$message.success('操作成功'), this.load(1))
        : this.$message.error(msg)
    }
  }
}
</script>

<style scoped>
.feedback-page {
  width: 95%;
  margin: 15px auto;
}

.main-card {
  border-radius: 4px;
}

.header-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.page-title {
  margin: 0;
  font-size: 16px;
  color: #303133;
  display: flex;
  align-items: center;
  gap: 5px;
}

.page-title i {
  color: #409EFF;
}

.search-bar {
  display: flex;
  align-items: center;
  gap: 8px;
}

.search-input {
  width: 220px;
}

/* 表格样式 */
.ellipsis {
  display: inline-block;
  width: 100%;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.contact-info {
  display: flex;
  align-items: center;
  font-size: 13px;
}

.contact-item {
  display: flex;
  align-items: center;
  gap: 3px;
}

.contact-item i {
  color: #909399;
  font-size: 14px;
}

.no-reply {
  color: #909399;
  font-style: italic;
}

/* 分页器 */
.pagination {
  margin-top: 15px;
  text-align: right;
}

/* 响应式处理 */
@media screen and (max-width: 768px) {
  .feedback-page {
    width: 100%;
    margin: 10px auto;
  }

  .header-section {
    flex-direction: column;
    align-items: stretch;
    gap: 10px;
  }

  .search-bar {
    justify-content: space-between;
  }

  .search-input {
    width: 50%;
  }
}
</style>
