<template>
  <div class="search-page">
    <!-- 搜索栏 -->
    <el-card class="search-card" shadow="hover">
      <div class="search-header">
        <h2 class="search-title">
          <i class="el-icon-search"></i>
          商品搜索
        </h2>
      </div>
      
      <div class="search-bar">
        <el-input
          v-model.trim="name"
          placeholder="输入商品关键字搜索..."
          prefix-icon="el-icon-search"
          clearable
          class="search-input"
          @keyup.enter.native="loadGoods(1)"
        />
        <el-button 
          type="primary" 
          icon="el-icon-search"
          @click="loadGoods(1)"
        >搜索</el-button>
        <el-button 
          type="warning" 
          icon="el-icon-refresh"
          @click="reset"
        >重置</el-button>
      </div>
    </el-card>

    <!-- 结果列表 -->
    <div class="search-result" v-if="goodsList.length || name">
      <div class="result-header">
        <h3 class="result-title">
          <i class="el-icon-goods"></i>
          搜索结果
          <span class="result-count" v-if="total">（共 {{ total }} 个商品）</span>
        </h3>
      </div>

      <el-row :gutter="20">
        <el-col
          v-for="g in goodsList"
          :key="g.id"
          :xs="12"
          :sm="8"
          :md="6"
          :lg="6"
        >
          <el-card 
            class="goods-item" 
            shadow="hover"
            @click="$router.push(`/front/goodsDetail?id=${g.id}`)"
          >
            <el-image
              :src="g.img"
              class="goods-img"
              fit="cover"
              :preview-src-list="[g.img]"
            >
              <div slot="error" class="image-error">
                <i class="el-icon-picture-outline"></i>
              </div>
            </el-image>

            <div class="goods-info">
              <p class="goods-name line2">{{ g.name }}</p>
              <div class="goods-meta">
                <strong class="price">￥{{ g.price }}</strong>
                <div class="meta-stats">
                  <span class="meta-item">
                    <i class="el-icon-view"></i>
                    {{ g.readCount }}
                  </span>
                  <span class="meta-item">
                    <i class="el-icon-star-off"></i>
                    {{ g.likesCount }}
                  </span>
                </div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>

      <!-- 空状态 -->
      <el-empty
        v-if="!goodsList.length && name"
        description="暂无相关商品"
      >
        <el-button type="primary" @click="reset">重新搜索</el-button>
      </el-empty>

      <!-- 分页器 -->
      <el-pagination
        v-if="total"
        class="pagination"
        background
        layout="total, prev, pager, next"
        :current-page="pageNum"
        :page-size="pageSize"
        :total="total"
        :page-sizes="[8, 16, 24]"
        @current-change="handleCurrentChange"
      />
    </div>

    <!-- 初始状态 -->
    <div v-else class="empty-state">
      <i class="el-icon-search empty-icon"></i>
      <p class="empty-text">输入关键字开始搜索</p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Search',
  data() {
    return {
      goodsList: [],
      pageNum: 1,
      pageSize: 8,
      total: 0,
      name: this.$route.query.name || ''
    }
  },
  created() {
    this.loadGoods()
  },
  watch: {
    '$route.query.name'(val) {
      this.name = val || ''
      this.loadGoods(1)
    }
  },
  methods: {
    async loadGoods(page = this.pageNum) {
      this.pageNum = page
      const { code, data, msg } = await this.$request.get('/goods/selectFrontPage', {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          name: this.name
        }
      })
      if (code === '200') {
        this.goodsList = data.list
        this.total = data.total
      } else {
        this.$message.error(msg)
      }
    },
    handleCurrentChange(page) {
      this.loadGoods(page)
    },
    reset() {
      this.$router.replace('/front/search')
      this.name = ''
      this.loadGoods(1)
    }
  }
}
</script>

<style scoped>
.search-page {
  width: 80%;
  max-width: 1200px;
  margin: 30px auto;
  padding: 0 20px;
}

/* 搜索卡片 */
.search-card {
  border-radius: 8px;
  margin-bottom: 20px;
}

.search-header {
  margin-bottom: 20px;
}

.search-title {
  margin: 0;
  font-size: 20px;
  font-weight: 500;
  color: #303133;
  display: flex;
  align-items: center;
  gap: 8px;
}

.search-title i {
  color: #409EFF;
  font-size: 24px;
}

.search-bar {
  display: flex;
  align-items: center;
  gap: 10px;
}

.search-input {
  width: 400px;
}

/* 结果区域 */
.search-result {
  margin-top: 30px;
}

.result-header {
  margin-bottom: 20px;
}

.result-title {
  margin: 0;
  font-size: 18px;
  font-weight: 500;
  color: #303133;
  display: flex;
  align-items: center;
  gap: 8px;
}

.result-title i {
  color: #409EFF;
  font-size: 20px;
}

.result-count {
  font-size: 14px;
  color: #909399;
  font-weight: normal;
}

/* 商品卡片 */
.goods-item {
  margin-bottom: 20px;
  cursor: pointer;
  border-radius: 8px;
  overflow: hidden;
  transition: all 0.3s ease;
}

.goods-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 6px 16px rgba(0,0,0,0.1);
}

.goods-img {
  width: 100%;
  height: 200px;
  border-radius: 8px 8px 0 0;
  overflow: hidden;
}

.image-error {
  width: 100%;
  height: 100%;
  background: #f5f7fa;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #909399;
  font-size: 30px;
}

.goods-info {
  padding: 12px;
}

.goods-name {
  font-size: 15px;
  color: #303133;
  margin: 0 0 10px;
  line-height: 1.5;
  height: 44px;
}

.goods-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.price {
  color: #ff4d4f;
  font-size: 20px;
}

.meta-stats {
  display: flex;
  gap: 12px;
}

.meta-item {
  color: #909399;
  font-size: 13px;
  display: flex;
  align-items: center;
  gap: 4px;
}

.meta-item i {
  font-size: 14px;
}

/* 分页器 */
.pagination {
  margin-top: 30px;
  text-align: center;
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 60px 0;
  color: #909399;
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 20px;
}

.empty-text {
  font-size: 16px;
  margin: 0;
}

/* 响应式调整 */
@media screen and (max-width: 768px) {
  .search-page {
    width: 95%;
    padding: 0 10px;
  }

  .search-bar {
    flex-direction: column;
  }

  .search-input {
    width: 100%;
  }

  .goods-img {
    height: 160px;
  }

  .price {
    font-size: 18px;
  }
}
</style>
