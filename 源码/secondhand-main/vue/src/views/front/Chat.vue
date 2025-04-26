<template>
  <div class="chat-page">
    <div class="chat-user-list">
      <div
        v-for="item in userList"
        :key="item.chatUserId"
        :class="['chat-user', item.chatUserId === active ? 'active' : '']"
        @click="changeChatUser(item)">
        <div class="user-avatar">
          <img :src="item.chatUserAvatar" alt="">
        </div>
        <div class="user-info">
          <div class="user-name">{{ item.chatUserName }}</div>
          <div class="last-msg">{{ item.lastMessage }}</div>
          <span v-if="item.unreadCount" class="chat-unread-count">{{ item.unreadCount }}</span>
        </div>
      </div>
    </div>

    <div class="chat-main" v-if="active">
      <div class="chat-header">
        <div class="chat-title">
          <img :src="activeUserAvatar" alt="" class="title-avatar">
          <span>{{ chatTitle }}</span>
        </div>
        <div class="chat-actions">
          <i class="el-icon-more"></i>
        </div>
      </div>

      <div class="chat-box" ref="chatBox">
        <div
          v-for="(item, index) in chatList"
          :key="index"
          :class="['msg-box', item.userId === user.id ? 'right' : 'left']">
          <img
            class="avatar"
            :src="item.userId === user.id ? user.avatar : activeUserAvatar"
            alt="头像">
          <div class="msg-content">
            <div class="msg-text" v-if="!item.contentType || item.contentType === 'text'">{{ item.text }}</div>
            <div class="msg-image" v-else-if="item.contentType === 'image'" @click="previewImage(item.text)">
              <el-image 
                :src="item.text" 
                :preview-src-list="[item.text]"
                fit="cover">
              </el-image>
            </div>
            <div class="msg-file" v-else-if="item.contentType === 'file'">
              <i class="el-icon-document"></i>
              <span class="file-name">{{ item.fileName || '文件' }}</span>
              <a :href="item.text" target="_blank" class="download-btn">下载</a>
            </div>
          </div>
        </div>
      </div>

      <div class="chat-input">
        <div class="input-tools">
          <div class="emoji-tool">
            <i class="el-icon-sunny" @click="showEmoji = !showEmoji"></i>
            <div class="emoji-panel" v-show="showEmoji">
              <div class="emoji-list">
                <span
                  v-for="(emoji, index) in emojiList"
                  :key="index"
                  @click="insertEmoji(emoji)"
                  class="emoji-item"
                >{{ emoji }}</span>
              </div>
            </div>
          </div>
          <el-upload
            class="upload-demo"
            :action="$baseUrl + '/files/upload'"
            :headers="{ token: user.token }"
            :show-file-list="false"
            :on-success="handleImageSuccess"
            accept="image/*">
            <i class="el-icon-picture-outline"></i>
          </el-upload>
          <el-upload
            class="upload-demo"
            :action="$baseUrl + '/files/upload'"
            :headers="{ token: user.token }"
            :show-file-list="false"
            :on-success="handleFileSuccess"
            accept="*">
            <i class="el-icon-folder"></i>
          </el-upload>
        </div>
        <div class="input-box">
          <el-input
            v-model="content"
            type="textarea"
            :rows="3"
            placeholder="请输入聊天内容"
            @keyup.enter.native="send"
            resize="none">
          </el-input>
          <el-button type="primary" class="send-btn" @click="send">发送</el-button>
        </div>
      </div>
    </div>

    <div class="chat-welcome" v-else>
      <div class="welcome-content">
        <i class="el-icon-chat-line-round"></i>
        <p>选择一个联系人开始聊天</p>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      userList: [],
      chatList: [],
      chatTitle: '',
      active: null,
      content: '',
      activeUserAvatar: '',
      ws: null,
      showEmoji: false,
      processedMessageKeys: new Set(),
      emojiList: [
        '😀', '😃', '😄', '😁', '😆', '😅', '😂', '🤣', '😊', '😇',
        '🙂', '🙃', '😉', '😌', '😍', '🥰', '😘', '😗', '😙', '😚',
        '😋', '😛', '😝', '😜', '🤪', '🤨', '🧐', '🤓', '😎', '🤩',
        '🥳', '😏', '😒', '😞', '😔', '😟', '😕', '🙁', '☹️', '😣',
        '😖', '😫', '😩', '🥺', '😢', '😭', '😤', '😠', '😡', '🤬',
        '🤯', '😳', '🥵', '🥶', '😱', '😨', '😰', '😥', '😓', '🤗',
        '🤔', '🤭', '🤫', '🤥', '😶', '😐', '😑', '😬', '🙄', '😯',
        '😦', '😧', '😮', '😲', '🥱', '😴', '🤤', '😪', '😵', '🤐',
        '🥴', '🤢', '🤮', '🤧', '😷', '🤒', '🤕', '🤑', '🤠', '😈',
        '👿', '👹', '👺', '🤡', '💩', '👻', '💀', '☠️', '👽', '👾'
      ],
      wsConnected: false,
      manualClosed: false
    }
  },
  mounted() {
    // 确保用户信息存在
    if (!this.user || !this.user.id) {
      console.error('用户未登录');
      this.$message.error('请先登录');
      return;
    }

    console.log('当前用户信息:', this.user);
    
    this.loadUserList().then(() => {
      const toUserId = this.$route.query.toUserId;
      if (toUserId) {
        const target = this.userList.find(u => u.chatUserId == toUserId);
        if (target) {
          this.changeChatUser(target);
        } else {
          this.$request.post('/chatGroup/add', {
            userId: this.user.id,
            chatUserId: toUserId
          }).then(() => {
            this.loadUserList().then(() => {
              const added = this.userList.find(u => u.chatUserId == toUserId);
              if (added) this.changeChatUser(added);
            });
          });
        }
      }
    });

    // 初始化WebSocket连接
    this.initWebSocket();
    
    // 添加页面关闭事件监听
    window.addEventListener('beforeunload', this.closeWebSocket);
    document.addEventListener('click', this.closeEmojiPanel);

    // 移除顶部导航栏的消息提示更新
    this.$bus.$off('updateUnreadCount');
  },
  beforeDestroy() {
    if (this.ws) {
      this.closeWebSocket();
    }
    // 移除页面关闭事件监听
    window.removeEventListener('beforeunload', this.closeWebSocket);
    document.removeEventListener('click', this.closeEmojiPanel);
    // 移除事件监听
    this.$bus.$off('updateUnreadCount');
  },
  methods: {
    loadUserList() {
      return this.$request.get('/chatGroup/selectUserGroup').then(res => {
        if (res.code === '200') {
          this.userList = res.data;
          // 不再触发顶部导航栏的未读消息更新
        }
      });
    },
    changeChatUser(item) {
      this.chatTitle = item.chatUserName || '对方';
      this.active = item.chatUserId;
      this.activeUserAvatar = item.chatUserAvatar;
      this.processedMessageKeys.clear();
      this.$request.put(`/chatInfo/updateRead/${item.chatUserId}`);
      this.loadChatRecord();
      // 清除未读消息数
      if (item.unreadCount) {
        const index = this.userList.findIndex(u => u.chatUserId === item.chatUserId);
        if (index !== -1) {
          this.$set(this.userList[index], 'unreadCount', 0);
        }
      }
    },
    loadChatRecord() {
      this.$request.get(`/chatInfo/selectUserChat/${this.active}`).then(res => {
        if (res.code === '200') {
          // 重置聊天列表
          this.chatList = [];
          
          // 添加历史消息，并记录消息ID
          const messages = res.data || [];
          messages.forEach(msg => {
            this.chatList.push(msg);
          });

          this.$nextTick(() => {
            const box = this.$refs.chatBox;
            if (box) box.scrollTop = box.scrollHeight;
          });
        }
      });
    },
    initWebSocket() {
      if (typeof WebSocket === 'undefined') {
        this.$message.error('您的浏览器不支持WebSocket');
        return;
      }
      
      // 先关闭之前的连接
      this.closeWebSocket();
      
      // 从环境配置或window.location获取WebSocket服务器地址
      const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
      const wsPort = '9090'; // 使用固定的WebSocket端口
      const wsUrl = `${protocol}//${window.location.hostname}:${wsPort}/chatServer/${this.user.id}`;
      
      console.log('正在连接WebSocket:', wsUrl);
      
      try {
        this.ws = new WebSocket(wsUrl);
        
        this.ws.onopen = () => {
          console.log('WebSocket连接成功');
          this.wsConnected = true; // 添加连接状态标记
          this.$message.success('聊天服务已连接');
          // 开始发送心跳
          this.startHeartbeat();
        };
        
        this.ws.onclose = (e) => {
          console.log('WebSocket连接关闭', e);
          this.wsConnected = false;
          // 清除心跳定时器
          if (this.heartbeatTimer) {
            clearInterval(this.heartbeatTimer);
            this.heartbeatTimer = null;
          }
          
          // 如果不是主动关闭的，则尝试重连
          if (!this.manualClosed) {
            console.log('WebSocket连接断开，3秒后尝试重连...');
            setTimeout(() => {
              if (!this.wsConnected && !this.manualClosed) {
                this.initWebSocket();
              }
            }, 3000);
          }
        };
        
        this.ws.onerror = (e) => {
          console.error('WebSocket连接错误:', e);
          this.wsConnected = false;
          this.$message.error('聊天服务连接失败，正在重试...');
        };
        
        this.ws.onmessage = this.onMessage;
        
      } catch (error) {
        console.error('创建WebSocket连接失败:', error);
        this.$message.error('连接聊天服务失败');
        this.wsConnected = false;
      }
    },
    closeWebSocket() {
      this.manualClosed = true; // 标记为主动关闭
      if (this.heartbeatTimer) {
        clearInterval(this.heartbeatTimer);
        this.heartbeatTimer = null;
      }
      if (this.ws) {
        try {
          this.ws.close();
        } catch (e) {
          console.error('关闭WebSocket连接出错:', e);
        }
        this.ws = null;
      }
      this.wsConnected = false;
    },
    startHeartbeat() {
      if (this.heartbeatTimer) {
        clearInterval(this.heartbeatTimer);
      }
      
      // 每30秒发送一次心跳
      this.heartbeatTimer = setInterval(() => {
        if (this.ws && this.ws.readyState === WebSocket.OPEN) {
          try {
            const heartbeat = {
              type: 'heartbeat',
              userId: this.user.id,
              timestamp: new Date().getTime()
            };
            this.ws.send(JSON.stringify(heartbeat));
          } catch (error) {
            console.error('发送心跳消息失败:', error);
            // 如果发送心跳失败，可能连接已断开，尝试重连
            this.wsConnected = false;
            this.closeWebSocket();
            this.manualClosed = false; // 重置手动关闭标记
            this.initWebSocket();
          }
        }
      }, 30000);
    },
    send() {
      if (!this.content.trim()) return;
      
      // 检查WebSocket连接状态
      if (!this.ws || this.ws.readyState !== WebSocket.OPEN) {
        console.log('WebSocket未连接，尝试重新连接...');
        this.$message.warning('正在重新连接服务器...');
        this.initWebSocket();
        setTimeout(() => {
          this.send();
        }, 1000);
        return;
      }

      const tempMsg = {
        userId: this.user.id,
        chatUserId: this.active,
        text: this.content,
        contentType: 'text',
        fileType: null,
        fileUrl: null,
        userName: this.user.name,
        userAvatar: this.user.avatar,
        timestamp: new Date().getTime(),
        pending: true
      };

      // 先添加到本地聊天列表
      const msgIndex = this.chatList.length;
      this.$set(this.chatList, msgIndex, tempMsg);

      // 清空输入框并滚动到底部
      this.content = '';
      this.$nextTick(() => {
        const box = this.$refs.chatBox;
        if (box) box.scrollTop = box.scrollHeight;
      });

      // 发送WebSocket消息
      const wsMessage = {
        type: 'chat',
        fromUserId: this.user.id,
        fromUserName: this.user.name,
        fromUserAvatar: this.user.avatar,
        toUserId: this.active,
        content: tempMsg.text,
        contentType: 'text',
        timestamp: tempMsg.timestamp,
        needSave: true
      };

      try {
        this.ws.send(JSON.stringify(wsMessage));
      } catch (error) {
        console.error('发送消息失败:', error);
        this.$set(this.chatList[msgIndex], 'error', true);
        this.$message.error('发送失败，请重试');
      }
    },
    insertEmoji(emoji) {
      this.content += emoji;
      this.showEmoji = false;
    },
    closeEmojiPanel(e) {
      const emojiTool = document.querySelector('.emoji-tool');
      if (emojiTool && !emojiTool.contains(e.target)) {
        this.showEmoji = false;
      }
    },
    handleImageSuccess(response, file) {
      if (response.code === '200') {
        const tempMsg = {
          userId: this.user.id,
          chatUserId: this.active,
          text: response.data,
          contentType: 'image',
          fileType: 'image',
          fileUrl: response.data,
          userName: this.user.name,
          userAvatar: this.user.avatar,
          timestamp: new Date().getTime(),
          pending: true
        };

        // 添加到本地聊天列表
        const msgIndex = this.chatList.length;
        this.$set(this.chatList, msgIndex, tempMsg);

        // 通过WebSocket发送消息
        if (this.ws && this.ws.readyState === WebSocket.OPEN) {
          const wsMessage = {
            type: 'chat',
            fromUserId: this.user.id,
            fromUserName: this.user.name,
            fromUserAvatar: this.user.avatar,
            toUserId: this.active,
            content: response.data,
            contentType: 'image',
            fileType: 'image',
            fileUrl: response.data,
            timestamp: tempMsg.timestamp,
            needSave: true // 标记需要保存到数据库
          };
          
          try {
            this.ws.send(JSON.stringify(wsMessage));
          } catch (error) {
            console.error('发送图片消息失败:', error);
            this.$set(this.chatList[msgIndex], 'error', true);
            this.$message.error('发送失败，请重试');
          }
        } else {
          this.$set(this.chatList[msgIndex], 'error', true);
          this.$message.error('发送失败，WebSocket未连接');
        }
      }
    },
    handleFileSuccess(response, file) {
      if (response.code === '200') {
        const tempMsg = {
          userId: this.user.id,
          chatUserId: this.active,
          text: response.data,
          contentType: 'file',
          fileType: file.type || 'unknown',
          fileUrl: response.data,
          fileName: file.name,
          userName: this.user.name,
          userAvatar: this.user.avatar,
          timestamp: new Date().getTime(),
          pending: true
        };

        // 添加到本地聊天列表
        const msgIndex = this.chatList.length;
        this.$set(this.chatList, msgIndex, tempMsg);

        // 通过WebSocket发送消息
        if (this.ws && this.ws.readyState === WebSocket.OPEN) {
          const wsMessage = {
            type: 'chat',
            fromUserId: this.user.id,
            fromUserName: this.user.name,
            fromUserAvatar: this.user.avatar,
            toUserId: this.active,
            content: response.data,
            contentType: 'file',
            fileType: file.type || 'unknown',
            fileUrl: response.data,
            fileName: file.name,
            timestamp: tempMsg.timestamp,
            needSave: true // 标记需要保存到数据库
          };
          
          try {
            this.ws.send(JSON.stringify(wsMessage));
          } catch (error) {
            console.error('发送文件消息失败:', error);
            this.$set(this.chatList[msgIndex], 'error', true);
            this.$message.error('发送失败，请重试');
          }
        } else {
          this.$set(this.chatList[msgIndex], 'error', true);
          this.$message.error('发送失败，WebSocket未连接');
        }
      }
    },
    previewImage(imageUrl) {
      // 实现图片预览逻辑
    },
    updateUnreadCount(fromUserId) {
      // 只更新聊天列表中的未读消息数
      const userIndex = this.userList.findIndex(u => u.chatUserId === fromUserId);
      if (userIndex !== -1) {
        const currentCount = this.userList[userIndex].unreadCount || 0;
        this.$set(this.userList[userIndex], 'unreadCount', currentCount + 1);
      }
    },
    onMessage(e) {
      try {
        const data = JSON.parse(e.data);
        console.log('收到WebSocket消息:', data);
        
        if (data.type === 'chat') {
          // 检查消息是否有效
          if (!data.fromUserId || !data.toUserId) {
            console.error('无效的消息格式:', data);
            return;
          }

          // 如果是接收到的消息且不是当前聊天对象，更新未读消息数
          if (data.toUserId === this.user.id && data.fromUserId !== this.active) {
            this.updateUnreadCount(data.fromUserId);
          }

          // 生成消息的唯一标识
          const messageKey = `${data.fromUserId}-${data.toUserId}-${data.timestamp}`;
          
          // 检查消息是否已经处理过
          if (this.processedMessageKeys.has(messageKey)) {
            console.log('消息已处理，跳过:', messageKey);
            return;
          }
          
          // 记录消息已处理
          this.processedMessageKeys.add(messageKey);

          // 如果是当前聊天对象的消息
          if ((data.fromUserId === this.active && data.toUserId === this.user.id) || 
              (data.toUserId === this.active && data.fromUserId === this.user.id)) {
            
            // 如果是发送方收到服务器的确认消息
            if (data.messageId && data.fromUserId === this.user.id) {
              // 查找并更新对应的临时消息
              const msgIndex = this.chatList.findIndex(msg => 
                msg.pending && 
                msg.timestamp === data.timestamp && 
                msg.userId === data.fromUserId
              );
              
              if (msgIndex !== -1) {
                this.$set(this.chatList[msgIndex], 'id', data.messageId);
                this.$set(this.chatList[msgIndex], 'pending', false);
                return;
              }
            }

            // 处理接收到的新消息
            const newMsg = {
              id: data.messageId,
              userId: data.fromUserId,
              chatUserId: data.toUserId,
              text: data.content,
              contentType: data.contentType || 'text',
              fileType: data.fileType,
              fileUrl: data.fileUrl,
              fileName: data.fileName,
              userName: data.fromUserName,
              userAvatar: data.fromUserAvatar,
              timestamp: data.timestamp
            };

            // 检查是否已经存在相同的消息
            const existingMsgIndex = this.chatList.findIndex(msg => 
              msg.timestamp === data.timestamp && 
              msg.userId === data.fromUserId &&
              msg.text === data.content
            );

            if (existingMsgIndex === -1) {
              // 只有不存在相同消息时才添加
              this.$set(this.chatList, this.chatList.length, newMsg);
              
              // 如果是收到的消息，标记为已读并发送确认
              if (data.toUserId === this.user.id) {
                this.$request.put(`/chatInfo/updateRead/${data.fromUserId}`);
                // 发送消息确认
                if (this.ws && this.ws.readyState === WebSocket.OPEN) {
                  const ack = {
                    type: 'ack',
                    messageId: data.messageId,
                    status: 'received',
                    timestamp: new Date().getTime()
                  };
                  this.ws.send(JSON.stringify(ack));
                }
              }
              
              this.$nextTick(() => {
                const box = this.$refs.chatBox;
                if (box) box.scrollTop = box.scrollHeight;
              });
            } else {
              console.log('跳过重复消息:', data);
            }
          }
          // 刷新聊天列表
          this.loadUserList();
        } else if (data.type === 'ack') {
          // 处理消息确认
          console.log('收到消息确认:', data);
          if (data.status === 'error') {
            // 查找并标记发送失败的消息
            const msgIndex = this.chatList.findIndex(msg => 
              msg.pending && 
              msg.timestamp === data.timestamp
            );
            if (msgIndex !== -1) {
              this.$set(this.chatList[msgIndex], 'error', true);
              this.$message.error(data.error || '消息发送失败');
            }
          } else if (data.status === 'success') {
            console.log('消息发送成功:', data.messageId);
          }
        }
      } catch (error) {
        console.error('解析WebSocket消息失败:', error, e.data);
      }
    }
  }
}
</script>

<style scoped>
.chat-page {
  display: flex;
  height: 85vh;
  background: #f5f5f5;
  margin: 20px;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.chat-user-list {
  width: 280px;
  background: #f5f5f5;
  border-right: 1px solid #e6e6e6;
  display: flex;
  flex-direction: column;
}

.chat-user {
  display: flex;
  align-items: center;
  padding: 12px;
  cursor: pointer;
  position: relative;
}

.chat-user:hover,
.chat-user.active {
  background-color: #e6e6e6;
}

.user-avatar {
  position: relative;
  margin-right: 12px;
}

.user-avatar img {
  width: 40px;
  height: 40px;
  border-radius: 4px;
}

.user-info {
  flex: 1;
  min-width: 0;
  position: relative; /* 添加相对定位 */
}

.user-name {
  font-size: 14px;
  color: #333;
  margin-bottom: 4px;
  padding-right: 30px; /* 为未读消息数留出空间 */
}

.last-msg {
  font-size: 12px;
  color: #999;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* 新增：聊天列表中的未读消息提示 */
.chat-unread-count {
  position: absolute;
  right: 5px;
  top: 50%;
  transform: translateY(-50%);
  background: #f56c6c;
  color: white;
  border-radius: 10px;
  min-width: 18px;
  height: 18px;
  line-height: 18px;
  text-align: center;
  font-size: 12px;
  padding: 0 6px;
}

.chat-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  background: #f5f5f5;
}

.chat-header {
  height: 60px;
  background: #f5f5f5;
  border-bottom: 1px solid #e6e6e6;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
}

.chat-title {
  display: flex;
  align-items: center;
}

.title-avatar {
  width: 40px;
  height: 40px;
  border-radius: 4px;
  margin-right: 10px;
}

.chat-actions {
  color: #666;
  font-size: 20px;
  cursor: pointer;
}

.chat-box {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  background: #f5f5f5;
}

.msg-box {
  display: flex;
  margin-bottom: 20px;
}

.msg-box.left {
  flex-direction: row;
}

.msg-box.right {
  flex-direction: row-reverse;
}

.avatar {
  width: 40px;
  height: 40px;
  border-radius: 4px;
  margin: 0 10px;
}

.msg-content {
  max-width: 60%;
}

.msg-text {
  background: white;
  padding: 10px 15px;
  border-radius: 4px;
  font-size: 16px;
  line-height: 1.5;
  word-wrap: break-word;
  word-break: break-all;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
  white-space: pre-wrap;
}

.msg-box.right .msg-text {
  background: #95ec69;
}

.chat-input {
  background: #f5f5f5;
  border-top: 1px solid #e6e6e6;
  padding: 10px;
}

.input-tools {
  display: flex;
  padding: 5px 0;
}

.input-tools i {
  font-size: 20px;
  color: #666;
  margin-right: 15px;
  cursor: pointer;
}

.input-box {
  margin: 5px 0;
  position: relative;
  display: flex;
  align-items: flex-start;
  gap: 10px;
}

.input-box .el-textarea {
  flex: 1;
}

.send-btn {
  height: 65px;
  padding: 0 20px;
}

.input-actions {
  display: none;
}

.chat-welcome {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f5f5;
  border-left: 1px solid #e6e6e6;
}

.welcome-content {
  text-align: center;
  color: #909399;
}

.welcome-content i {
  font-size: 80px;
  margin-bottom: 20px;
}

.welcome-content p {
  font-size: 16px;
  margin: 0;
}

.emoji-tool {
  position: relative;
  display: inline-block;
}

.emoji-panel {
  position: absolute;
  bottom: 40px;
  left: 0;
  width: 360px;
  height: 200px;
  background: white;
  border: 1px solid #e6e6e6;
  border-radius: 4px;
  box-shadow: 0 2px 12px 0 rgba(0,0,0,.1);
  padding: 10px;
  z-index: 1000;
}

.emoji-list {
  display: grid;
  grid-template-columns: repeat(10, 1fr);
  gap: 5px;
  height: 100%;
  overflow-y: auto;
}

.emoji-item {
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  cursor: pointer;
  padding: 5px;
  transition: all 0.3s;
}

.emoji-item:hover {
  background: #f5f5f5;
  border-radius: 4px;
}

/* 自定义滚动条样式 */
.emoji-list::-webkit-scrollbar {
  width: 6px;
}

.emoji-list::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 3px;
}

.emoji-list::-webkit-scrollbar-track {
  background: #f1f1f1;
}

/* 确保表情在消息中正确显示 */
.msg-text img.emoji {
  width: 20px;
  height: 20px;
  vertical-align: middle;
  margin: 0 1px;
}

.msg-image {
  max-width: 200px;
  cursor: pointer;
}

.msg-image .el-image {
  width: 100%;
  max-width: 200px;
  border-radius: 4px;
}

.msg-file {
  display: flex;
  align-items: center;
  background: white;
  padding: 10px 15px;
  border-radius: 4px;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

.msg-file i {
  font-size: 24px;
  color: #409EFF;
  margin-right: 10px;
}

.file-name {
  flex: 1;
  font-size: 14px;
  color: #333;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  margin-right: 10px;
}

.download-btn {
  color: #409EFF;
  text-decoration: none;
}

.msg-box.right .download-btn {
  color: #2b5f0d;
}
</style>
