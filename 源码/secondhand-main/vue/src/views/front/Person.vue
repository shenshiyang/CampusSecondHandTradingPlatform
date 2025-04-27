<template>
  <div class="profile-page">
    <el-card shadow="hover" class="profile-card">
      <div class="card-header">
        <h2>个人资料</h2>
        <p class="subtitle">完善个人信息，让其他用户更了解你</p>
      </div>
      
      <el-form
        :model="user"
        label-width="80px"
        class="profile-form"
      >
        <!-- 头像上传 -->
        <div class="avatar-wrap">
          <el-upload
            class="avatar-uploader"
            :action="$baseUrl + '/files/upload'"
            :show-file-list="false"
            :on-success="handleAvatarSuccess"
          >
            <div class="avatar-container">
              <img v-if="user.avatar" :src="user.avatar" class="avatar" />
              <i v-else class="el-icon-plus avatar-placeholder" />
              <div class="avatar-hover">
                <i class="el-icon-camera"></i>
                <span>更换头像</span>
              </div>
            </div>
          </el-upload>
        </div>

        <el-form-item label="用户名">
          <el-input 
            v-model="user.username" 
            disabled
            prefix-icon="el-icon-user"
          />
        </el-form-item>

        <el-form-item label="用户昵称">
          <el-input 
            v-model.trim="user.name" 
            placeholder="请输入您的昵称"
            prefix-icon="el-icon-user-solid"
          />
        </el-form-item>

        <el-form-item label="电话">
          <el-input 
            v-model.trim="user.phone" 
            placeholder="请输入您的联系电话" 
            maxlength="11"
            prefix-icon="el-icon-phone"
          />
        </el-form-item>

        <el-form-item label="邮箱">
          <el-input 
            v-model.trim="user.email" 
            placeholder="请输入您的邮箱地址"
            prefix-icon="el-icon-message"
          />
        </el-form-item>

        <div class="actions">
          <el-button
            type="primary"
            :loading="btnLoading"
            @click="update"
            icon="el-icon-check"
          >保存修改</el-button>
          <el-button
            type="warning"
            @click="dialogVisible = true"
            icon="el-icon-key"
          >修改密码</el-button>
        </div>
      </el-form>
    </el-card>

    <!-- 修改密码弹窗 -->
    <el-dialog
      title="修改密码"
      :visible.sync="dialogVisible"
      width="400px"
      :close-on-click-modal="false"
      destroy-on-close
      custom-class="password-dialog"
    >
      <el-form
        ref="formRef"
        :model="user"
        :rules="rules"
        label-width="90px"
      >
        <el-form-item label="原始密码" prop="password">
          <el-input 
            show-password 
            v-model.trim="user.password"
            prefix-icon="el-icon-lock"
            placeholder="请输入原始密码"
          />
        </el-form-item>
        <el-form-item label="新密码" prop="newPassword">
          <el-input 
            show-password 
            v-model.trim="user.newPassword"
            prefix-icon="el-icon-key"
            placeholder="请输入新密码"
          />
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input 
            show-password 
            v-model.trim="user.confirmPassword"
            prefix-icon="el-icon-key"
            placeholder="请再次输入新密码"
          />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button 
          @click="dialogVisible = false"
          icon="el-icon-close"
        >取消</el-button>
        <el-button
          type="primary"
          :loading="pwdLoading"
          @click="savePwd"
          icon="el-icon-check"
        >确认修改</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'Profile',
  data() {
    const validateConfirm = (rule, value, cb) =>
      value !== this.user.newPassword
        ? cb(new Error('两次输入不一致'))
        : cb()

    return {
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      dialogVisible: false,
      btnLoading: false,
      pwdLoading: false,
      rules: {
        password: [{ required: true, message: '请输入原始密码', trigger: 'blur' }],
        newPassword: [{ required: true, message: '请输入新密码', trigger: 'blur' }],
        confirmPassword: [
          { required: true, validator: validateConfirm, trigger: 'blur' }
        ]
      }
    }
  },
  methods: {
    /* 头像上传成功 */
    handleAvatarSuccess({ data }) {
      this.user.avatar = data
      this.$message.success('上传成功')
    },

    /* 保存资料 */
    async update() {
      this.btnLoading = true
      const { code, msg } = await this.$request.put('/user/update', this.user)
      this.btnLoading = false
      if (code === '200') {
        this.$message.success('保存成功')
        localStorage.setItem('xm-user', JSON.stringify(this.user))
        this.$emit('update:user')
      } else {
        this.$message.error(msg)
      }
    },

    /* 保存密码 */
    savePwd() {
      this.$refs.formRef.validate(async (valid) => {
        if (!valid) return
        this.pwdLoading = true
        const { code, msg } = await this.$request.put('/updatePassword', this.user)
        this.pwdLoading = false
        if (code === '200') {
          this.$message.success('修改密码成功，请重新登录')
          this.$router.push('/login')
        } else {
          this.$message.error(msg)
        }
      })
    }
  }
}
</script>

<style scoped>
.profile-page {
  width: 60%;
  max-width: 800px;
  margin: 30px auto;
}

.profile-card {
  border-radius: 8px;
  padding: 0;
}

.card-header {
  background: linear-gradient(135deg, #409EFF 0%, #66b1ff 100%);
  color: white;
  padding: 20px 40px;
  border-radius: 8px 8px 0 0;
  margin-bottom: 30px;
}

.card-header h2 {
  margin: 0;
  font-size: 24px;
  font-weight: 500;
}

.subtitle {
  margin: 8px 0 0;
  font-size: 14px;
  opacity: 0.9;
}

.profile-form {
  padding: 0 40px 30px;
}

.profile-form :deep(.el-form-item__label) {
  font-weight: 500;
  color: #606266;
}

.profile-form :deep(.el-input__inner) {
  border-radius: 4px;
}

.profile-form :deep(.el-input__inner:focus) {
  border-color: #409EFF;
}

.avatar-wrap {
  text-align: center;
  margin-bottom: 30px;
}

.avatar-container {
  position: relative;
  display: inline-block;
  border-radius: 50%;
  overflow: hidden;
}

.avatar-uploader .el-upload {
  border: 2px dashed #e0e0e0;
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.3s;
}

.avatar-uploader:hover .el-upload {
  border-color: #409EFF;
}

.avatar-placeholder {
  font-size: 32px;
  color: #909399;
  width: 120px;
  height: 120px;
  line-height: 120px;
  text-align: center;
  border-radius: 50%;
  background: #f5f7fa;
}

.avatar {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  display: block;
  object-fit: cover;
}

.avatar-hover {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  color: white;
  opacity: 0;
  transition: all 0.3s;
}

.avatar-container:hover .avatar-hover {
  opacity: 1;
}

.avatar-hover i {
  font-size: 24px;
  margin-bottom: 8px;
}

.avatar-hover span {
  font-size: 14px;
}

.actions {
  text-align: center;
  margin-top: 30px;
}

.actions .el-button {
  padding: 12px 30px;
  font-size: 14px;
  border-radius: 4px;
  transition: all 0.3s;
}

.actions .el-button + .el-button {
  margin-left: 20px;
}

:deep(.password-dialog) {
  border-radius: 8px;
}

:deep(.password-dialog .el-dialog__header) {
  padding: 20px;
  background: #f5f7fa;
  border-radius: 8px 8px 0 0;
}

:deep(.password-dialog .el-dialog__title) {
  font-size: 18px;
  font-weight: 500;
  color: #303133;
}

:deep(.password-dialog .el-dialog__body) {
  padding: 30px 20px;
}

:deep(.password-dialog .el-dialog__footer) {
  padding: 10px 20px 20px;
  border-top: 1px solid #f0f0f0;
}

:deep(.el-button--primary) {
  background: linear-gradient(135deg, #409EFF 0%, #66b1ff 100%);
  border: none;
}

:deep(.el-button--primary:hover) {
  background: linear-gradient(135deg, #66b1ff 0%, #409EFF 100%);
  transform: translateY(-1px);
}

:deep(.el-button--warning) {
  background: linear-gradient(135deg, #e6a23c 0%, #f3d19e 100%);
  border: none;
  color: white;
}

:deep(.el-button--warning:hover) {
  background: linear-gradient(135deg, #f3d19e 0%, #e6a23c 100%);
  transform: translateY(-1px);
}
</style>
