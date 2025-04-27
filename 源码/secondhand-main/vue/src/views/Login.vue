<template>
  <div class="container">
    <div class="login-container">
      <div class="front-header">
        <a href="/front/home" class="front-header-left">
          <img src="@/assets/imgs/logo.png" class="logo" alt="logo" />
          <div class="title">前湖集市</div>
        </a>
      </div>
      <div class="content-wrapper">
        <div class="login-box">
          <div class="tab-wrapper">
            <div class="tab active">登录</div>
            <a href="/register" class="tab-link"><div class="tab">注册</div></a>
          </div>
          <el-form :model="form" :rules="rules" ref="formRef" class="login-form">
            <el-form-item prop="username">
              <el-input size="medium" prefix-icon="el-icon-user" placeholder="请输入账号" v-model="form.username"></el-input>
            </el-form-item>
            <el-form-item prop="password">
              <el-input size="medium" prefix-icon="el-icon-lock" placeholder="请输入密码" show-password  v-model="form.password"></el-input>
            </el-form-item>
            <el-form-item prop="role">
              <el-select v-model="form.role" class="role-select">
                <el-option label="管理员" value="ADMIN"></el-option>
                <el-option label="用户" value="USER"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button size="medium" class="login-btn" @click="login">登 录</el-button>
            </el-form-item>
          </el-form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "Login",
  data() {
    return {
      form: { role: 'USER' },
      rules: {
        username: [
          { required: true, message: '请输入账号', trigger: 'blur' },
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
        ]
      }
    }
  },
  created() {

  },
  methods: {
    login() {
      this.$refs['formRef'].validate((valid) => {
        if (valid) {
          // 验证通过
          this.$request.post('/login', this.form).then(res => {
            if (res.code === '200') {
              localStorage.setItem("xm-user", JSON.stringify(res.data))  // 存储用户数据
              if (res.data.role === 'ADMIN') {
                this.$router.push('/home')  // 跳转主页
              } else {
                this.$router.push('/front/home')  // 跳转主页
              }
              this.$message.success('登录成功')
            } else {
              this.$message.error(res.msg)
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

.login-container {
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

.login-box {
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

.login-form {
  margin-top: 20px;
}

.role-select {
  width: 100%;
}

.login-btn {
  width: 100%;
  background-color: #1890ff;
  border-color: #1890ff;
  color: white;
  height: 40px;
  font-size: 16px;
  transition: all 0.3s;
}

.login-btn:hover {
  background-color: #40a9ff;
  border-color: #40a9ff;
  transform: translateY(-1px);
}

:deep(.el-input__inner) {
  height: 40px;
  line-height: 40px;
}

:deep(.el-select .el-input__inner) {
  height: 40px;
  line-height: 40px;
}
</style>