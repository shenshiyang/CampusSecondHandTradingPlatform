<template>
  <div class="address-page">
    <!-- ▍操作栏 -->
    <div class="toolbar">
      <el-button type="primary" size="mini" @click="handleAdd">新增</el-button>
      <el-button type="danger"  size="mini" @click="delBatch">批量删除</el-button>
    </div>

    <!-- ▍地址表格 -->
    <el-card shadow="never">
      <el-table
        :data="tableData"
        stripe
        border
        highlight-current-row
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="50" align="center" />
        <el-table-column prop="id" label="序号" width="70" align="center" sortable />
        <el-table-column prop="name" label="联系人" min-width="120" />
        <el-table-column prop="address" label="联系地址" min-width="200" show-overflow-tooltip />
        <el-table-column prop="phone" label="联系电话" min-width="140" />
        <el-table-column label="操作" width="180" align="center">
          <template #default="scope">
            <el-button
              size="mini"
              type="primary"
              plain
              @click="handleEdit(scope.row)"
            >编辑</el-button>
            <el-button
              size="mini"
              type="danger"
              plain
              @click="del(scope.row.id)"
            >删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        class="pager"
        background
        :current-page="pageNum"
        :page-size="pageSize"
        :total="total"
        :page-sizes="[5, 10, 20]"
        layout="total, prev, pager, next"
        @current-change="handleCurrentChange"
      />
    </el-card>

    <!-- ▍弹窗表单 -->
    <el-dialog
      title="收货地址"
      :visible.sync="dialogVisible"
      width="480px"
      :close-on-click-modal="false"
      destroy-on-close
    >
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="80px"
      >
        <el-form-item label="联系人" prop="name">
          <el-input v-model.trim="form.name" clearable placeholder="联系人" />
        </el-form-item>

        <el-form-item label="联系地址" prop="address">
          <el-input v-model.trim="form.address" clearable placeholder="联系地址" />
        </el-form-item>

        <el-form-item label="联系电话" prop="phone">
          <el-input v-model.trim="form.phone" clearable placeholder="联系电话" />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button
          type="primary"
          :loading="btnLoading"
          @click="save"
        >确 定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'Address',
  data() {
    const phoneReg = /^1\d{10}$/
    return {
      tableData: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
      dialogVisible: false,
      form: {},
      btnLoading: false,
      ids: [],
      rules: {
        name: [{ required: true, message: '请输入联系人', trigger: 'blur' }],
        address: [{ required: true, message: '请输入联系地址', trigger: 'blur' }],
        phone: [
          { required: true, message: '请输入联系电话', trigger: 'blur' },
          { pattern: phoneReg, message: '手机号格式不正确', trigger: 'blur' }
        ]
      }
    }
  },
  created() {
    this.load()
  },
  methods: {
    /* ---------- 数据 ---------- */
    async load(page = this.pageNum) {
      this.pageNum = page
      const res = await this.$request.get('/address/selectPage', {
        params: { pageNum: this.pageNum, pageSize: this.pageSize }
      })
      if (res.code === '200') {
        this.tableData = res.data.list
        this.total = res.data.total
      } else {
        this.$message.error(res.msg)
      }
    },

    /* ---------- 新增 / 编辑 ---------- */
    handleAdd() {
      this.form = { }
      this.dialogVisible = true
    },
    handleEdit(row) {
      this.form = { ...row }
      this.dialogVisible = true
    },
    async save() {
      this.$refs.formRef.validate(async valid => {
        if (!valid) return
        this.btnLoading = true
        const isUpdate = !!this.form.id
        const res = await this.$request({
          url: isUpdate ? '/address/update' : '/address/add',
          method: isUpdate ? 'PUT' : 'POST',
          data: this.form
        })
        this.btnLoading = false
        if (res.code === '200') {
          this.$message.success('操作成功')
          this.dialogVisible = false
          this.load(1)
        } else {
          this.$message.error(res.msg)
        }
      })
    },

    /* ---------- 删除 ---------- */
    del(id) {
      this.$confirm('确定删除该地址吗？', '提示', { type: 'warning' })
        .then(() => this.$request.delete('/address/delete/' + id))
        .then(({ code, msg }) => {
          code === '200' ? (this.$message.success('删除成功'), this.load(1)) : this.$message.error(msg)
        })
        .catch(() => {})
    },
    handleSelectionChange(rows) {
      this.ids = rows.map(v => v.id)
    },
    delBatch() {
      if (!this.ids.length) return this.$message.warning('请选择数据')
      this.$confirm('确认批量删除所选地址吗？', '提示', { type: 'warning' })
        .then(() => this.$request.delete('/address/delete/batch', { data: this.ids }))
        .then(({ code, msg }) => {
          code === '200' ? (this.$message.success('删除成功'), this.load(1)) : this.$message.error(msg)
        })
        .catch(() => {})
    },

    /* ---------- 分页 ---------- */
    handleCurrentChange(page) {
      this.load(page)
    }
  }
}
</script>

<style scoped>
.address-page {
  width: 80%;
  max-width: 1200px;
  margin: 30px auto;
  padding: 0 20px;
}

.toolbar {
  margin-bottom: 20px;
  display: flex;
  gap: 12px;
}

.toolbar .el-button {
  padding: 10px 20px;
  border-radius: 6px;
  font-weight: 500;
  transition: all 0.3s;
}

.toolbar .el-button--primary {
  background: #1890ff;
  border-color: #1890ff;
}

.toolbar .el-button--primary:hover {
  background: #40a9ff;
  border-color: #40a9ff;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.2);
}

.toolbar .el-button--danger {
  background: #ff4d4f;
  border-color: #ff4d4f;
  color: #fff;
}

.toolbar .el-button--danger:hover {
  background: #ff7875;
  border-color: #ff7875;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(255, 77, 79, 0.2);
}

:deep(.el-card) {
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08) !important;
  margin-bottom: 20px;
}

:deep(.el-table) {
  border-radius: 8px;
  overflow: hidden;
}

:deep(.el-table th) {
  background-color: #fafafa;
  color: #333;
  font-weight: 500;
  padding: 12px 0;
}

:deep(.el-table td) {
  padding: 12px 0;
}

:deep(.el-table--striped .el-table__body tr.el-table__row--striped td) {
  background: #fafafa;
}

:deep(.el-button--mini) {
  padding: 6px 12px;
  border-radius: 4px;
  transition: all 0.3s;
}

:deep(.el-button--mini:hover) {
  transform: translateY(-1px);
}

.pager {
  margin-top: 20px;
  text-align: center;
  padding: 10px 0;
}

:deep(.el-dialog) {
  border-radius: 12px;
  overflow: hidden;
}

:deep(.el-dialog__header) {
  background: #fafafa;
  padding: 15px 20px;
  margin: 0;
}

:deep(.el-dialog__title) {
  font-size: 16px;
  font-weight: 500;
  color: #333;
}

:deep(.el-dialog__body) {
  padding: 30px 20px;
}

:deep(.el-dialog__footer) {
  border-top: 1px solid #f0f0f0;
  padding: 15px 20px;
}

:deep(.el-form-item__label) {
  font-weight: 500;
  color: #333;
}

:deep(.el-input__inner) {
  border-radius: 6px;
  padding: 0 15px;
  height: 38px;
  line-height: 38px;
  border-color: #e8e8e8;
}

:deep(.el-input__inner:hover) {
  border-color: #40a9ff;
}

:deep(.el-input__inner:focus) {
  border-color: #1890ff;
}
</style>
