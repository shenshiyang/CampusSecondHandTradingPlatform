<template>
  <div class="user-help card">
    <!-- ▍顶部操作 -->
    <div class="toolbar">
      <el-button type="primary" plain size="mini" @click="handleAdd">
        发布求助
      </el-button>
    </div>

    <!-- ▍列表 -->
    <el-table
      :data="tableData"
      stripe
      border
    >
      <el-table-column prop="title" label="标题" />
      <el-table-column prop="content" label="内容" show-overflow-tooltip />
      <el-table-column label="图片" width="80">
        <template #default="{ row }">
          <el-image
            v-if="row.img"
            :src="row.img"
            :preview-src-list="[row.img]"
            style="width: 50px"
          />
        </template>
      </el-table-column>
      <el-table-column prop="time" label="发布时间" width="160" />
      <el-table-column label="是否解决" width="90">
        <template #default="{ row }">
          <el-tag type="danger" v-if="row.solved === '未解决'">未解决</el-tag>
          <el-tag type="success" v-else>已解决</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="审核状态" width="90">
        <template #default="{ row }">
          <el-tag type="info" v-if="row.status === '待审核'">待审核</el-tag>
          <el-tag type="success" v-if="row.status === '通过'">通过</el-tag>
          <el-tag type="danger" v-if="row.status === '拒绝'">拒绝</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="280" align="center">
        <template #default="{ row }">
          <div class="btn-group">
            <el-button
              v-if="row.status !== '通过'"
              size="mini"
              type="success"
              plain
              @click="handleEdit(row)"
            >编辑</el-button>
            <el-button
              size="mini"
              type="danger"
              plain
              @click="del(row.id)"
            >删除</el-button>
            <el-button
              size="mini"
              :type="row.solved === '已解决' ? 'info' : 'warning'"
              plain
              @click="toggleSolved(row)"
            >
              {{ row.solved === '已解决' ? '标记未解决' : '标记已解决' }}
            </el-button>
          </div>
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

    <!-- ▍新增 / 编辑弹窗 -->
    <el-dialog
      title="求购信息"
      :visible.sync="dialogVisible"
      width="480px"
      :close-on-click-modal="false"
      destroy-on-close
    >
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="90px"
      >
        <el-form-item label="标题" prop="title">
          <el-input v-model.trim="form.title" />
        </el-form-item>

        <el-form-item label="内容" prop="content">
          <el-input
            type="textarea"
            :autosize="{ minRows: 3 }"
            v-model.trim="form.content"
          />
        </el-form-item>

        <el-form-item label="图片">
          <el-upload
            :action="$baseUrl + '/files/upload'"
            :headers="{ token: user.token }"
            list-type="picture-card"
            :limit="1"
            :on-success="handleImgSuccess"
            :file-list="fileList"
          >
            <i class="el-icon-plus" />
          </el-upload>
        </el-form-item>

        <el-form-item label="是否解决" prop="solved">
          <el-select v-model="form.solved" placeholder="请选择">
            <el-option value="未解决" />
            <el-option value="已解决" />
          </el-select>
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button size="mini" @click="dialogVisible = false">取消</el-button>
        <el-button
          type="primary"
          size="mini"
          :loading="btnLoading"
          @click="save"
        >确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'UserHelp',
  data() {
    return {
      tableData: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
      keyword: '',
      dialogVisible: false,
      btnLoading: false,
      form: { solved: '未解决' },
      rules: {
        title: [{ required: true, message: '请输入标题', trigger: 'blur' }],
        content: [{ required: true, message: '请输入内容', trigger: 'blur' }]
      },
      fileList: [],
      user: JSON.parse(localStorage.getItem('xm-user') || '{}')
    }
  },
  created() {
    this.load()
  },
  methods: {
    /* ---------- 列表 ---------- */
    async load(page = this.pageNum) {
      this.pageNum = page
      const { code, data, msg } = await this.$request.get('/help/selectPage', {
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

    /* ---------- 弹窗 ---------- */
    handleAdd() {
      this.form = { solved: '未解决' }
      this.fileList = []
      this.dialogVisible = true
    },
    handleEdit(row) {
      this.form = { ...row }
      this.fileList = row.img ? [{ url: row.img }] : []
      this.dialogVisible = true
    },
    handleImgSuccess({ data }) {
      this.form.img = data
    },
    async save() {
      const valid = await this.$refs.formRef.validate().catch(() => false)
      if (!valid) return
      this.btnLoading = true
      const url = this.form.id ? '/help/update' : '/help/add'
      const method = this.form.id ? 'PUT' : 'POST'
      const { code, msg } = await this.$request({ url, method, data: this.form })
      this.btnLoading = false
      if (code === '200') {
        this.$message.success('保存成功')
        this.dialogVisible = false
        this.load(1)
      } else {
        this.$message.error(msg)
      }
    },

    /* ---------- 删除 ---------- */
    del(id) {
      this.$confirm('您确定删除吗？', '确认删除', { type: 'warning' })
        .then(() => this.$request.delete(`/help/delete/${id}`))
        .then(({ code, msg }) => {
          code === '200'
            ? (this.$message.success('操作成功'), this.load(1))
            : this.$message.error(msg)
        })
        .catch(() => {})
    },

    /* ---------- 切换求助状态 ---------- */
    async toggleSolved(row) {
      const newStatus = row.solved === '已解决' ? '未解决' : '已解决'
      try {
        await this.$request.post('/help/updateSolvedStatus', {
          id: row.id,
          solved: newStatus
        })
        row.solved = newStatus
        this.$message.success('状态更新成功')
      } catch (error) {
        this.$message.error('操作失败：' + error.message)
      }
    }
  }
}
</script>

<style scoped>
.user-help {
  width: 80%;
  margin: 20px auto;
}
.toolbar {
  margin-bottom: 12px;
}
.pager {
  margin-top: 16px;
  text-align: center;
}
</style>
