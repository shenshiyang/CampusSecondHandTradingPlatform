<template>
  <div class="container">
    <div class="register-container">
      <div class="front-header">
        <a href="/front/home" class="front-header-left">
          <img src="@/assets/imgs/logo.png" class="logo" alt="logo" />
          <div class="title">前湖集市</div>
        </a>
      </div>
      <div class="content-wrapper">
        <div class="register-box">
          <div class="tab-wrapper">
            <a href="/login" class="tab-link"><div class="tab">登录</div></a>
            <div class="tab active">注册</div>
          </div>
          <el-form :model="form" :rules="rules" ref="formRef" class="register-form">
            <el-form-item prop="username">
              <el-input size="medium" prefix-icon="el-icon-user" placeholder="请输入账号" v-model="form.username"></el-input>
            </el-form-item>
            <el-form-item prop="password">
              <el-input size="medium" prefix-icon="el-icon-lock" placeholder="请输入密码" show-password  v-model="form.password"></el-input>
            </el-form-item>
            <el-form-item prop="confirmPassword">
              <el-input size="medium" prefix-icon="el-icon-lock" placeholder="请确认密码" show-password  v-model="form.confirmPassword"></el-input>
            </el-form-item>
            <el-form-item prop="captcha">
              <el-input size="medium" placeholder="请输入验证码" v-model="form.captcha" style="width: 180px; display: inline-block; margin-right: 10px;"></el-input>
              <img :src="captchaImg" @click="getCaptcha" style="height: 40px; vertical-align: middle; cursor: pointer;" title="点击刷新验证码"/>
            </el-form-item>
            <el-form-item>
              <el-button size="medium" class="register-btn" @click="login">注 册</el-button>
            </el-form-item>
          </el-form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "Register",
  data() {
    // 验证码校验
    const validatePassword = (rule, confirmPass, callback) => {
      if (confirmPass === '') {
        callback(new Error('请确认密码'))
      } else if (confirmPass !== this.form.password) {
        callback(new Error('两次输入的密码不一致'))
      } else {
        callback()
      }
    }
    return {
      captchaImg: '',
      captchaUuid: '',
      form: { role: 'USER', captcha: '' },
      rules: {
        username: [
          { required: true, message: '请输入账号', trigger: 'blur' },
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
        ],
        confirmPassword: [
          { validator: validatePassword, trigger: 'blur' }
        ],
        captcha: [
          { required: true, message: '请输入验证码', trigger: 'blur' }
        ]
      }
    }
  },
  created() {
    this.getCaptcha();
  },
  methods: {
    getCaptcha() {
      this.$request.get('/api/captcha').then(res => {
        if (res.code === '200') {
          this.captchaImg = res.data.img;
          this.captchaUuid = res.data.uuid;
        }
      })
    },
    login() {
      this.$refs['formRef'].validate((valid) => {
        if (valid) {
          this.$request.post('/register', {
            ...this.form,
            captchaUuid: this.captchaUuid
          }).then(res => {
            if (res.code === '200') {
              this.$router.push('/login')
              this.$message.success('注册成功')
            } else {
              this.$message.error(res.msg)
              this.getCaptcha();
            }
          })
        }
      })
    }
  }
}
</script>

<style scoped>
.container {
  height: 100vh;
  overflow: hidden;
  background: url('@/assets/imgs/home.png') center center no-repeat;
  background-size: cover;
  position: relative;
}

.container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(5px);
}

.register-container {
  position: relative;
  z-index: 1;
  height: 100%;
}

.front-header {
  display: flex;
  align-items: center;
  height: 64px;
  padding: 0 20px;
  background: #1890ff;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
}

.front-header-left {
  display: flex;
  align-items: center;
  gap: 10px;
  text-decoration: none;
}

.front-header-left img {
  width: 40px;
  height: 40px;
  border-radius: 6px;
  transition: all 0.3s ease;
}

.front-header-left img:hover {
  transform: scale(1.05);
}

.front-header-left .title {
  font-size: 20px;
  font-weight: bold;
  color: #fff;
  cursor: pointer;
}

.content-wrapper {
  height: calc(100vh - 64px);
  display: flex;
  align-items: center;
  justify-content: center;
}

.register-box {
  width: 400px;
  padding: 40px;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 15px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
}

.tab-wrapper {
  display: flex;
  margin-bottom: 40px;
  font-size: 24px;
  border-bottom: 1px solid #eee;
  padding-bottom: 15px;
}

.tab {
  padding: 0 20px 15px;
  cursor: pointer;
  color: #666;
  position: relative;
}

.tab.active {
  color: #1890ff;
  font-weight: 500;
}

.tab.active::after {
  content: '';
  position: absolute;
  bottom: -16px;
  left: 0;
  width: 100%;
  height: 3px;
  background: #1890ff;
  border-radius: 3px;
}

.tab-link {
  text-decoration: none;
}

.register-form {
  margin-top: 20px;
}

.register-btn {
  width: 100%;
  background-color: #1890ff;
  border-color: #1890ff;
  color: white;
  height: 40px;
  font-size: 16px;
  transition: all 0.3s;
}

.register-btn:hover {
  background-color: #40a9ff;
  border-color: #40a9ff;
  transform: translateY(-1px);
}

:deep(.el-input__inner) {
  height: 40px;
  line-height: 40px;
}
</style>