<template>
  <div class="manager-container">
    <!--  头部  -->
    <div class="manager-header">
      <div class="manager-header-left">
        <img src="@/assets/imgs/logo.png" class="logo" />
        <div class="title">前湖集市后台管理</div>
      </div>

      <div class="manager-header-center">
        <el-breadcrumb separator-class="el-icon-arrow-right">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item :to="{ path: $route.path }">{{ $route.meta.name }}</el-breadcrumb-item>
        </el-breadcrumb>
      </div>

      <div class="manager-header-right">
        <el-tooltip content="全屏" placement="bottom">
          <i class="el-icon-full-screen" @click="toggleFullScreen"></i>
        </el-tooltip>
        <el-tooltip content="刷新" placement="bottom">
          <i class="el-icon-refresh" @click="refreshPage"></i>
        </el-tooltip>
        <el-dropdown placement="bottom" trigger="click">
          <div class="avatar">
            <el-avatar 
              :size="36" 
              :src="user.avatar" 
              :icon="user.avatar ? '' : 'el-icon-user'"
              :style="{ backgroundColor: user.avatar ? '' : '#1890ff' }">
            </el-avatar>
            <div class="user-info">
              <div class="name">{{ user.name }}</div>
              <div class="role">{{ user.role === 'ADMIN' ? '管理员' : '普通用户' }}</div>
            </div>
          </div>
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item @click.native="goToPerson">
              <i class="el-icon-user"></i> 个人信息
            </el-dropdown-item>
            <el-dropdown-item @click.native="$router.push('/password')">
              <i class="el-icon-lock"></i> 修改密码
            </el-dropdown-item>
            <el-dropdown-item divided @click.native="logout">
              <i class="el-icon-switch-button"></i> 退出登录
            </el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
      </div>
    </div>

    <!--  主体  -->
    <div class="manager-main">
      <!--  侧边栏  -->
      <div class="manager-main-left" :class="{ 'is-collapse': isCollapse }">
        <div class="collapse-btn" @click="toggleCollapse">
          <i :class="isCollapse ? 'el-icon-s-unfold' : 'el-icon-s-fold'"></i>
        </div>
        <el-menu 
          :default-openeds="['info', 'user']" 
          router 
          style="border: none" 
          :default-active="$route.path"
          :collapse="isCollapse"
          class="el-menu-vertical">
          <el-menu-item index="/home">
            <i class="el-icon-s-home"></i>
            <span slot="title">系统首页</span>
          </el-menu-item>
          <el-submenu index="info">
            <template slot="title">
              <i class="el-icon-menu"></i>
              <span>信息管理</span>
            </template>
            <el-menu-item index="/category">
              <i class="el-icon-folder"></i>
              <span>分类信息</span>
            </el-menu-item>
            <el-menu-item index="/goods">
              <i class="el-icon-goods"></i>
              <span>商品信息</span>
            </el-menu-item>
            <el-menu-item index="/circles">
              <i class="el-icon-circle-plus"></i>
              <span>圈子信息</span>
            </el-menu-item>
            <el-menu-item index="/posts">
              <i class="el-icon-document"></i>
              <span>社区帖子</span>
            </el-menu-item>
            <el-menu-item index="/help">
              <i class="el-icon-question"></i>
              <span>求助信息</span>
            </el-menu-item>
            <el-menu-item index="/address">
              <i class="el-icon-location"></i>
              <span>收货地址</span>
            </el-menu-item>
            <el-menu-item index="/feedback">
              <i class="el-icon-chat-dot-round"></i>
              <span>用户反馈</span>
            </el-menu-item>
            <el-menu-item index="/notice">
              <i class="el-icon-bell"></i>
              <span>公告信息</span>
            </el-menu-item>
            <el-menu-item index="/comment">
              <i class="el-icon-chat-line-round"></i>
              <span>评论信息</span>
            </el-menu-item>
          </el-submenu>

          <el-submenu index="user">
            <template slot="title">
              <i class="el-icon-user"></i>
              <span>用户管理</span>
            </template>
            <el-menu-item index="/admin">
              <i class="el-icon-s-custom"></i>
              <span>管理员信息</span>
            </el-menu-item>
            <el-menu-item index="/user">
              <i class="el-icon-user"></i>
              <span>用户信息</span>
            </el-menu-item>
          </el-submenu>
        </el-menu>
      </div>

      <!--  数据表格  -->
      <div class="manager-main-right">
        <router-view @update:user="updateUser" />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "Manager",
  data() {
    return {
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      isCollapse: false,
      isFullScreen: false
    }
  },
  created() {
    if (!this.user.id) {
      this.$router.push('/login')
    }
  },
  methods: {
    updateUser() {
      this.user = JSON.parse(localStorage.getItem('xm-user') || '{}')
    },
    goToPerson() {
      if (this.user.role === 'ADMIN') {
        this.$router.push('/adminPerson')
      }
    },
    logout() {
      this.$confirm('确定要退出登录吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        localStorage.removeItem('xm-user')
        this.$router.push('/login')
        this.$message({
          type: 'success',
          message: '退出成功!'
        })
      }).catch(() => {})
    },
    toggleCollapse() {
      this.isCollapse = !this.isCollapse
    },
    toggleFullScreen() {
      if (!document.fullscreenElement) {
        document.documentElement.requestFullscreen()
      } else {
        if (document.exitFullscreen) {
          document.exitFullscreen()
        }
      }
    },
    refreshPage() {
      this.$router.go(0)
    }
  }
}
</script>

<style scoped>
@import "@/assets/css/manager.css";

.manager-header-right i {
  font-size: 20px;
  color: #fff;
  margin-right: 20px;
  cursor: pointer;
  transition: all 0.3s;
}

.manager-header-right i:hover {
  color: rgba(255, 255, 255, 0.8);
  transform: scale(1.1);
}

.user-info {
  margin-left: 8px;
  text-align: left;
}

.user-info .name {
  font-size: 14px;
  font-weight: 500;
}

.user-info .role {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.7);
}

.collapse-btn {
  height: 40px;
  line-height: 40px;
  text-align: center;
  color: #666;
  cursor: pointer;
  transition: all 0.3s;
}

.collapse-btn:hover {
  background-color: #f0f7ff;
  color: #1890ff;
}

.collapse-btn i {
  font-size: 20px;
}

.el-menu-vertical:not(.el-menu--collapse) {
  width: 240px;
}

.manager-main-left.is-collapse {
  width: 64px;
}

.el-dropdown-menu__item i {
  margin-right: 8px;
}
</style>