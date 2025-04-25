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
  margin: 40px auto;
  padding: 30px 40px;
}
.title {
  text-align: center;
  margin-bottom: 30px;
  font-size: 20px;
  font-weight: 600;
}
.feedback-form >>> .el-input__count {
  line-height: 20px;
}
.actions {
  text-align: center;
  margin-top: 10px;
}
</style>
