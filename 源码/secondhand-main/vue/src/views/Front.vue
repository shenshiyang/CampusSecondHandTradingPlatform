<template>
  <div class="front-container">
    <!-- 顶部导航 -->
    <div class="front-header">
      <!-- 左侧 LOGO -->
      <a href="/front/home" class="front-header-left">
        <img src="@/assets/imgs/logo.png" class="logo" alt="logo" />
        <div class="title">前湖集市</div>
      </a>

      <!-- 中间菜单 -->
      <div class="front-header-center">
        <div
          v-for="item in menus"
          :key="item.path"
          class="menu"
          :class="{ 'menu-active': item.path === $route.path }"
          @click="$router.push(item.path)"
        >
          {{ item.text }}
        </div>
      </div>

      <!-- 聊天消息 -->
      <div class="front-header-chat" @click="$router.push('/front/chat')">
        <i class="el-icon-chat-dot-round" style="margin-right: 4px"></i> 聊天消息
      </div>

      <!-- 右侧用户 -->
      <div class="front-header-right">
        <template v-if="!user.username">
          <el-button type="text" @click="$router.push('/login')">登录</el-button>
          <el-button type="text" @click="$router.push('/register')">注册</el-button>
        </template>
        <template v-else>
          <el-dropdown>
            <div class="user-info">
              <img :src="user.avatar" class="avatar" alt="用户头像" />
              <span>{{ user.name }}</span>
              <i class="el-icon-arrow-down" style="margin-left: 4px"></i>
            </div>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item @click.native="$router.push('/front/orders')">我的订单</el-dropdown-item>
              <el-dropdown-item @click.native="$router.push('/front/goods')">我的商品</el-dropdown-item>
              <el-dropdown-item @click.native="$router.push('/front/userPosts')">我的发帖</el-dropdown-item>
              <el-dropdown-item @click.native="$router.push('/front/userHelp')">我的求助</el-dropdown-item>
              <el-dropdown-item @click.native="$router.push('/front/userFeedback')">我的反馈</el-dropdown-item>
              <el-dropdown-item @click.native="$router.push('/front/address')">我的地址</el-dropdown-item>
              <el-dropdown-item @click.native="$router.push('/front/person')">个人信息</el-dropdown-item>
              <el-dropdown-item @click.native="$router.push('/front/collect')">我的收藏</el-dropdown-item>
              <el-dropdown-item @click.native="logout">退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </template>
      </div>
    </div>

    <!-- 主体内容 -->
    <div class="main-body">
      <router-view ref="child" @update:user="updateUser" />
    </div>
  </div>
</template>

<script>
export default {
  name: "FrontLayout",
  data() {
    return {
      user: JSON.parse(localStorage.getItem("xm-user") || '{}'),
      menus: [
        { text: '热卖专区', path: '/front/home' },
        { text: '社区广场', path: '/front/posts' },
        { text: '求助专区', path: '/front/help' },
        { text: '系统公告', path: '/front/notice' },
        { text: '留言反馈', path: '/front/feedback' },
      ]
    }
  },
  methods: {
    updateUser() {
      this.user = JSON.parse(localStorage.getItem("xm-user") || '{}')
    },
    logout() {
      localStorage.removeItem("xm-user")
      this.$router.push("/login")
    }
  }
}
</script>

<style scoped>
.front-container {
  background-color: #f8f8f8;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.front-header {
  display: flex;
  align-items: center;
  background-color: #409EFF;
  color: white;
  height: 64px;
  padding: 0 20px;
  justify-content: space-between;
}

.front-header-left {
  display: flex;
  align-items: center;
  text-decoration: none;
}

.front-header-left .logo {
  width: 40px;
  height: 40px;
  margin-right: 8px;
}

.front-header-left .title {
  font-size: 20px;
  font-weight: bold;
  color: #fff;
}

.front-header-center {
  display: flex;
  gap: 24px;
  margin: 0 30px;
  flex-grow: 1;
  justify-content: center;
}

.menu {
  cursor: pointer;
  font-size: 16px;
  color: #eee;
  transition: color 0.3s;
}

.menu:hover,
.menu-active {
  color: #ffd04b;
}

.front-header-chat {
  font-size: 16px;
  cursor: pointer;
  color: #fff;
  margin-right: 20px;
}

.front-header-right {
  display: flex;
  align-items: center;
  gap: 10px;
}

.user-info {
  display: flex;
  align-items: center;
  cursor: pointer;
}

.user-info .avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  margin-right: 6px;
}

.main-body {
  padding: 20px;
  flex: 1;
}
</style>
