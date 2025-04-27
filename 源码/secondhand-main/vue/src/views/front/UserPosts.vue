<template>
  <div class="user-posts">
    <el-card class="main-card" shadow="hover">
      <!-- 页面标题 -->
      <div class="page-header">
        <h2 class="page-title">
          <i class="el-icon-document"></i>
          我的帖子
        </h2>
      </div>

      <!-- 工具栏 -->
      <div class="toolbar">
        <el-button 
          type="primary" 
          icon="el-icon-edit"
          @click="handleAdd"
        >发布新帖</el-button>

        <div class="toolbar-right">
          <el-input
            v-model.trim="title"
            class="search-input"
            placeholder="搜索帖子标题..."
            prefix-icon="el-icon-search"
            clearable
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

      <!-- 表格 -->
      <el-table
        :data="tableData"
        stripe
        style="width: 100%"
        :header-cell-style="{background:'#f5f7fa', color: '#606266'}"
      >
        <el-table-column label="帖子信息" min-width="400">
          <template #default="{ row }">
            <div class="post-info">
              <el-image
                v-if="row.img"
                :src="row.img"
                :preview-src-list="[row.img]"
                class="post-image"
                fit="cover"
              >
                <div slot="error" class="image-error">
                  <i class="el-icon-picture-outline"></i>
                </div>
              </el-image>
              <div class="post-detail">
                <h3 class="post-title">{{ row.title }}</h3>
                <p class="post-descr">{{ row.descr }}</p>
                <div class="post-meta">
                  <el-tag size="mini" effect="plain">{{ row.circle }}</el-tag>
                  <span class="meta-item">
                    <i class="el-icon-time"></i>
                    {{ row.time }}
                  </span>
                  <span class="meta-item">
                    <i class="el-icon-view"></i>
                    {{ row.readCount }} 次浏览
                  </span>
                </div>
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="审核状态" width="100" align="center">
          <template #default="{ row }">
            <el-tag
              :type="getStatusType(row.status)"
              effect="dark"
              size="mini"
            >{{ row.status }}</el-tag>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="250" align="center">
          <template #default="{ row }">
            <el-button 
              type="primary" 
              size="mini" 
              icon="el-icon-view"
              @click="preview(row.content)"
            >查看</el-button>
            <el-button 
              type="warning" 
              size="mini" 
              icon="el-icon-edit"
              @click="handleEdit(row)"
            >编辑</el-button>
            <el-button 
              type="danger" 
              size="mini" 
              icon="el-icon-delete"
              @click="del(row.id)"
            >删除</el-button>
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

      <!-- 编辑弹窗 -->
      <el-dialog
        :title="form.id ? '编辑帖子' : '发布帖子'"
        :visible.sync="dialogVisible"
        width="60%"
        :close-on-click-modal="false"
        destroy-on-close
        custom-class="post-dialog"
      >
        <el-form
          ref="formRef"
          :model="form"
          :rules="rules"
          label-width="90px"
        >
          <el-form-item label="标题" prop="title">
            <el-input 
              v-model.trim="form.title" 
              placeholder="请输入帖子标题"
            />
          </el-form-item>

          <el-form-item label="简介" prop="descr">
            <el-input
              type="textarea"
              :autosize="{ minRows: 2, maxRows: 4 }"
              v-model.trim="form.descr"
              placeholder="请输入帖子简介"
            />
          </el-form-item>

          <el-form-item label="圈子" prop="circle">
            <el-select 
              v-model="form.circle" 
              placeholder="请选择圈子"
              style="width: 100%"
            >
              <el-option
                v-for="c in circles"
                :key="c.id"
                :label="c.name"
                :value="c.name"
              >
                <span style="float: left">{{ c.name }}</span>
              </el-option>
            </el-select>
          </el-form-item>

          <el-form-item label="封面图片">
            <el-upload
              :action="$baseUrl + '/files/upload'"
              :headers="{ token: user.token }"
              list-type="picture-card"
              :limit="1"
              :on-success="handleImgSuccess"
              :file-list="fileList"
              class="cover-uploader"
            >
              <i class="el-icon-plus"></i>
              <div slot="tip" class="el-upload__tip">只能上传一张图片</div>
            </el-upload>
          </el-form-item>

          <el-form-item label="内容" prop="content">
            <div id="editor" class="rich-editor" />
          </el-form-item>
        </el-form>

        <template #footer>
          <el-button 
            icon="el-icon-close"
            @click="dialogVisible = false"
          >取消</el-button>
          <el-button
            type="primary"
            icon="el-icon-check"
            :loading="btnLoading"
            @click="save"
          >确定</el-button>
        </template>
      </el-dialog>

      <!-- 预览弹窗 -->
      <el-dialog
        title="帖子内容预览"
        :visible.sync="previewVisible"
        width="60%"
        :close-on-click-modal="false"
        destroy-on-close
        custom-class="preview-dialog"
      >
        <div class="preview-content w-e-text" v-html="previewContent" />

        <template #footer>
          <el-button 
            type="primary" 
            icon="el-icon-close"
            @click="previewVisible = false"
          >关闭</el-button>
        </template>
      </el-dialog>
    </el-card>
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
    },

    getStatusType(status) {
      const statusMap = {
        '待审核': 'info',
        '通过': 'success',
        '拒绝': 'danger'
      }
      return statusMap[status] || 'info'
    }
  },
  beforeDestroy() {
    this.editor && this.editor.destroy()
  }
}
</script>

<style scoped>
.user-posts {
  width: 80%;
  max-width: 1200px;
  margin: 30px auto;
  padding: 0 20px;
}

.main-card {
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
}

.page-header {
  margin-bottom: 20px;
  padding-bottom: 20px;
  border-bottom: 1px solid #f0f0f0;
}

.page-title {
  margin: 0;
  font-size: 20px;
  font-weight: 500;
  color: #303133;
  display: flex;
  align-items: center;
  gap: 8px;
}

.page-title i {
  color: #409EFF;
  font-size: 24px;
}

/* 工具栏 */
.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.toolbar-right {
  display: flex;
  align-items: center;
  gap: 10px;
}

.search-input {
  width: 300px;
}

/* 帖子信息 */
.post-info {
  display: flex;
  gap: 15px;
  padding: 10px 0;
}

.post-image {
  width: 100px;
  height: 100px;
  border-radius: 8px;
  overflow: hidden;
  flex-shrink: 0;
}

.image-error {
  width: 100%;
  height: 100%;
  background: #f5f7fa;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #909399;
}

.post-detail {
  flex: 1;
  overflow: hidden;
}

.post-title {
  margin: 0 0 8px;
  font-size: 16px;
  font-weight: 500;
  color: #303133;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.post-descr {
  margin: 0 0 10px;
  font-size: 14px;
  color: #606266;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.post-meta {
  display: flex;
  align-items: center;
  gap: 15px;
  color: #909399;
  font-size: 13px;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 4px;
}

.meta-item i {
  font-size: 14px;
}

/* 分页器 */
.pagination {
  margin-top: 30px;
  text-align: center;
}

/* 富文本编辑器 */
.rich-editor {
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  margin-top: 8px;
}

/* 弹窗样式 */
:deep(.post-dialog) {
  border-radius: 8px;
}

:deep(.post-dialog .el-dialog__header) {
  padding: 20px;
  background: #f5f7fa;
  border-radius: 8px 8px 0 0;
}

:deep(.post-dialog .el-dialog__body) {
  padding: 30px 20px;
}

:deep(.post-dialog .el-dialog__footer) {
  padding: 10px 20px 20px;
  border-top: 1px solid #f0f0f0;
}

/* 预览弹窗 */
.preview-content {
  max-height: 60vh;
  overflow-y: auto;
  padding: 20px;
}

.preview-content :deep(img) {
  max-width: 100%;
  height: auto;
  border-radius: 4px;
}

/* 上传组件 */
.cover-uploader :deep(.el-upload--picture-card) {
  width: 150px;
  height: 150px;
  line-height: 150px;
}

.cover-uploader :deep(.el-upload-list--picture-card .el-upload-list__item) {
  width: 150px;
  height: 150px;
}

/* 响应式调整 */
@media screen and (max-width: 768px) {
  .user-posts {
    width: 95%;
    padding: 0 10px;
  }

  .toolbar {
    flex-direction: column;
    gap: 15px;
  }

  .toolbar-right {
    width: 100%;
  }

  .search-input {
    width: 100%;
  }

  .post-info {
    flex-direction: column;
  }

  .post-image {
    width: 100%;
    height: 200px;
  }
}
</style>
