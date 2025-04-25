<template>
  <div class="user-posts card">
    <!-- ▍工具栏 -->
    <div class="toolbar">
      <el-button type="primary" size="mini" @click="handleAdd">发 帖</el-button>

      <div class="toolbar-right">
        <el-input
          v-model.trim="title"
          class="search-input"
          placeholder="请输入标题关键字"
          clearable
          @keyup.enter.native="load(1)"
        />
        <el-button type="info" plain size="mini" @click="load(1)">查询</el-button>
        <el-button type="warning" plain size="mini" @click="reset">重置</el-button>
      </div>
    </div>

    <!-- ▍表格 -->
    <el-table
      :data="tableData"
      stripe
      border
    >
      <el-table-column label="图片" width="70">
        <template #default="{ row }">
          <el-image
            v-if="row.img"
            :src="row.img"
            :preview-src-list="[row.img]"
            style="width: 50px"
          />
        </template>
      </el-table-column>

      <el-table-column prop="title" label="标题" show-overflow-tooltip />

      <el-table-column label="查看内容" width="100">
        <template #default="{ row }">
          <el-button type="text" @click="preview(row.content)">查看</el-button>
        </template>
      </el-table-column>

      <el-table-column prop="time" label="发布时间" width="160" />
      <el-table-column prop="circle" label="圈子" width="90" />
      <el-table-column prop="descr" label="简介" />
      <el-table-column prop="readCount" label="浏览量" width="80" />

      <el-table-column prop="status" label="审核状态" width="90">
        <template #default="{ row }">
          <el-tag v-if="row.status === '待审核'" type="info">待审核</el-tag>
          <el-tag v-else-if="row.status === '通过'" type="success">通过</el-tag>
          <el-tag v-else type="danger">拒绝</el-tag>
        </template>
      </el-table-column>

      <el-table-column label="操作" width="180" align="center">
        <template #default="{ row }">
          <el-button size="mini" type="primary" plain @click="handleEdit(row)">编辑</el-button>
          <el-button size="mini" type="danger" plain @click="del(row.id)">删除</el-button>
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
      title="帖子"
      :visible.sync="dialogVisible"
      width="50%"
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

        <el-form-item label="简介" prop="descr">
          <el-input
            type="textarea"
            :autosize="{ minRows: 2 }"
            v-model.trim="form.descr"
          />
        </el-form-item>

        <el-form-item label="圈子" prop="circle">
          <el-select v-model="form.circle" placeholder="请选择">
            <el-option
              v-for="c in circles"
              :key="c.id"
              :label="c.name"
              :value="c.name"
            />
          </el-select>
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

        <el-form-item label="内容" prop="content">
          <div id="editor" class="rich-editor" />
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

    <!-- ▍内容预览 -->
    <el-dialog
      title="文章内容"
      :visible.sync="previewVisible"
      width="50%"
      :close-on-click-modal="false"
      destroy-on-close
    >
      <div class="w-e-text" v-html="previewContent" />

      <template #footer>
        <el-button size="mini" @click="previewVisible = false">关 闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import E from 'wangeditor'

export default {
  name: 'UserPosts',
  data() {
    return {
      /* 列表 */
      tableData: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
      title: '',

      /* 编辑弹窗 */
      dialogVisible: false,
      form: {},
      rules: {
        title: [{ required: true, message: '请输入标题', trigger: 'blur' }],
        descr: [{ required: true, message: '请输入简介', trigger: 'blur' }],
        circle: [{ required: true, message: '请选择圈子', trigger: 'blur' }]
      },
      btnLoading: false,
      editor: null,
      fileList: [],

      /* 预览弹窗 */
      previewVisible: false,
      previewContent: '',

      circles: [],
      user: JSON.parse(localStorage.getItem('xm-user') || '{}')
    }
  },
  created() {
    this.load()
    this.loadCircles()
  },
  methods: {
    /* ---------- 圈子 ---------- */
    async loadCircles() {
      const { code, data } = await this.$request.get('/circles/selectAll')
      if (code === '200') this.circles = data || []
    },

    /* ---------- 列表 ---------- */
    async load(page = this.pageNum) {
      this.pageNum = page
      const { code, data, msg } = await this.$request.get('/posts/selectPage', {
        params: { pageNum: this.pageNum, pageSize: this.pageSize, title: this.title }
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
      this.title = ''
      this.load(1)
    },

    /* ---------- 弹窗 ---------- */
    handleAdd() {
      this.form = {}
      this.fileList = []
      this.dialogVisible = true
      this.initEditor('')
    },
    handleEdit(row) {
      this.form = { ...row }
      this.fileList = row.img ? [{ url: row.img }] : []
      this.dialogVisible = true
      this.initEditor(row.content)
    },
    initEditor(html) {
      this.$nextTick(() => {
        if (this.editor) this.editor.destroy()

        this.editor = new E('#editor')
        this.editor.config.uploadImgServer = `${this.$baseUrl}/files/editor/upload`
        this.editor.config.uploadFileName = 'file'
        this.editor.config.uploadImgHeaders = { token: this.user.token }
        this.editor.config.uploadImgParams = { type: 'img' }
        this.editor.create()
        this.editor.txt.html(html)
      })
    },
    handleImgSuccess({ data }) {
      this.form.img = data
    },
    async save() {
      const valid = await this.$refs.formRef.validate().catch(() => false)
      if (!valid) return

      this.form.content = this.editor.txt.html()
      const url = this.form.id ? '/posts/update' : '/posts/add'
      const method = this.form.id ? 'PUT' : 'POST'

      this.btnLoading = true
      const { code, msg } = await this.$request({ url, method, data: this.form })
      this.btnLoading = false

      code === '200'
        ? (this.$message.success('保存成功'), (this.dialogVisible = false), this.load(1))
        : this.$message.error(msg)
    },

    /* ---------- 删除 ---------- */
    del(id) {
      this.$confirm('您确定删除吗？', '确认删除', { type: 'warning' })
        .then(() => this.$request.delete(`/posts/delete/${id}`))
        .then(({ code, msg }) => {
          code === '200'
            ? (this.$message.success('操作成功'), this.load(1))
            : this.$message.error(msg)
        })
        .catch(() => {})
    },

    /* ---------- 预览 ---------- */
    preview(content) {
      this.previewContent = content
      this.previewVisible = true
    }
  },
  beforeDestroy() {
    this.editor && this.editor.destroy()
  }
}
</script>

<style scoped>
.user-posts {
  width: 70%;
  margin: 20px auto;
}
/* 工具栏 */
.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 14px;
}
.toolbar-right {
  display: flex;
  align-items: center;
}
.search-input {
  width: 260px;
  margin-right: 10px;
}

/* 分页 */
.pager {
  margin-top: 16px;
  text-align: center;
}

/* 富文本编辑器容器 */
.rich-editor {
  border: 1px solid #ebeef5;
  border-radius: 4px;
}
</style>
