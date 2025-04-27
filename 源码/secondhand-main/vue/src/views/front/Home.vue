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
        </div>
      </div>
    </div>

    <!-- 主要内容区域 -->
    <div class="main-content">
      <!-- 分类和筛选 -->
      <div class="filter-bar">
        <div class="category-tabs">
          <span 
            class="category-item" 
            :class="{ active: category === '全部' }"
            @click="category = '全部'; loadGoods(1)"
          >全部</span>
          <span 
            v-for="item in categoryList" 
            :key="item.id"
            class="category-item"
            :class="{ active: category === item.name }"
            @click="category = item.name; loadGoods(1)"
          >{{ item.name }}</span>
        </div>
        <div class="sort-options">
          <span 
            class="sort-item" 
            :class="{ active: sort === '最新' }"
            @click="sort = '最新'; loadGoods(1)"
          >
            <i class="el-icon-time"></i> 最新发布
          </span>
          <span 
            class="sort-item"
            :class="{ active: sort === '最热' }"
            @click="sort = '最热'; loadGoods(1)"
          >
            <i class="el-icon-star-on"></i> 最受欢迎
          </span>
        </div>
      </div>

      <!-- 商品列表 -->
      <div class="goods-list">
        <el-row :gutter="20">
          <el-col :span="6" v-for="item in goodsList" :key="item.id">
            <div class="goods-card" @click="$router.push('/front/goodsDetail?id=' + item.id)">
              <div class="goods-image">
                <img :src="item.img" :alt="item.name">
                <div class="goods-tag" v-if="item.isNew">全新</div>
              </div>
              <div class="goods-info">
                <h3 class="goods-name">{{ item.name }}</h3>
                <div class="goods-price">
                  <span class="price-symbol">¥</span>
                  <span class="price-value">{{ item.price }}</span>
                </div>
                <div class="goods-meta">
                  <div class="seller-info">
                    <img :src="item.userAvatar || '@/assets/imgs/default-avatar.png'" class="seller-avatar">
                    <span class="seller-name">{{ item.userName || '匿名用户' }}</span>
                  </div>
                  <div class="goods-stats">
                    <span class="stat-item">
                      <i class="el-icon-view"></i> {{ item.readCount }}
                    </span>
                    <span class="stat-item">
                      <i class="el-icon-star-off"></i> {{ item.likesCount }}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </el-col>
        </el-row>
      </div>

      <!-- 分页器 -->
      <div class="pagination-wrapper">
        <el-pagination
          background
          @current-change="handleCurrentChange"
          :current-page="pageNum"
          :page-size="pageSize"
          layout="prev, pager, next, total"
          :total="total">
        </el-pagination>
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
      name: ''
    }
  },
  mounted() {
    this.loadCategory()
    this.loadGoods(1)
  },
  // methods：本页面所有的点击事件或者其他函数定义区
  methods: {
    loadCategory() {
      this.$request.get('/category/selectAll').then(res => {
        this.categoryList = res.data || []
      })
    },
    loadGoods(pageNum) {  // 分页查询
      if (pageNum) this.pageNum = pageNum
      this.$request.get('/goods/selectFrontPage', {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          category: this.category === '全部' ? null : this.category,
          sort: this.sort
        }
      }).then(res => {
        if (res.code === '200') {
          this.goodsList = res.data?.list
          this.total = res.data?.total
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    handleCurrentChange(pageNum) {
      this.loadGoods(pageNum)
    },
  }
}
</script>

<style scoped>
.home-container {
  min-height: 100vh;
  background-color: #f5f7fa;
}

.banner {
  background: linear-gradient(135deg, #40a9ff 0%, #1d39c4 100%);
  padding: 60px 0;
  color: white;
  position: relative;
  overflow: hidden;
}

.banner::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(45deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 100%);
  pointer-events: none;
}

.banner-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  position: relative;
}

.banner-left {
  flex: 1;
  max-width: 600px;
}

.banner-title {
  font-size: 42px;
  font-weight: bold;
  margin: 0;
  letter-spacing: 1px;
  text-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.banner-subtitle {
  font-size: 18px;
  margin: 15px 0 30px;
  opacity: 0.9;
}

.search-wrapper {
  width: 100%;
  position: relative;
}

.search-input {
  width: 100%;
}

.search-input :deep(.el-input__inner) {
  height: 50px;
  font-size: 16px;
  border: none;
  padding-left: 20px;
  border-radius: 25px 0 0 25px;
  box-shadow: 0 2px 6px rgba(0,0,0,0.1);
}

.search-input :deep(.el-input-group__append) {
  background: #1890ff;
  border: none;
  padding: 0 30px;
  border-radius: 0 25px 25px 0;
  transition: all 0.3s;
}

.search-input :deep(.el-input-group__append:hover) {
  background: #40a9ff;
}

.search-btn {
  background: transparent;
  border: none;
  color: white;
  font-size: 15px;
  font-weight: 500;
}

.hot-keywords {
  margin-top: 15px;
  font-size: 14px;
  opacity: 0.8;
}

.keyword {
  color: white;
  margin-left: 15px;
  text-decoration: none;
  transition: all 0.3s;
  opacity: 0.8;
  position: relative;
}

.keyword:hover {
  opacity: 1;
}

.keyword::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 100%;
  height: 1px;
  background: white;
  transform: scaleX(0);
  transition: transform 0.3s;
}

.keyword:hover::after {
  transform: scaleX(1);
}

.banner-right {
  display: flex;
  gap: 20px;
  margin-left: 60px;
}

.action-card {
  background: rgba(255, 255, 255, 0.1);
  padding: 20px;
  border-radius: 12px;
  text-align: center;
  transition: all 0.3s;
  backdrop-filter: blur(10px);
}

.action-card:hover {
  transform: translateY(-5px);
  background: rgba(255, 255, 255, 0.15);
}

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
}

.action-btn i {
  font-size: 16px;
}

.action-desc {
  margin: 12px 0 0;
  font-size: 14px;
  opacity: 0.8;
}

.main-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 30px 20px;
}

.filter-bar {
  background: white;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 30px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.category-tabs {
  display: flex;
  gap: 20px;
  margin-bottom: 15px;
  border-bottom: 1px solid #f0f0f0;
  padding-bottom: 15px;
}

.category-item {
  cursor: pointer;
  padding: 6px 16px;
  border-radius: 16px;
  transition: all 0.3s;
  font-size: 15px;
  color: #666;
}

.category-item:hover {
  color: #1890ff;
  background: #f0f7ff;
}

.category-item.active {
  color: white;
  background: #1890ff;
}

.sort-options {
  display: flex;
  gap: 20px;
}

.sort-item {
  cursor: pointer;
  color: #666;
  transition: all 0.3s;
  display: flex;
  align-items: center;
  gap: 5px;
}

.sort-item:hover {
  color: #1890ff;
}

.sort-item.active {
  color: #1890ff;
  font-weight: 500;
}

.goods-list {
  margin-bottom: 30px;
}

.goods-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  transition: all 0.3s;
  margin-bottom: 20px;
  cursor: pointer;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.goods-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
}

.goods-image {
  position: relative;
  height: 200px;
  overflow: hidden;
}

.goods-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: all 0.3s;
}

.goods-tag {
  position: absolute;
  top: 10px;
  left: 10px;
  background: #1890ff;
  color: white;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.goods-info {
  padding: 15px;
}

.goods-name {
  font-size: 16px;
  color: #333;
  margin: 0 0 10px;
  height: 44px;
  line-height: 22px;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
}

.goods-price {
  margin-bottom: 15px;
}

.price-symbol {
  color: #1890ff;
  font-size: 14px;
  margin-right: 2px;
}

.price-value {
  color: #1890ff;
  font-size: 24px;
  font-weight: bold;
}

.goods-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 15px;
  border-top: 1px solid #f0f0f0;
}

.seller-info {
  display: flex;
  align-items: center;
  gap: 8px;
}

.seller-avatar {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  object-fit: cover;
}

.seller-name {
  color: #666;
  font-size: 13px;
}

.goods-stats {
  display: flex;
  gap: 15px;
}

.stat-item {
  color: #999;
  font-size: 13px;
  display: flex;
  align-items: center;
  gap: 4px;
}

.pagination-wrapper {
  text-align: center;
  margin-top: 40px;
}

:deep(.el-pagination.is-background .el-pager li:not(.disabled).active) {
  background-color: #1890ff;
}

:deep(.el-pagination.is-background .el-pager li:not(.disabled):hover) {
  color: #1890ff;
}
</style>