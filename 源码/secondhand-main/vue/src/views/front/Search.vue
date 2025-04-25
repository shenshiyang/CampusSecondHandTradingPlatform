<template>
  <div class="search-page">
    <!-- ▍搜索栏 -->
    <div class="search-bar">
      <el-input
        v-model.trim="name"
        placeholder="请输入商品关键字"
        clearable
        class="search-input"
        @keyup.enter.native="loadGoods(1)"
      />
      <el-button type="primary" size="mini" @click="loadGoods(1)">搜索</el-button>
      <el-button type="warning" size="mini" @click="reset">重置</el-button>
    </div>

    <!-- ▍结果列表 -->
    <el-card shadow="never">
      <el-row :gutter="15">
        <el-col
          v-for="g in goodsList"
          :key="g.id"
          :span="6"
        >
          <div
            class="goods-item"
            @click="$router.push(`/front/goodsDetail?id=${g.id}`)"
          >
            <el-image
              :src="g.img"
              class="goods-img"
              fit="cover"
              :preview-src-list="[g.img]"
            />
            <p class="goods-name line2">{{ g.name }}</p>
            <div class="goods-meta">
              <strong class="price">￥{{ g.price }}</strong>
              <span>{{ g.readCount }} 浏览</span>
              <span>{{ g.likesCount }} 点赞</span>
            </div>
          </div>
        </el-col>
      </el-row>

      <!-- ▍分页 -->
      <el-pagination
        v-if="total"
        class="pager"
        background
        layout="total, prev, pager, next"
        :current-page="pageNum"
        :page-size="pageSize"
        :total="total"
        :page-sizes="[8, 16, 24]"
        @current-change="handleCurrentChange"
      />
    </el-card>
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
    // 当从其他页面携带 query 返回时自动刷新
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
      this.$router.replace('/front/search') // 清除 query
      this.name = ''
      this.loadGoods(1)
    }
  }
}
</script>

<style scoped>
.search-page {
  width: 70%;
  margin: 20px auto;
}
.search-bar {
  display: flex;
  align-items: center;
  margin-bottom: 12px;
}
.search-input {
  width: 300px;
  margin-right: 10px;
}
.goods-item {
  cursor: pointer;
  margin-bottom: 18px;
  transition: transform 0.25s;
}
.goods-item:hover {
  transform: translateY(-4px);
}
.goods-img {
  width: 100%;
  height: 240px;
  border-radius: 4px;
  margin-bottom: 8px;
}
.goods-name {
  font-size: 15px;
  color: #555;
  margin-bottom: 6px;
}
.goods-meta {
  font-size: 13px;
  color: #666;
  display: flex;
  gap: 14px;
  align-items: baseline;
}
.price {
  color: #ff4d4f;
  font-size: 18px;
}
.pager {
  margin-top: 18px;
  text-align: center;
}
.line2 {
  overflow: hidden;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  line-clamp: 2; 
}
</style>
