<template>
  <el-card class="feedback-card" shadow="never">
    <h2 class="title">请填写反馈内容</h2>

    <el-form
      ref="formRef"
      :model="form"
      :rules="rules"
      label-width="80px"
      class="feedback-form"
    >
      <el-form-item label="主题" prop="title">
        <el-input
          v-model.trim="form.title"
          maxlength="50"
          show-word-limit
          placeholder="请输入主题"
          clearable
        />
      </el-form-item>

      <el-form-item label="内容" prop="content">
        <el-input
          v-model.trim="form.content"
          type="textarea"
          :autosize="{ minRows: 4, maxRows: 6 }"
          maxlength="300"
          show-word-limit
          placeholder="请输入内容"
          clearable
        />
      </el-form-item>

      <el-form-item label="电话" prop="phone">
        <el-input
          v-model.trim="form.phone"
          maxlength="11"
          placeholder="请输入手机号"
          clearable
        />
      </el-form-item>

      <el-form-item label="邮箱" prop="email">
        <el-input
          v-model.trim="form.email"
          placeholder="请输入邮箱"
          clearable
        />
      </el-form-item>

      <div class="actions">
        <el-button
          type="primary"
          :loading="btnLoading"
          @click="save"
        >提交反馈</el-button>
      </div>
    </el-form>
  </el-card>
</template>

<script>
export default {
  name: 'Feedback',
  data() {
    const phoneReg = /^1\d{10}$/;
    const emailReg =
      /^[A-Za-z0-9]+([._%+-]?[A-Za-z0-9]+)*@[A-Za-z0-9-]+(\.[A-Za-z]{2,})+$/;
    return {
      form: {},
      btnLoading: false,
      rules: {
        title: [{ required: true, message: '请输入主题', trigger: 'blur' }],
        content: [{ required: true, message: '请输入内容', trigger: 'blur' }],
        phone: [{ pattern: phoneReg, message: '手机号格式不正确', trigger: 'blur' }],
        email: [{ pattern: emailReg, message: '邮箱格式不正确', trigger: 'blur' }]
      }
    };
  },
  methods: {
    async save() {
      this.$refs.formRef.validate(async (valid) => {
        if (!valid) return;
        this.btnLoading = true;
        const { code, msg } = await this.$request.post('/feedback/add', this.form);
        this.btnLoading = false;

        if (code === '200') {
          this.$message.success('提交成功');
          this.form = {}; // 清空表单
          this.$nextTick(() => this.$refs.formRef.clearValidate());
        } else {
          this.$message.error(msg);
        }
      });
    }
  }
};
</script>

<style scoped>
.feedback-card {
  width: 50%;
  max-width: 600px;
  margin: 40px auto;
  padding: 40px;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08) !important;
}

.title {
  text-align: center;
  margin-bottom: 35px;
  font-size: 24px;
  font-weight: 600;
  color: #333;
  position: relative;
  padding-bottom: 15px;
}

.title::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 40px;
  height: 3px;
  background: #1890ff;
  border-radius: 2px;
}

.feedback-form {
  max-width: 460px;
  margin: 0 auto;
}

/* 表单项样式 */
:deep(.el-form-item) {
  margin-bottom: 25px;
}

:deep(.el-form-item__label) {
  font-weight: 500;
  color: #333;
  padding-right: 15px;
}

/* 输入框样式 */
:deep(.el-input__inner) {
  border-radius: 8px;
  border-color: #e8e8e8;
  padding: 0 15px;
  height: 40px;
  transition: all 0.3s;
}

:deep(.el-input__inner:hover) {
  border-color: #40a9ff;
}

:deep(.el-input__inner:focus) {
  border-color: #1890ff;
  box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.1);
}

/* 文本域样式 */
:deep(.el-textarea__inner) {
  border-radius: 8px;
  border-color: #e8e8e8;
  padding: 10px 15px;
  transition: all 0.3s;
}

:deep(.el-textarea__inner:hover) {
  border-color: #40a9ff;
}

:deep(.el-textarea__inner:focus) {
  border-color: #1890ff;
  box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.1);
}

/* 字数统计样式 */
:deep(.el-input__count) {
  line-height: 20px;
  background: transparent;
  color: #999;
}

:deep(.el-input__count-inner) {
  background: transparent;
  padding: 0 8px;
}

/* 提交按钮样式 */
.actions {
  text-align: center;
  margin-top: 35px;
}

:deep(.el-button--primary) {
  width: 180px;
  height: 40px;
  border-radius: 20px;
  font-size: 16px;
  font-weight: 500;
  background: #1890ff;
  border-color: #1890ff;
  transition: all 0.3s;
}

:deep(.el-button--primary:hover) {
  background: #40a9ff;
  border-color: #40a9ff;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.2);
}

:deep(.el-button--primary:active) {
  background: #096dd9;
  border-color: #096dd9;
}

/* 错误提示样式 */
:deep(.el-form-item__error) {
  padding-top: 4px;
  color: #ff4d4f;
}

/* 响应式调整 */
@media screen and (max-width: 768px) {
  .feedback-card {
    width: 90%;
    padding: 30px 20px;
  }
  
  .feedback-form {
    max-width: 100%;
  }
}
</style>
