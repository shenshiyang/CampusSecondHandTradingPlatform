<template>
  <div class="feedback-page card">
    <!-- ▍查询栏 -->
    <div class="search-bar">
      <el-input
        v-model.trim="keyword"
        placeholder="请输入关键字查询"
        clearable
        class="search-input"
        @keyup.enter.native="load(1)"
      />
      <el-button type="info" plain size="mini" @click="load(1)">查询</el-button>
      <el-button type="warning" plain size="mini" @click="reset">重置</el-button>
    </div>

    <!-- ▍列表 -->
    <el-table
      :data="tableData"
      stripe
      border
    >
      <el-table-column prop="title" label="主题" />
      <el-table-column prop="content" label="内容" />
      <el-table-column prop="phone" label="联系方式" width="120" />
      <el-table-column prop="email" label="邮箱" width="160" />
      <el-table-column prop="reply" label="回复" />
      <el-table-column prop="createtime" label="创建时间" width="160" />
      <el-table-column label="操作" width="100" align="center">
        <template #default="{ row }">
          <el-button
            type="danger"
            size="mini"
            plain
            @click="del(row.id)"
          >删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- ▍分页 -->
    <el-pagination
      v-if="total"
      class="pager"
      background
      layout="total, prev, pager, next"
      :current-page="pageNum"
      :page-size="pageSize"
      :total="total"
      :page-sizes="[10, 20, 30]"
      @current-change="handleCurrentChange"
    />
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
      keyword: this.$route.query.title || '', // 查询关键字
      /* 以下保留原功能字段（新增/编辑）—— 兼容后端接口 */
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
  width: 80%;
  margin: 20px auto;
}
.search-bar {
  margin-bottom: 14px;
  display: flex;
  align-items: center;
}
.search-input {
  width: 200px;
}
.pager {
  margin-top: 16px;
  text-align: center;
}
</style>
