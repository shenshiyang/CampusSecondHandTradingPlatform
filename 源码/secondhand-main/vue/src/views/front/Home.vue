<template>
  <div style="min-height: 100vh">
    <!-- Background section -->
    <div class="bg">
      <div class="search-box">
        <div class="title">拾光于前湖，集物在人间</div>
        <div class="search-input">
          <el-input v-model="name" size="medium" prefix-icon="el-icon-search" placeholder="请输入商品名称关键字搜索"></el-input>
          <el-button @click="$router.push({ path: '/front/search', query: { name: name } })" size="medium" type="primary">
            <i class="el-icon-search"></i>
          </el-button>
        </div>
      </div>
    </div>

    <!-- Main content -->
    <div class="content-box">
      <!-- Action buttons -->
      <el-button @click="$router.push('/front/addGoods')" class="action-btn" type="primary" plain>发布商品</el-button>
      <el-button @click="$router.push('/front/userHelp')" class="action-btn" type="primary" plain>发布求助</el-button>

      <!-- Filters and categories -->
      <div class="filters">
        <el-select v-model="category" size="medium" @change="loadGoods(1)">
          <el-option value="全部"></el-option>
          <el-option v-for="item in categoryList" :key="item.id" :value="item.name">{{ item.name }}</el-option>
        </el-select>

        <el-select v-model="sort" size="medium" @change="loadGoods(1)">
          <el-option value="最新">最新</el-option>
          <el-option value="最热">最热</el-option>
        </el-select>
      </div>

      <!-- Product listings -->
      <div>
        <el-row :gutter="15">
          <el-col :span="6" v-for="item in goodsList" :key="item.id">
            <div class="goods-item" @click="$router.push('/front/goodsDetail?id=' + item.id)">
              <img :src="item.img" alt="" class="goods-image">
              <div class="goods-name">{{ item.name }}</div>
              <div class="price-details">
                <strong class="price">￥{{ item.price }}</strong>
                <span class="view-count">{{ item.readCount }}人浏览</span>
                <span class="like-count">{{ item.likesCount }}人点赞</span>
              </div>
            </div>
          </el-col>
        </el-row>

        <!-- Pagination -->
        <el-pagination
          background
          @current-change="handleCurrentChange"
          :current-page="pageNum"
          :page-sizes="[5, 10, 20]"
          :page-size="pageSize"
          layout="total, prev, pager, next"
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
      goodsList: [],
      pageNum: 1,
      pageSize: 12,
      total: 0,
      category: '全部',
      sort: '最新',
      name: ''
    };
  },
  mounted() {
    this.loadCategory();
    this.loadGoods(1);
  },
  methods: {
    loadCategory() {
      this.$request.get('/category/selectAll').then(res => {
        this.categoryList = res.data || [];
      });
    },
    loadGoods(pageNum) {
      if (pageNum) this.pageNum = pageNum;
      this.$request.get('/goods/selectFrontPage', {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          category: this.category === '全部' ? null : this.category,
          sort: this.sort
        }
      }).then(res => {
        if (res.code === '200') {
          this.goodsList = res.data?.list;
          this.total = res.data?.total;
        } else {
          this.$message.error(res.msg);
        }
      });
    },
    handleCurrentChange(pageNum) {
      this.loadGoods(pageNum);
    }
  }
};
</script>

<style scoped>
/* Background Styling */
.bg {
  height: 400px;
  background-image: url("@/assets/imgs/home.png");
  background-size: cover;
  background-position: center;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* Centered search box */
.search-box {
  width: 600px;
  text-align: center;
  color: #eee;
}

.title {
  font-size: 30px;
  margin-bottom: 20px;
}

.search-input {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 10px;
}

/* Action buttons */
.action-btn {
  position: absolute;
  top: 20px;
  right: -150px;
  z-index: 10;
}

.action-btn:nth-child(2) {
  top: 70px;
}

/* Main content box */
.content-box {
  width: 70%;
  background-color: #fff;
  margin: 10px auto;
  padding: 20px;
  border-radius: 5px;
  position: relative;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

/* Filters styling */
.filters {
  margin-bottom: 20px;
}

.filters el-select {
  width: 200px;
}

/* Product item styling */
.goods-item {
  cursor: pointer;
  transition: transform 0.2s ease;
}

.goods-item:hover {
  transform: scale(1.03);
}

.goods-image {
  width: 100%;
  height: 260px;
  object-fit: cover;
  border-radius: 5px;
  margin-bottom: 10px;
}

.goods-name {
  font-size: 16px;
  color: #555;
  margin-bottom: 10px;
  line-height: 1.4;
}

.price-details {
  display: flex;
  align-items: baseline;
}

.price {
  color: red;
  font-size: 24px;
}

.view-count,
.like-count {
  margin-left: 20px;
  color: #666;
}

/* Pagination styling */
.el-pagination {
  margin-top: 15px;
}
</style>
