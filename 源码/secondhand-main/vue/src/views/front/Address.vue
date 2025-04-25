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
  width: 60%;
  margin: 20px auto;
}
.toolbar {
  margin-bottom: 10px;
}
.pager {
  margin-top: 15px;
  text-align: center;
}
</style>
