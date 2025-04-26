<template>
  <div class="home-container">
    <!-- 顶部横幅区域 -->
    <div class="banner">
      <div class="banner-content">
        <div class="banner-left">
          <h1 class="banner-title">前湖二手集市</h1>
          <p class="banner-subtitle">发现校园里的好物，让闲置焕发新生</p>
          <div class="search-wrapper">
            <el-input 
              v-model="name" 
              placeholder="搜索你想要的商品..."
              class="search-input"
              clearable
            >
              <el-button 
                slot="append" 
                @click="$router.push({ path: '/front/search', query: { name: name } })" 
                class="search-btn"
              >
                搜索
              </el-button>
            </el-input>
            <div class="hot-keywords">
              <span>热门搜索：</span>
              <a href="#" class="keyword">数码</a>
              <a href="#" class="keyword">图书</a>
              <a href="#" class="keyword">运动</a>
              <a href="#" class="keyword">服饰</a>
            </div>
          </div>
        </div>
        <div class="banner-right">
          <div class="action-card publish">
            <el-button 
              @click="$router.push('/front/addGoods')" 
              type="primary" 
              class="action-btn"
            >
              <i class="el-icon-plus"></i>
              发布商品
            </el-button>
            <p class="action-desc">闲置物品变现</p>
          </div>
          <div class="action-card help">
            <el-button 
              @click="$router.push('/front/userHelp')" 
              type="primary" 
              plain
              class="action-btn"
            >
              <i class="el-icon-help"></i>
              发布求助
            </el-button>
            <p class="action-desc">寻找心仪好物</p>
          </div>
          <div class="action-card chat" v-if="user.id">
            <el-button 
              @click="$router.push('/front/chat')" 
              type="primary"
              class="action-btn"
              :class="{ 'has-unread': unreadCount > 0 }"
            >
              <i class="el-icon-chat-dot-round"></i>
              聊天消息
              <div v-if="unreadCount > 0" class="unread-badge">{{ unreadCount }}</div>
            </el-button>
            <p class="action-desc">{{ unreadCount > 0 ? `${unreadCount}条未读消息` : '暂无未读消息' }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      categoryList: [],
      goodsList: [],  // 所有的数据
      pageNum: 1,   // 当前的页码
      pageSize: 12,  // 每页显示的个数
      total: 0,
      category: '全部',
      sort: '最新',
      name: '',
      unreadCount: 0,
      ws: null,
      user: JSON.parse(localStorage.getItem("xm-user") || '{}')
    }
  },
  mounted() {
    this.loadCategory()
    this.loadGoods(1)
    if (this.user.id) {
      this.connectWebSocket()
      this.getUnreadCount()
    }
  },
  beforeDestroy() {
    if (this.ws) {
      this.ws.close()
    }
  },
  methods: {
    connectWebSocket() {
      if (this.ws) {
        this.ws.close()
      }
      
      const wsUrl = `ws://${window.location.hostname}:${window.location.port}/chatServer/${this.user.id}`
      this.ws = new WebSocket(wsUrl)
      
      this.ws.onmessage = () => {
        this.getUnreadCount()
      }
      
      this.ws.onclose = () => {
        setTimeout(() => {
          this.connectWebSocket()
        }, 1000)
      }
      
      this.ws.onerror = () => {
        this.ws.close()
      }
    },
    getUnreadCount() {
      this.$request.get('/chatGroup/selectUserGroup').then(res => {
        if (res.code === '200') {
          this.unreadCount = res.data.reduce((total, chat) => total + (chat.chatNum || 0), 0)
        }
      })
    },
  }
}
</script>

<style scoped>
.action-btn {
  width: 130px;
  height: 40px;
  border-radius: 20px;
  font-size: 15px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  transition: all 0.3s;
  position: relative;
}

.action-btn.has-unread {
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0% {
    box-shadow: 0 0 0 0 rgba(24, 144, 255, 0.4);
  }
  70% {
    box-shadow: 0 0 0 10px rgba(24, 144, 255, 0);
  }
  100% {
    box-shadow: 0 0 0 0 rgba(24, 144, 255, 0);
  }
}

.unread-badge {
  position: absolute;
  top: -8px;
  right: -8px;
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
</style> 