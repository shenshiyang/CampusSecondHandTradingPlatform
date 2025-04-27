<template>
  <div class="add-goods-container">
    <div class="content-wrapper">
      <div class="header-section">
        <el-button class="back-btn" type="text" @click="$router.back()">
          <i class="el-icon-arrow-left"></i> 返回
        </el-button>
        <h2 class="page-title">{{ form.id ? '编辑商品' : '发布商品' }}</h2>
      </div>

      <el-card class="form-card" shadow="never">
        <el-form
          ref="formRef"
          :model="form"
          :rules="rules"
          label-width="100px"
          class="goods-form"
        >
          <el-row :gutter="24">
            <!-- 基本信息 -->
            <el-col :span="14">
              <div class="form-section">
                <h3 class="section-title">基本信息</h3>
                <el-form-item label="商品名称" prop="name">
                  <el-input 
                    v-model.trim="form.name" 
                    placeholder="请输入商品名称"
                    clearable 
                  />
                </el-form-item>

                <el-form-item label="商品价格" prop="price">
                  <el-input 
                    v-model.number="form.price" 
                    placeholder="请输入价格"
                    class="price-input"
                  >
                    <template #prefix>￥</template>
                  </el-input>
                </el-form-item>

                <el-form-item label="商品分类" prop="category">
                  <el-select 
                    v-model="form.category" 
                    placeholder="请选择分类"
                    class="category-select"
                  >
                    <el-option
                      v-for="c in categoryList"
                      :key="c.id"
                      :label="c.name"
                      :value="c.name"
                    />
                  </el-select>
                </el-form-item>

                <el-form-item label="商品库存" prop="stock">
                  <el-input-number
                    v-model.number="form.stock"
                    :min="1"
                    :max="9999"
                    controls-position="right"
                    class="stock-input"
                  />
                </el-form-item>

                <el-form-item label="发货地址" prop="address">
                  <el-input 
                    v-model.trim="form.address" 
                    placeholder="请输入发货地址"
                    class="address-input"
                  >
                    <template #prefix>
                      <i class="el-icon-location"></i>
                    </template>
                  </el-input>
                </el-form-item>

                <el-form-item label="上架状态" prop="saleStatus">
                  <el-radio-group v-model="form.saleStatus" class="status-radio">
                    <el-radio label="上架">立即上架</el-radio>
                    <el-radio label="下架">暂不上架</el-radio>
                  </el-radio-group>
                </el-form-item>
              </div>
            </el-col>

            <!-- 商品图片 -->
            <el-col :span="10">
              <div class="form-section">
                <h3 class="section-title">商品图片</h3>
                <el-form-item prop="img" class="upload-container">
                  <div class="upload-wrapper">
                    <div class="upload-area">
                      <el-upload
                        :action="$baseUrl + '/files/upload'"
                        :headers="{ token: user.token }"
                        list-type="picture-card"
                        :on-success="handleImgSuccess"
                        class="goods-uploader"
                      >
                        <div class="upload-content">
                          <i class="el-icon-picture-outline-round"></i>
                        </div>
                      </el-upload>
                    </div>
                    <div class="upload-tips">
                      <p><i class="el-icon-info"></i> 图片要求：</p>
                      <ul>
                        <li>图片清晰，不能虚化、模糊</li>
                        <li>主体突出，背景干净</li>
                        <li>不能带有水印、二维码等</li>
                      </ul>
                    </div>
                  </div>
                </el-form-item>
              </div>
            </el-col>

            <!-- 商品详情 -->
            <el-col :span="24">
              <div class="form-section">
                <h3 class="section-title">商品详情</h3>
                <el-form-item prop="content">
                  <div id="editor" class="rich-editor"></div>
                </el-form-item>
              </div>
            </el-col>
          </el-row>

          <div class="form-actions">
            <el-button 
              type="primary" 
              :loading="btnLoading" 
              @click="save"
              class="submit-btn"
            >
              {{ form.id ? '保存修改' : '发布商品' }}
            </el-button>
          </div>
        </el-form>
      </el-card>
    </div>
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
.add-goods-container {
  min-height: 100vh;
  background-color: #f5f7fa;
  padding: 20px;
}

.content-wrapper {
  max-width: 1200px;
  margin: 0 auto;
}

.header-section {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
}

.back-btn {
  font-size: 16px;
  padding: 0;
  margin-right: 20px;
}

.back-btn i {
  margin-right: 4px;
}

.page-title {
  font-size: 24px;
  font-weight: 600;
  color: #333;
  margin: 0;
}

.form-card {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08) !important;
}

.form-section {
  padding: 20px 0;
  margin-bottom: 24px;
}

.section-title {
  font-size: 18px;
  font-weight: 500;
  color: #333;
  margin: 0 0 20px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
  padding-left: 10px;
}

.goods-form :deep(.el-form-item__label) {
  font-weight: 500;
  color: #333;
}

.price-input :deep(.el-input__prefix) {
  color: #ff4d4f;
  font-weight: 500;
}

.category-select {
  width: 100%;
}

.stock-input {
  width: 100%;
}

.upload-container {
  margin-left: -58px;
}

.upload-wrapper {
  display: flex;
  align-items: flex-start;
  gap: 15px;
}

.upload-area {
  padding-left: 0;
}

.goods-uploader {
  width: 160px;
}

.goods-uploader :deep(.el-upload--picture-card) {
  width: 160px;
  height: 160px;
  line-height: 160px;
  border: 2px dashed #e8e8e8;
  border-radius: 8px;
  background-color: #fafafa;
  transition: all 0.3s;
  margin: 0;
}

.goods-uploader :deep(.el-upload-list--picture-card .el-upload-list__item) {
  width: 160px;
  height: 160px;
  border-radius: 8px;
  margin: 0;
}

.upload-content {
  text-align: center;
}

.upload-content i {
  font-size: 28px;
  color: #1890ff;
}

.upload-tips {
  flex: 1;
  background: #f6f8fa;
  padding: 12px 15px;
  border-radius: 8px;
  max-width: 200px;
  margin-top: 0;
}

.upload-tips p {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 13px;
  color: #333;
  margin-bottom: 8px;
}

.upload-tips i {
  color: #1890ff;
  font-size: 14px;
}

.upload-tips ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.upload-tips li {
  font-size: 12px;
  color: #666;
  line-height: 1.6;
  position: relative;
  padding-left: 12px;
}

.upload-tips li::before {
  content: '';
  position: absolute;
  left: 0;
  top: 8px;
  width: 4px;
  height: 4px;
  background: #1890ff;
  border-radius: 50%;
}

.address-input :deep(.el-input__prefix) {
  color: #1890ff;
}

.status-radio :deep(.el-radio__label) {
  font-size: 14px;
}

.rich-editor {
  border: 1px solid #e8e8e8;
  border-radius: 8px;
  min-height: 300px;
  margin-left: -80px;
}

.form-actions {
  text-align: center;
  margin-top: 40px;
  padding-top: 20px;
  border-top: 1px solid #f0f0f0;
}

.submit-btn {
  width: 180px;
  height: 40px;
  font-size: 16px;
  border-radius: 20px;
  background: #1890ff;
  border-color: #1890ff;
  transition: all 0.3s;
}

.submit-btn:hover {
  background: #40a9ff;
  border-color: #40a9ff;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.2);
}
</style>
