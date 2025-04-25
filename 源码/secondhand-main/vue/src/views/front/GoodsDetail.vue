<template>
  <div style="margin: 0 auto; padding: 10px 0; width: 50%">
    <div style="display: flex; grid-gap: 20px; margin-bottom: 40px">
      <!-- 商品图片 -->
      <img :src="goods.img" alt="" style="width: 50%; height: 400px; display: block; object-fit: cover; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1)">

      <!-- 商品信息 -->
      <div style="flex: 1; width: 0">
        <div class="goods-info">
          <div class="goods-title">{{ goods.name }}</div>

          <div class="meta-info">
            <span><i class="el-icon-view"></i> 浏览 {{ goods.readCount }}</span>
            <span><i class="el-icon-thumb"></i> 点赞 {{ goods.likesCount }}</span>
            <span><i class="el-icon-star-off"></i> 收藏 {{ goods.collectCount }}</span>
          </div>

          <div class="goods-price">￥{{ goods.price }}</div>

          <div class="detail-line"><span>发货地：</span>{{ goods.address }}</div>

          <div class="detail-line seller-line">
            <span>卖家：</span>
            <img :src="goods.userAvatar" class="avatar" />
            <span>{{ goods.userName }}</span>
            <i @click="chat(goods.userId)" class="el-icon-chat-dot-round chat-icon"></i>
          </div>

          <div class="detail-line"><span>发布日期：</span>{{ goods.date }}</div>
        </div>

        <!-- 按钮一行排布 -->
        <div class="button-group">
          <el-button v-if="!goods.userLikes" @click="addLikes" class="like-button">👍 点赞</el-button>
          <el-button v-if="goods.userLikes" @click="addLikes" class="like-button liked">✅ 已点赞</el-button>

          <el-button v-if="!goods.userCollect" @click="addCollect" class="collect-button">❤️ 收藏</el-button>
          <el-button v-if="goods.userCollect" @click="addCollect" class="collect-button collected">💔 已收藏</el-button>

          <el-button class="chat-button" @click="chat(goods.userId)">💬 联系卖家</el-button>
          <el-button class="buy-button" @click="handleBuy">立即购买</el-button>
        </div>
      </div>
    </div>

    <!-- 商品详情/评论切换 -->
    <div>
      <div style="display: flex; border-bottom: 1px solid orangered; margin-bottom: 10px">
        <div style="padding: 10px 20px; cursor: pointer" :class="{ 'active' : current === '商品详情' }" @click="changeItem('商品详情')">商品详情</div>
        <div style="padding: 10px 20px; cursor: pointer" :class="{ 'active' : current === '商品评论' }" @click="changeItem('商品评论')">商品评论</div>
      </div>

      <div v-if="current === '商品详情'">
        <div v-html="goods.content"></div>
      </div>

      <div v-if="current === '商品评论'" class="card">
        <Comment :fid="id" module="goods" />
      </div>

      <!-- 下单弹窗 -->
      <el-dialog title="选择收货地址" :visible.sync="fromVisible" width="30%" :close-on-click-modal="false" destroy-on-close>
        <div style="padding: 0 20px">
          <el-radio-group v-model="form.addressId">
            <el-radio v-for="item in addressList" :key="item.id" :label="item.id" style="margin-bottom: 10px">
              {{ item.name + ' ' + item.address + ' ' + item.phone }}
            </el-radio>
          </el-radio-group>
          <a v-if="addressList.length === 0" href="/front/address" target="_blank">还没有收货地址？去创建</a>
        </div>
        <div slot="footer" class="dialog-footer">
          <el-button @click="fromVisible = false">取 消</el-button>
          <el-button type="primary" @click="addOrder">确 定</el-button>
        </div>
      </el-dialog>
    </div>
  </div>
</template>

<script>
import Comment from "@/components/Comment";
export default {
  name: "GoodsDetail",
  components: { Comment },
  data() {
    return {
      id: this.$route.query.id,
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      goods: {},
      current: '商品详情',
      form: {},
      fromVisible: false,
      addressList: []
    };
  },
  created() {
    this.$request.put('/goods/updateReadCount/' + this.id).then(() => {
      this.load();
    });
    this.loadAddress();
  },
  methods: {
    chat(userId) {
      this.$request.post('/chatGroup/add', { chatUserId: userId, userId: this.user.id }).then(() => {
        this.$router.push('/front/chat');
      });
    },
    handleBuy() {
      this.form = {};
      this.fromVisible = true;
    },
    addOrder() {
      if (!this.form.addressId) {
        this.$message.warning('请选择收货地址');
        return;
      }
      this.form.goodsId = this.id;
      this.$request.post('/orders/add', this.form).then(res => {
        if (res.code === '200') {
          this.$message.success('下单成功');
          this.$router.push('/front/orders');
        } else {
          this.$message.error(res.msg);
        }
      });
    },
    loadAddress() {
      this.$request.get('/address/selectAll').then(res => {
        this.addressList = res.data || [];
      });
    },
    addLikes() {
      const isLiking = !this.goods.userLikes;
      const messageText = isLiking ? '点赞成功' : '取消点赞成功';
      this.$request.post('/likes/add', {
        userId: this.user.id,
        fid: this.goods.id,
        module: 'goods'
      }).then(res => {
        if (res.code === '200') {
          this.$message.success(messageText);
          this.load();
        } else {
          this.$message.error(res.msg);
        }
      });
    },
    addCollect() {
      const isCollecting = !this.goods.userCollect;
      const messageText = isCollecting ? '收藏成功' : '取消收藏成功';
      this.$request.post('/collect/add', {
        userId: this.user.id,
        fid: this.goods.id,
        module: 'goods',
        goodsName: this.goods.name,
        goodsImg: this.goods.img
      }).then(res => {
        if (res.code === '200') {
          this.$message.success(messageText);
          this.load();
        } else {
          this.$message.error(res.msg);
        }
      });
    },
    changeItem(current) {
      this.current = current;
    },
    load() {
      this.$request.get('/goods/selectById/' + this.id).then(res => {
        this.goods = res.data || {};
      });
    }
  }
};
</script>

<style scoped>
.active {
  background-color: orangered;
  color: #eee;
}

/* 右侧信息区域样式 */
.goods-info {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.goods-title {
  font-size: 28px;
  font-weight: 600;
  color: #333;
  margin-bottom: 5px;
}
.meta-info {
  display: flex;
  gap: 20px;
  font-size: 14px;
  color: #888;
  align-items: center;
}
.meta-info i {
  margin-right: 4px;
  color: #999;
}
.goods-price {
  font-size: 26px;
  color: #ff3c3c;
  font-weight: bold;
  margin: 10px 0;
}
.detail-line {
  font-size: 15px;
  color: #444;
}
.detail-line span {
  font-weight: 500;
  color: #888;
  margin-right: 4px;
}
.seller-line {
  display: flex;
  align-items: center;
}
.avatar {
  width: 26px;
  height: 26px;
  border-radius: 50%;
  margin: 0 6px;
  object-fit: cover;
  border: 1px solid #eee;
}
.chat-icon {
  font-size: 16px;
  margin-left: 6px;
  color: #409EFF;
  cursor: pointer;
  transition: all 0.2s;
}
.chat-icon:hover {
  transform: scale(1.2);
}

/* 按钮组样式 */
.button-group {
  display: flex;
  flex-wrap: nowrap;
  gap: 12px;
  align-items: center;
  margin-top: 30px;
}
.el-button {
  min-width: 100px;
  height: 40px;
  font-weight: bold;
  transition: all 0.3s ease;
  white-space: nowrap;
}
.like-button {
  background-color: #ff7f50;
  color: #fff;
  border: none;
}
.like-button:hover {
  background-color: #ff4500;
  transform: scale(1.05);
}
.liked {
  background-color: #aaa !important;
  color: #fff;
}
.collect-button {
  background-color: #f6c344;
  color: #fff;
  border: none;
}
.collect-button:hover {
  background-color: #e8a600;
  transform: scale(1.05);
}
.collected {
  background-color: #888 !important;
  color: #fff;
}
.chat-button {
  border: 1px solid #409EFF;
  color: #409EFF;
  background-color: #fff;
}
.chat-button:hover {
  background-color: #409EFF;
  color: #fff;
  transform: scale(1.05);
}
.buy-button {
  background-color: #ff0055;
  color: #fff;
  border: none;
}
.buy-button:hover {
  background-color: #e6004c;
  transform: scale(1.05);
}
</style>
