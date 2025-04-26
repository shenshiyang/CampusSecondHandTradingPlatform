<template>
  <div class="goods-detail-container">
    <div class="goods-main-content">
      <!-- 商品图片 -->
      <div class="goods-image-container">
        <img :src="goods.img" :alt="goods.name" class="goods-image">
      </div>

      <!-- 商品信息 -->
      <div class="goods-info-container">
        <div class="goods-info">
          <h1 class="goods-title">{{ goods.name }}</h1>

          <div class="meta-info">
            <span class="meta-item"><i class="el-icon-view"></i> {{ goods.readCount }} 浏览</span>
            <span class="meta-item"><i class="el-icon-thumb"></i> {{ goods.likesCount }} 点赞</span>
            <span class="meta-item"><i class="el-icon-star-off"></i> {{ goods.collectCount }} 收藏</span>
          </div>

          <div class="price-section">
            <div class="goods-price">
              <span class="price-symbol">¥</span>
              <span class="price-value">{{ goods.price }}</span>
            </div>
          </div>

          <div class="info-cards">
            <div class="info-card">
              <div class="info-card-label">
                <i class="el-icon-location"></i>
                发货地
              </div>
              <div class="info-card-value">{{ goods.address }}</div>
            </div>

            <div class="info-card">
              <div class="info-card-label">
                <i class="el-icon-time"></i>
                发布时间
              </div>
              <div class="info-card-value">{{ goods.date }}</div>
            </div>
          </div>

          <div class="seller-info">
            <div class="seller-profile">
              <img :src="goods.userAvatar" class="seller-avatar" />
              <div class="seller-detail">
                <span class="seller-name">{{ goods.userName }}</span>
              </div>
              <el-button type="text" @click="chat(goods.userId)" class="chat-link">
                <i class="el-icon-chat-dot-round"></i> 联系卖家
              </el-button>
            </div>
          </div>

          <!-- 操作按钮组 -->
          <div class="action-buttons">
            <div class="action-row">
              <el-button 
                :class="['action-btn', 'like-btn', {'is-active': goods.userLikes}]"
                @click="addLikes"
              >
                <i :class="goods.userLikes ? 'el-icon-success' : 'el-icon-thumb'"></i>
                {{ goods.userLikes ? '已点赞' : '点赞' }}
              </el-button>

              <el-button 
                :class="['action-btn', 'collect-btn', {'is-active': goods.userCollect}]"
                @click="addCollect"
              >
                <i :class="goods.userCollect ? 'el-icon-star-on' : 'el-icon-star-off'"></i>
                {{ goods.userCollect ? '已收藏' : '收藏' }}
              </el-button>
            </div>

            <div class="action-row">
              <el-button 
                class="action-btn chat-btn"
                @click="chat(goods.userId)"
              >
                <i class="el-icon-chat-dot-round"></i> 联系卖家
              </el-button>

              <el-button 
                type="primary"
                class="action-btn buy-btn"
                @click="handleBuy"
              >
                立即购买
              </el-button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 商品详情/评论区域 -->
    <div class="goods-tabs">
      <div class="tab-header">
        <div 
          class="tab-item" 
          :class="{ active: current === '商品详情' }"
          @click="changeItem('商品详情')"
        >
          商品详情
        </div>
        <div 
          class="tab-item"
          :class="{ active: current === '商品评论' }"
          @click="changeItem('商品评论')"
        >
          商品评论
        </div>
      </div>

      <div class="tab-content">
        <div v-if="current === '商品详情'" class="detail-content" v-html="goods.content"></div>
        <div v-if="current === '商品评论'" class="comment-content">
          <Comment :fid="id" module="goods" />
        </div>
      </div>
    </div>

    <!-- 下单弹窗 -->
    <el-dialog 
      title="选择收货地址" 
      :visible.sync="fromVisible" 
      width="500px"
      :close-on-click-modal="false"
      destroy-on-close
      custom-class="address-dialog"
    >
      <div class="address-list">
        <el-radio-group v-model="form.addressId">
          <div v-for="item in addressList" :key="item.id" class="address-item">
            <el-radio :label="item.id">
              <div class="address-info">
                <div class="address-name">{{ item.name }}</div>
                <div class="address-phone">{{ item.phone }}</div>
                <div class="address-detail">{{ item.address }}</div>
              </div>
            </el-radio>
          </div>
        </el-radio-group>
        <div v-if="addressList.length === 0" class="no-address">
          <i class="el-icon-location-information"></i>
          <p>还没有收货地址</p>
          <el-button type="primary" size="small" @click="$router.push('/front/address')">
            去添加地址
          </el-button>
        </div>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="fromVisible = false">取 消</el-button>
        <el-button type="primary" @click="addOrder">确认下单</el-button>
      </div>
    </el-dialog>
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
      this.$router.push({
        path: '/front/chat',
        query: { toUserId: userId }
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
.goods-detail-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 30px 20px;
}

.goods-main-content {
  display: grid;
  grid-template-columns: 450px 1fr;
  gap: 40px;
  margin-bottom: 40px;
  background: #fff;
  border-radius: 12px;
  padding: 30px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}

.goods-image-container {
  width: 450px;
  height: 450px;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.goods-image {
  width: 100%;
  height: 100%;
  object-fit: contain;
  background: #f8f8f8;
  transition: transform 0.3s;
}

.goods-image:hover {
  transform: scale(1.02);
}

.goods-info-container {
  display: flex;
  flex-direction: column;
}

.goods-info {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.goods-title {
  font-size: 24px;
  font-weight: 600;
  color: #333;
  margin: 0 0 16px;
  line-height: 1.4;
}

.meta-info {
  display: flex;
  gap: 24px;
  margin-bottom: 20px;
  padding: 12px 0;
  border-bottom: 1px solid #f0f0f0;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #666;
  font-size: 14px;
}

.meta-item i {
  color: #999;
  font-size: 16px;
}

.price-section {
  background: #fff9f9;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
}

.goods-price {
  display: flex;
  align-items: baseline;
}

.price-symbol {
  color: #ff4d4f;
  font-size: 18px;
  margin-right: 4px;
}

.price-value {
  color: #ff4d4f;
  font-size: 32px;
  font-weight: bold;
}

.info-cards {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
  margin: 20px 0;
}

.info-card {
  background: #f8f9fa;
  border-radius: 8px;
  padding: 16px;
  transition: all 0.3s;
}

.info-card:hover {
  background: #f0f2f5;
  transform: translateY(-2px);
}

.info-card-label {
  color: #666;
  font-size: 14px;
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  gap: 6px;
}

.info-card-label i {
  font-size: 16px;
  color: #1890ff;
}

.info-card-value {
  color: #333;
  font-size: 15px;
  font-weight: 500;
}

.seller-info {
  background: #f8f8f8;
  padding: 16px;
  border-radius: 8px;
  margin: 20px 0;
}

.seller-profile {
  display: flex;
  align-items: center;
  gap: 16px;
}

.seller-avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid #fff;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.seller-detail {
  flex: 1;
}

.seller-name {
  color: #333;
  font-weight: 500;
  font-size: 16px;
}

.chat-link {
  color: #1890ff;
  font-size: 14px;
  padding: 0;
}

.chat-link:hover {
  color: #40a9ff;
}

.action-buttons {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 12px;
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid #f0f0f0;
}

.action-row {
  display: flex;
  gap: 12px;
}

.action-btn {
  flex: 1;
  height: 40px;
  border-radius: 20px;
  font-size: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  transition: all 0.3s;
}

.action-btn i {
  font-size: 16px;
}

.like-btn {
  background: #fff2e8;
  border-color: #ffbb96;
  color: #fa541c;
}

.like-btn:hover, .like-btn.is-active {
  background: #fa541c;
  border-color: #fa541c;
  color: #fff;
}

.collect-btn {
  background: #fff7e6;
  border-color: #ffd591;
  color: #fa8c16;
}

.collect-btn:hover, .collect-btn.is-active {
  background: #fa8c16;
  border-color: #fa8c16;
  color: #fff;
}

.chat-btn {
  background: #e6f7ff;
  border-color: #91d5ff;
  color: #1890ff;
}

.chat-btn:hover {
  background: #1890ff;
  border-color: #1890ff;
  color: #fff;
}

.buy-btn {
  background: #ff4d4f;
  border-color: #ff4d4f;
  color: #fff;
  font-size: 15px;
  font-weight: 500;
}

.buy-btn:hover {
  background: #ff7875;
  border-color: #ff7875;
}

.goods-tabs {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  overflow: hidden;
}

.tab-header {
  display: flex;
  background: #fafafa;
  border-bottom: 1px solid #f0f0f0;
}

.tab-item {
  padding: 16px 30px;
  font-size: 15px;
  color: #666;
  cursor: pointer;
  transition: all 0.3s;
  position: relative;
}

.tab-item:hover {
  color: #1890ff;
}

.tab-item.active {
  color: #1890ff;
  font-weight: 500;
}

.tab-item.active::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 2px;
  background: #1890ff;
}

.tab-content {
  min-height: 200px;
  padding: 24px;
}

.detail-content {
  color: #666;
  line-height: 1.8;
}

/* 地址选择弹窗样式 */
.address-dialog {
  border-radius: 12px;
}

.address-list {
  max-height: 400px;
  overflow-y: auto;
}

.address-item {
  padding: 16px;
  border-bottom: 1px solid #f0f0f0;
}

.address-item:last-child {
  border-bottom: none;
}

.address-info {
  margin-left: 24px;
  color: #666;
}

.address-name {
  font-size: 15px;
  font-weight: 500;
  color: #333;
  margin-bottom: 4px;
}

.address-phone {
  font-size: 14px;
  margin-bottom: 4px;
}

.address-detail {
  font-size: 14px;
  color: #999;
}

.no-address {
  text-align: center;
  padding: 40px 0;
  color: #999;
}

.no-address i {
  font-size: 48px;
  margin-bottom: 16px;
}

.no-address p {
  margin-bottom: 16px;
}
</style>
