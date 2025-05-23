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
      <div class="front-header-chat" @click="handleChatClick">
        <i class="el-icon-chat-dot-round" style="margin-right: 4px"></i> 聊天消息
        <div v-if="totalUnreadCount > 0" class="unread-badge">{{ totalUnreadCount }}</div>
      </div>

      <!-- AI客服 -->
      <div class="front-header-ai" @click="handleAIClick">
        <i class="el-icon-service" style="margin-right: 4px"></i> AI客服
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
              <div class="avatar-wrapper">
                <img :src="user.avatar" class="avatar" alt="用户头像" />
              </div>
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

    <!-- AI客服对话框 -->
    <el-dialog
      title="AI客服"
      :visible.sync="aiDialogVisible"
      width="700px"
      :close-on-click-modal="false"
      custom-class="ai-dialog"
    >
      <div class="ai-chat-container">
        <div class="ai-chat-messages" ref="chatMessages">
          <div class="ai-history-btn-wrapper">
            <el-button
              size="mini"
              @click="loadAIHistory"
              :loading="aiHistoryLoading"
              :disabled="aiMessages.length >= aiHistoryTotal && aiHistoryTotal > 0"
            >
              查看历史聊天记录
            </el-button>
          </div>
          <div v-for="(msg, index) in aiMessages" :key="index" :class="['message', msg.type]">
            <div class="avatar">
              <img :src="msg.type === 'user' ? user.avatar : 'https://api.dicebear.com/7.x/bottts/svg?seed=ai-assistant'" alt="avatar">
            </div>
            <div class="content">
              {{ msg.content }}
              <div v-if="msg.time" class="msg-time">{{ msg.time | dateFormat }}</div>
            </div>
          </div>
          <div v-if="aiLoading" class="ai-loading">
            <i class="el-icon-loading"></i> AI客服正在思考中...
          </div>
        </div>
        <div class="ai-chat-input">
          <el-input
            v-model="aiInputMessage"
            placeholder="请输入您的问题..."
            @keyup.enter.native="sendAIMessage"
          >
            <el-button slot="append" icon="el-icon-position" @click="sendAIMessage"></el-button>
          </el-input>
        </div>
      </div>
    </el-dialog>
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
        { text: '校园广场', path: '/front/posts' },
        { text: '求助专区', path: '/front/help' },
        { text: '系统公告', path: '/front/notice' },
        { text: '留言反馈', path: '/front/feedback' },
      ],
      totalUnreadCount: 0,
      ws: null,
      processedMessageIds: new Set(),
      activeNotifications: new Set(),
      // AI客服相关
      aiDialogVisible: false,
      aiInputMessage: '',
      aiMessages: [],
      aiLoading: false,
      aiHistoryLoading: false,
      aiHistoryPage: 1,
      aiHistorySize: 20,
      aiHistoryTotal: 0,
    }
  },
  mounted() {
    if (this.user.id) {
      this.getUnreadCount();
      this.initWebSocket();
    }
  },
  beforeDestroy() {
    this.closeWebSocket();
    this.processedMessageIds.clear();
    this.activeNotifications.clear();
  },
  methods: {
    showNotification(data) {
      const notificationId = `${data.fromUserId}-${data.timestamp}`;
      
      if (this.activeNotifications.has(notificationId)) {
        console.log('通知已在显示中，跳过:', notificationId);
        return;
      }
      
      this.activeNotifications.add(notificationId);
      
      const h = this.$createElement;
      const notification = this.$notify({
        title: '新消息提醒',
        message: h('div', { 
          style: {
            display: 'flex',
            alignItems: 'center',
            cursor: 'pointer'
          },
          on: {
            click: () => {
              this.$router.push({
                path: '/front/chat',
                query: { toUserId: data.fromUserId }
              });
              this.activeNotifications.delete(notificationId);
              notification.close();
            }
          }
        }, [
          h('img', {
            style: {
              width: '30px',
              height: '30px',
              borderRadius: '50%',
              marginRight: '8px'
            },
            attrs: {
              src: data.fromUserAvatar
            }
          }),
          h('div', [
            h('div', { style: { fontWeight: 'bold' } }, data.fromUserName),
            h('div', { style: { color: '#666' } }, data.content)
          ])
        ]),
        type: 'success',
        duration: 5000,
        position: 'bottom-right',
        onClose: () => {
          this.activeNotifications.delete(notificationId);
        }
      });
    },
    initWebSocket() {
      if (typeof WebSocket === 'undefined') {
        this.$message.error('您的浏览器不支持WebSocket');
        return;
      }
      this.closeWebSocket();
      
      const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
      const wsPort = '9090';
      const wsUrl = `${protocol}//${window.location.hostname}:${wsPort}/chatServer/${this.user.id}`;
      
      console.log('正在连接WebSocket:', wsUrl);
      
      try {
        this.ws = new WebSocket(wsUrl);
        
        this.ws.onopen = () => {
          console.log('WebSocket连接成功');
          this.getUnreadCount();
        };
        
        this.ws.onmessage = (e) => {
          try {
            const data = JSON.parse(e.data);
            if (data.type === 'chat' && data.toUserId === this.user.id) {
              const messageId = `${data.fromUserId}-${data.timestamp}`;
              
              if (this.processedMessageIds.has(messageId)) {
                console.log('跳过重复消息:', messageId);
                return;
              }
              
              this.processedMessageIds.add(messageId);
              
              if (this.processedMessageIds.size > 100) {
                const idsArray = Array.from(this.processedMessageIds);
                this.processedMessageIds = new Set(idsArray.slice(-50));
              }

              this.getUnreadCount();
              
              this.showNotification(data);
            }
          } catch (error) {
            console.error('解析WebSocket消息失败:', error);
          }
        };
        
        this.ws.onclose = () => {
          console.log('WebSocket连接关闭');
          setTimeout(() => {
            this.initWebSocket();
          }, 3000);
        };
        
        this.ws.onerror = () => {
          console.error('WebSocket连接错误');
          this.closeWebSocket();
        };
      } catch (error) {
        console.error('创建WebSocket连接失败:', error);
        this.$message.error('连接聊天服务失败');
      }
    },
    closeWebSocket() {
      if (this.ws) {
        this.ws.close();
        this.ws = null;
      }
    },
    getUnreadCount() {
      this.$request.get('/chatGroup/selectUserGroup').then(res => {
        if (res.code === '200') {
          this.totalUnreadCount = res.data.reduce((total, chat) => total + (chat.chatNum || 0), 0);
          console.log('更新未读消息总数:', this.totalUnreadCount);
        }
      });
    },
    updateUser() {
      this.user = JSON.parse(localStorage.getItem("xm-user") || '{}');
      if (this.user.id) {
        this.getUnreadCount();
        this.initWebSocket();
      } else {
        this.closeWebSocket();
      }
    },
    handleChatClick() {
      this.totalUnreadCount = 0;
      this.$router.push('/front/chat');
    },
    handleAIClick() {
      this.aiDialogVisible = true;
      this.aiHistoryPage = 1;
      this.aiHistoryTotal = 0;
      if (this.aiMessages.length === 0) {
        this.aiMessages.push({
          type: 'ai',
          content: '您好！我是前湖集市的AI客服，有什么可以帮您的吗？'
        });
      }
    },
    sendAIMessage() {
      if (!this.aiInputMessage.trim()) return;
      
      // 添加用户消息
      this.aiMessages.push({
        type: 'user',
        content: this.aiInputMessage
      });
      
      const userMessage = this.aiInputMessage;
      this.aiInputMessage = '';
      this.aiLoading = true;
      
      // 滚动到底部
      this.$nextTick(() => {
        this.$refs.chatMessages.scrollTop = this.$refs.chatMessages.scrollHeight;
      });
      
      // 发送请求
      this.$request.post('/aiChat/chat', {
        message: userMessage,
        mode: 'chat',
        userId: this.user.id || 1
      }).then(res => {
        this.aiLoading = false;
        if (res.code === '200') {
          this.aiMessages.push({
            type: 'ai',
            content: res.data.response
          });
          // 滚动到底部
          this.$nextTick(() => {
            this.$refs.chatMessages.scrollTop = this.$refs.chatMessages.scrollHeight;
          });
        } else {
          this.$message.error('获取AI回复失败');
        }
      }).catch(err => {
        this.aiLoading = false;
        console.error(err);
        this.$message.error('获取AI回复失败');
      });
    },
    logout() {
      localStorage.removeItem("xm-user")
      this.$router.push("/login")
    },
    async loadAIHistory() {
      if (!this.user.id) return;
      this.aiHistoryLoading = true;
      try {
        const res = await this.$request.get('/aiChat/history', {
          params: {
            userId: this.user.id,
            page: this.aiHistoryPage,
            size: this.aiHistorySize
          }
        });
        if (res.code === '200') {
          const history = (res.data.records || []).map(item => ({
            type: item.sender,
            content: item.content,
            time: item.createTime
          }));
          this.aiMessages = history.concat(this.aiMessages);
          this.aiHistoryTotal = res.data.total;
          this.aiHistoryPage += 1;
        } else {
          this.$message.error('加载历史聊天记录失败');
        }
      } catch (e) {
        this.$message.error('加载历史聊天记录失败');
      }
      this.aiHistoryLoading = false;
    },
  }
}
</script>

<style scoped>
.front-container {
  background-color: #f5f7fa;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.front-header {
  display: flex;
  align-items: center;
  background: linear-gradient(135deg, #40a9ff 0%, #1d39c4 100%);
  color: white;
  height: 64px;
  padding: 0 50px;
  justify-content: space-between;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 1000;
}

.front-header-left {
  display: flex;
  align-items: center;
  text-decoration: none;
  transition: all 0.3s;
  padding: 6px 12px;
  border-radius: 8px;
}

.front-header-left:hover {
  background: rgba(255, 255, 255, 0.1);
  transform: translateY(-1px);
}

.front-header-left .logo {
  width: 36px;
  height: 36px;
  margin-right: 12px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  transition: all 0.3s;
}

.front-header-left:hover .logo {
  transform: rotate(5deg);
}

.front-header-left .title {
  font-size: 22px;
  font-weight: bold;
  color: #fff;
  letter-spacing: 0.5px;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.front-header-center {
  display: flex;
  gap: 8px;
  margin: 0 40px;
  flex-grow: 1;
  justify-content: center;
  position: relative;
}

.menu {
  cursor: pointer;
  font-size: 15px;
  color: rgba(255, 255, 255, 0.85);
  transition: all 0.3s;
  padding: 8px 20px;
  border-radius: 20px;
  position: relative;
  display: flex;
  align-items: center;
  gap: 6px;
}

.menu::before {
  content: '';
  position: absolute;
  bottom: 0;
  left: 50%;
  width: 0;
  height: 2px;
  background-color: #fff;
  transition: all 0.3s;
  transform: translateX(-50%);
  opacity: 0;
}

.menu:hover::before,
.menu-active::before {
  width: 80%;
  opacity: 1;
}

.menu:hover {
  color: #fff;
  background: rgba(255, 255, 255, 0.1);
  transform: translateY(-1px);
}

.menu-active {
  color: #fff;
  background: rgba(255, 255, 255, 0.15);
  font-weight: 500;
}

.front-header-chat {
  font-size: 15px;
  cursor: pointer;
  color: rgba(255, 255, 255, 0.85);
  margin-right: 25px;
  display: flex;
  align-items: center;
  padding: 8px 16px;
  border-radius: 20px;
  transition: all 0.3s;
  background: rgba(255, 255, 255, 0.1);
  position: relative;
}

.front-header-chat:hover {
  color: #fff;
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-1px);
}

.front-header-chat i {
  margin-right: 6px;
  font-size: 18px;
}

.front-header-ai {
  font-size: 15px;
  cursor: pointer;
  color: rgba(255, 255, 255, 0.85);
  margin-right: 25px;
  display: flex;
  align-items: center;
  padding: 8px 16px;
  border-radius: 20px;
  transition: all 0.3s;
  background: rgba(255, 255, 255, 0.1);
}

.front-header-ai:hover {
  color: #fff;
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-1px);
}

.front-header-ai i {
  margin-right: 6px;
  font-size: 18px;
}

.front-header-right {
  display: flex;
  align-items: center;
  gap: 15px;
}

.front-header-right :deep(.el-button--text) {
  color: rgba(255, 255, 255, 0.85);
  font-size: 15px;
  padding: 8px 16px;
  transition: all 0.3s;
  height: auto;
  border-radius: 20px;
}

.front-header-right :deep(.el-button--text:hover) {
  color: #fff;
  background: rgba(255, 255, 255, 0.1);
  transform: translateY(-1px);
}

.user-info {
  display: flex;
  align-items: center;
  cursor: pointer;
  padding: 6px 16px;
  border-radius: 20px;
  transition: all 0.3s;
  background: rgba(255, 255, 255, 0.1);
  gap: 8px;
}

.user-info:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-1px);
}

.user-info .avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  border: 2px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  transition: all 0.3s;
  object-fit: cover;
}

.user-info:hover .avatar {
  border-color: rgba(255, 255, 255, 0.4);
  transform: scale(1.05);
}

.user-info span {
  font-size: 15px;
  color: #fff;
}

.user-info i {
  font-size: 14px;
  transition: all 0.3s;
}

.user-info:hover i {
  transform: rotate(180deg);
}

.main-body {
  padding: 24px;
  flex: 1;
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
}

:deep(.el-dropdown-menu) {
  padding: 8px;
  border-radius: 12px;
  box-shadow: 0 3px 15px rgba(0, 0, 0, 0.1);
  border: none;
}

:deep(.el-dropdown-menu__item) {
  padding: 10px 20px;
  font-size: 14px;
  border-radius: 6px;
  margin: 2px 0;
  transition: all 0.3s;
}

:deep(.el-dropdown-menu__item:hover) {
  background-color: #f0f7ff;
  color: #1890ff;
  transform: translateX(4px);
}

:deep(.el-dropdown-menu__item i) {
  margin-right: 8px;
  font-size: 16px;
}

.avatar-wrapper {
  position: relative;
  display: inline-block;
}

.avatar-badge {
  position: absolute;
  top: -5px;
  right: -5px;
  z-index: 1;
}

.unread-badge {
  position: absolute;
  background-color: #ff4d4f;
  color: white;
  font-size: 12px;
  padding: 0 6px;
  height: 18px;
  min-width: 18px;
  border-radius: 9px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  box-shadow: 0 2px 6px rgba(255, 77, 79, 0.4);
  animation: badge-pop 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

@keyframes badge-pop {
  from {
    transform: scale(0);
    opacity: 0;
  }
  to {
    transform: scale(1);
    opacity: 1;
  }
}

.ai-chat-container {
  height: 600px;
  display: flex;
  flex-direction: column;
}

.ai-chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  background: #f5f7fa;
  border-radius: 8px;
  margin-bottom: 20px;
}

.message {
  display: flex;
  margin-bottom: 20px;
}

.message.user {
  flex-direction: row-reverse;
}

.message .avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  overflow: hidden;
  margin: 0 10px;
}

.message .avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.message .content {
  max-width: 70%;
  padding: 12px 16px;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.message.user .content {
  background: #e6f7ff;
}

.ai-chat-input {
  padding: 0 20px;
}

:deep(.ai-dialog .el-dialog__body) {
  padding: 20px;
}

:deep(.ai-dialog .el-dialog__header) {
  padding: 20px;
  border-bottom: 1px solid #ebeef5;
}

:deep(.ai-dialog .el-dialog__title) {
  font-size: 18px;
  font-weight: 600;
}

.ai-loading {
  text-align: center;
  color: #1890ff;
  font-size: 16px;
  margin-top: 10px;
  animation: fadeIn 0.5s;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.msg-time {
  font-size: 12px;
  color: #999;
  margin-top: 4px;
  text-align: right;
}

.ai-history-btn-wrapper {
  display: flex;
  justify-content: center;
  margin-bottom: 10px;
}
</style>
