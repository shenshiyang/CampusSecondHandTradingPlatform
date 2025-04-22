<template>
  <div class="chat-page">
    <div class="chat-user-list">
      <div
        v-for="item in userList"
        :key="item.chatUserId"
        :class="['chat-user', item.chatUserId === active ? 'active' : '']"
        @click="changeChatUser(item)">
        <img :src="item.chatUserAvatar" alt="">
        <span>{{ item.chatUserName }}</span>
      </div>
    </div>

    <div class="chat-main">
      <div class="chat-title">{{ chatTitle }}</div>

      <div class="chat-box" ref="chatBox">
        <div
          v-for="(item, index) in chatList"
          :key="index"
          :class="['msg-box', item.userId === user.id ? 'right' : 'left']">
          <img
            class="avatar"
            :src="item.userId === user.id ? user.avatar : activeUserAvatar"
            alt="头像">
          <div class="msg-content">{{ item.text }}</div>
        </div>
      </div>

      <div class="chat-input">
        <el-input v-model="content" placeholder="请输入聊天内容" @keyup.enter.native="send" />
        <el-button type="primary" @click="send">发送</el-button>
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
      activeUserAvatar: ''
    }
  },
  mounted() {
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
  },
  methods: {
    loadUserList() {
      return this.$request.get('/chatGroup/selectUserGroup').then(res => {
        if (res.code === '200') {
          this.userList = res.data;
        }
      });
    },
    changeChatUser(item) {
      this.chatTitle = item.chatUserName || '对方';
      this.active = item.chatUserId;
      this.activeUserAvatar = item.chatUserAvatar;
      this.loadChatRecord();
    },
    loadChatRecord() {
      this.$request.get(`/chatInfo/selectUserChat/${this.active}`).then(res => {
        if (res.code === '200') {
          this.chatList = res.data;
          this.$nextTick(() => {
            const box = this.$refs.chatBox;
            if (box) box.scrollTop = box.scrollHeight;
          });
        }
      });
    },
    send() {
      if (!this.content.trim()) return;
      const msg = {
        userId: this.user.id,
        chatUserId: this.active,
        text: this.content
      };
      this.$request.post('/chatInfo/add', msg).then(res => {
        if (res.code === '200') {
          this.chatList.push(msg);
          this.content = '';
          this.$nextTick(() => {
            const box = this.$refs.chatBox;
            if (box) box.scrollTop = box.scrollHeight;
          });
        }
      });
    }
  }
}
</script>

<style scoped>
.chat-page {
  display: flex;
  height: 85vh;
  background: #fff;
  box-shadow: 0 0 6px #ddd;
  margin: 20px;
  border-radius: 8px;
  overflow: hidden;
}
.chat-user-list {
  width: 220px;
  border-right: 1px solid #eee;
  overflow-y: auto;
}
.chat-user {
  display: flex;
  align-items: center;
  padding: 10px;
  cursor: pointer;
}
.chat-user:hover,
.chat-user.active {
  background-color: #f0f7ff;
}
.chat-user img {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  margin-right: 8px;
}
.chat-main {
  flex: 1;
  display: flex;
  flex-direction: column;
}
.chat-title {
  height: 50px;
  line-height: 50px;
  padding-left: 20px;
  border-bottom: 1px solid #eee;
  font-weight: bold;
}
.chat-box {
  flex: 1;
  padding: 15px;
  overflow-y: auto;
}
.chat-input {
  display: flex;
  padding: 10px;
  border-top: 1px solid #eee;
}
.chat-input .el-input {
  flex: 1;
  margin-right: 10px;
}
.msg-box {
  display: flex;
  align-items: flex-end;
  margin-bottom: 10px;
}
.msg-box.left {
  flex-direction: row;
}
.msg-box.right {
  flex-direction: row-reverse;
}
.avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  margin: 0 10px;
}
.msg-content {
  background: #e1f3ff;
  padding: 8px 12px;
  border-radius: 6px;
  max-width: 60%;
  word-wrap: break-word;
  word-break: break-all;
}
.msg-box.right .msg-content {
  background: #a0e86f;
}
</style>
