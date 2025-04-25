<template>
  <div class="profile-page">
    <el-card shadow="never" class="profile-card">
      <!-- ▍修改资料 -->
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
            <img v-if="user.avatar" :src="user.avatar" class="avatar" />
            <i v-else class="el-icon-plus avatar-placeholder" />
          </el-upload>
        </div>

        <el-form-item label="用户名">
          <el-input v-model="user.username" disabled />
        </el-form-item>

        <el-form-item label="姓名">
          <el-input v-model.trim="user.name" placeholder="姓名" />
        </el-form-item>

        <el-form-item label="电话">
          <el-input v-model.trim="user.phone" placeholder="电话" maxlength="11" />
        </el-form-item>

        <el-form-item label="邮箱">
          <el-input v-model.trim="user.email" placeholder="邮箱" />
        </el-form-item>

        <div class="actions">
          <el-button
            type="primary"
            size="mini"
            :loading="btnLoading"
            @click="update"
          >保存</el-button>
          <el-button
            size="mini"
            @click="dialogVisible = true"
          >修改密码</el-button>
        </div>
      </el-form>
    </el-card>

    <!-- ▍修改密码弹窗 -->
    <el-dialog
      title="修改密码"
      :visible.sync="dialogVisible"
      width="380px"
      :close-on-click-modal="false"
      destroy-on-close
    >
      <el-form
        ref="formRef"
        :model="user"
        :rules="rules"
        label-width="90px"
      >
        <el-form-item label="原始密码" prop="password">
          <el-input show-password v-model.trim="user.password" />
        </el-form-item>
        <el-form-item label="新密码" prop="newPassword">
          <el-input show-password v-model.trim="user.newPassword" />
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input show-password v-model.trim="user.confirmPassword" />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button size="mini" @click="dialogVisible = false">取消</el-button>
        <el-button
          type="primary"
          size="mini"
          :loading="pwdLoading"
          @click="savePwd"
        >确认</el-button>
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
  width: 50%;
  margin: 30px auto;
}
.profile-card {
  padding: 30px 40px;
}
.profile-form >>> .el-form-item__label {
  font-weight: 600;
}
.avatar-wrap {
  text-align: center;
  margin-bottom: 20px;
}
.avatar-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 50%;
  cursor: pointer;
}
.avatar-uploader:hover .el-upload {
  border-color: #409eff;
}
.avatar-placeholder {
  font-size: 28px;
  color: #8c939d;
  width: 120px;
  height: 120px;
  line-height: 120px;
  text-align: center;
  border-radius: 50%;
}
.avatar {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  display: block;
}
.actions {
  text-align: center;
  margin-top: 18px;
}
</style>
