<template>
  <div class="add-goods">
    <el-card shadow="never">
      <div class="toolbar">
        <el-button size="mini" @click="$router.back()">← 返回</el-button>
      </div>

      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="100px"
        class="goods-form"
      >
        <h2 class="form-title">{{ form.id ? '编辑商品' : '发布商品' }}</h2>

        <el-row :gutter="24">
          <!-- 名称 -->
          <el-col :span="12">
            <el-form-item label="名称" prop="name">
              <el-input v-model.trim="form.name" placeholder="商品名称" clearable />
            </el-form-item>
          </el-col>

          <!-- 价格 -->
          <el-col :span="12">
            <el-form-item label="价格" prop="price">
              <el-input v-model.number="form.price" placeholder="价格 (元)">
                <template #prefix>￥</template>
              </el-input>
            </el-form-item>
          </el-col>

          <!-- 分类 -->
          <el-col :span="12">
            <el-form-item label="分类" prop="category">
              <el-select v-model="form.category" placeholder="请选择" style="width:100%">
                <el-option
                  v-for="c in categoryList"
                  :key="c.id"
                  :label="c.name"
                  :value="c.name"
                />
              </el-select>
            </el-form-item>
          </el-col>

          <!-- 库存 -->
          <el-col :span="12">
            <el-form-item label="库存" prop="stock">
              <el-input-number
                v-model.number="form.stock"
                :min="1"
                :max="9999"
                controls-position="right"
                style="width:100%"
              />
            </el-form-item>
          </el-col>

          <!-- 发货地址 -->
          <el-col :span="24">
            <el-form-item label="发货地" prop="address">
              <el-input v-model.trim="form.address" placeholder="发货地址" />
            </el-form-item>
          </el-col>

          <!-- 上架状态 -->
          <el-col :span="24">
            <el-form-item label="上架状态" prop="saleStatus">
              <el-radio-group v-model="form.saleStatus">
                <el-radio label="上架" />
                <el-radio label="下架" />
              </el-radio-group>
            </el-form-item>
          </el-col>

          <!-- 图片 -->
          <el-col :span="24">
            <el-form-item label="图片" prop="img">
              <el-upload
                :action="$baseUrl + '/files/upload'"
                :headers="{ token: user.token }"
                list-type="picture-card"
                :on-success="handleImgSuccess"
              >
                <i class="el-icon-plus" /> 
              </el-upload>
            </el-form-item>
          </el-col>

          <!-- 详情 -->
          <el-col :span="24">
            <el-form-item label="详情" prop="content">
              <div id="editor" class="rich-editor" />
            </el-form-item>
          </el-col>
        </el-row>

        <div class="actions">
          <el-button
            type="primary"
            :loading="btnLoading"
            @click="save"
          >确 认</el-button>
        </div>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import E from 'wangeditor'
const validatePrice = (rule, value, cb) =>
  value > 0 ? cb() : cb(new Error('价格必须大于 0'))

export default {
  name: 'AddGoods',
  data() {
    return {
      id: this.$route.query.id,
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      categoryList: [],
      form: { saleStatus: '下架', stock: 1 },
      rules: {
        name: [{ required: true, message: '请输入商品名称', trigger: 'blur' }],
        price: [{ required: true, validator: validatePrice, trigger: 'blur' }],
        category: [{ required: true, message: '请选择分类', trigger: 'change' }],
        address: [{ required: true, message: '请输入发货地址', trigger: 'blur' }],
        stock: [{ required: true, type: 'number', message: '请输入库存', trigger: 'blur' }]
      },
      editor: null,
      btnLoading: false
    }
  },
  async mounted() {
    await Promise.all([this.loadCategory(), this.loadGoods()])
    this.initEditor(this.form.content || '')
  },
  beforeDestroy() {
    this.editor && this.editor.destroy()
  },
  methods: {
    /* 获取分类 */
    async loadCategory() {
      const { data } = await this.$request.get('/category/selectAll')
      this.categoryList = data || []
    },
    /* 编辑回显 */
    async loadGoods() {
      if (!this.id) return
      const { data } = await this.$request.get('/goods/selectById/' + this.id)
      if (data) Object.assign(this.form, data)
    },
    /* 富文本初始化 */
    initEditor(html) {
      this.editor = new E('#editor')
      this.editor.config.uploadImgServer = this.$baseUrl + '/files/editor/upload'
      this.editor.config.uploadFileName = 'file'
      this.editor.config.uploadImgHeaders = { token: this.user.token }
      this.editor.config.uploadImgParams = { type: 'img' }
      this.editor.create()
      this.editor.txt.html(html)
    },
    /* 图片上传成功 */
    handleImgSuccess(resp) {
      this.form.img = resp.data
      this.$message.success('上传成功')
    },
    /* 表单提交 */
    save() {
      this.$refs.formRef.validate(async valid => {
        if (!valid) return
        this.btnLoading = true
        this.form.content = this.editor.txt.html()
        const isUpdate = !!this.form.id
        const res = await this.$request({
          url: isUpdate ? '/goods/update' : '/goods/add',
          method: isUpdate ? 'PUT' : 'POST',
          data: this.form
        })
        this.btnLoading = false
        if (res.code === '200') {
          this.$message.success(isUpdate ? '修改成功' : '发布成功')
          this.$router.back()
        } else {
          this.$message.error(res.msg)
        }
      })
    }
  }
}
</script>

<style scoped>
.add-goods {
  width: 60%;
  margin: 20px auto;
}
.toolbar {
  margin-bottom: 10px;
}
.form-title {
  text-align: center;
  margin: 20px 0 30px;
}
.goods-form >>> .el-form-item__label {
  font-weight: 500;
}
.rich-editor {
  border: 1px solid #e5e5e5;
  min-height: 300px;
}
.actions {
  text-align: center;
  margin-top: 30px;
}
</style>
