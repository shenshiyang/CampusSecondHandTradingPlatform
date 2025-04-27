<template>
  <div class="posts-page">
    <!-- 圈子筛选区 -->
    <section class="circle-section">
      <h2 class="section-title">
        <i class="el-icon-collection-tag"></i>
        圈子分类
      </h2>
      <div class="circle-wrap">
        <!-- 「全部」选项 -->
        <div
          class="circle-card"
          :class="{ active: circle === '全部' }"
          @click="loadCircle('全部')"
        >
          <div class="circle-icon">
            <img src="@/assets/imgs/全部.png" alt="全部" />
          </div>
          <span>全部</span>
        </div>

        <!-- 其余圈子 -->
        <div
          v-for="c in circles"
          :key="c.id"
          class="circle-card"
          :class="{ active: circle === c.name }"
          @click="loadCircle(c.name)"
        >
          <div class="circle-icon">
            <img :src="c.img" :alt="c.name" />
          </div>
          <span>{{ c.name }}</span>
        </div>
      </div>
    </section>

    <!-- 帖子列表区 -->
    <section class="posts-section">
      <h2 class="section-title">
        <i class="el-icon-document"></i>
        {{ circle === '全部' ? '全部帖子' : circle + '圈子' }}
      </h2>

      <!-- 骨架屏 -->
      <template v-if="loading">
        <el-skeleton :rows="5" animated class="post-skeleton" />
      </template>

      <!-- 帖子列表 -->
      <template v-else>
        <transition-group name="post-list">
          <el-card
            v-for="p in tableData"
            :key="p.id"
            class="post-card"
            shadow="hover"
            @click.native="$router.push(`/front/postsDetail?id=${p.id}`)"
          >
            <div class="post-main">
              <!-- 文字区 -->
              <div class="post-body">
                <h3 class="post-title">{{ p.title }}</h3>
                <p class="post-descr">{{ p.descr }}</p>
                <div class="post-meta">
                  <span class="meta-item">
                    <i class="el-icon-user" />
                    <span class="meta-text">{{ p.userName }}</span>
                  </span>
                  <span class="meta-item">
                    <i class="el-icon-time" />
                    <span class="meta-text">{{ p.time }}</span>
                  </span>
                  <span class="meta-item">
                    <i class="el-icon-reading" />
                    <span class="meta-text">{{ p.readCount }}次阅读</span>
                  </span>
                </div>
              </div>

              <!-- 缩略图 -->
              <el-image
                v-if="p.img"
                :src="p.img"
                :preview-src-list="[p.img]"
                class="post-img"
                fit="cover"
              >
                <div slot="error" class="image-error">
                  <i class="el-icon-picture-outline"></i>
                </div>
              </el-image>
            </div>
          </el-card>
        </transition-group>

        <!-- 分页器 -->
        <el-pagination
          v-if="total"
          class="pager"
          background
          layout="total, prev, pager, next"
          :current-page="pageNum"
          :page-size="pageSize"
          :total="total"
          :page-sizes="[4, 8, 12]"
          @current-change="handleCurrentChange"
        />
      </template>
    </section>
  </div>
</template>

<script>
export default {
  name: 'Posts',
  data() {
    return {
      circles: [],
      circle: '全部',
      tableData: [],
      total: 0,
      pageNum: 1,
      pageSize: 4,
      loading: false
    }
  },
  created() {
    this.fetchCircles()
    this.load()
  },
  methods: {
    /* 读取圈子 */
    async fetchCircles() {
      const { data } = await this.$request.get('/circles/selectAll')
      this.circles = data || []
    },

    /* 点击圈子 */
    loadCircle(name) {
      if (this.circle === name) return // 避免重复请求
      this.circle = name
      this.load(1)
    },

    /* 读取帖子 */
    async load(page = this.pageNum) {
      this.pageNum = page
      this.loading = true
      const { code, data, msg } = await this.$request.get('/posts/selectFrontPage', {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          circle: this.circle === '全部' ? null : this.circle
        }
      })
      this.loading = false
      if (code === '200') {
        this.tableData = data.list
        this.total = data.total
      } else {
        this.$message.error(msg)
      }
    },

    /* 分页切换 */
    handleCurrentChange(page) {
      this.load(page)
    }
  }
}
</script>

<style scoped>
.posts-page {
  width: 80%;
  max-width: 1200px;
  margin: 30px auto;
  padding: 0 20px;
}

/* 区块标题 */
.section-title {
  font-size: 20px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.section-title i {
  color: #409EFF;
  font-size: 24px;
}

/* 圈子区域 */
.circle-section {
  background: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  margin-bottom: 30px;
}

.circle-wrap {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
}

.circle-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 16px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  background: #f5f7fa;
  min-width: 100px;
}

.circle-icon {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  overflow: hidden;
  margin-bottom: 8px;
  background: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.circle-icon img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.circle-card span {
  font-size: 14px;
  color: #606266;
}

.circle-card:hover {
  transform: translateY(-2px);
  background: #ecf5ff;
}

.circle-card.active {
  background: #409EFF;
  color: #fff;
}

.circle-card.active span {
  color: #fff;
}

/* 帖子区域 */
.posts-section {
  background: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
}

.post-skeleton {
  padding: 20px;
}

/* 帖子卡片 */
.post-card {
  margin-bottom: 20px;
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 8px;
  overflow: hidden;
}

.post-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.post-main {
  display: flex;
  gap: 20px;
  padding: 10px;
}

.post-body {
  flex: 1;
  overflow: hidden;
}

.post-title {
  font-size: 18px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 12px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.post-descr {
  color: #606266;
  margin-bottom: 16px;
  line-height: 1.6;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  line-clamp: 2;
  overflow: hidden;
  text-overflow: ellipsis;
}

.post-meta {
  display: flex;
  gap: 24px;
  color: #909399;
  font-size: 13px;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 4px;
}

.meta-item i {
  font-size: 16px;
}

.post-img {
  width: 120px;
  height: 120px;
  border-radius: 8px;
  overflow: hidden;
  flex-shrink: 0;
}

.image-error {
  width: 100%;
  height: 100%;
  background: #f5f7fa;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #909399;
  font-size: 24px;
}

/* 分页器 */
.pager {
  margin-top: 30px;
  text-align: center;
  padding-bottom: 20px;
}

/* 列表动画 */
.post-list-enter-active, .post-list-leave-active {
  transition: all 0.5s ease;
}

.post-list-enter, .post-list-leave-to {
  opacity: 0;
  transform: translateY(30px);
}

.post-list-move {
  transition: transform 0.5s ease;
}

/* 响应式调整 */
@media screen and (max-width: 768px) {
  .posts-page {
    width: 95%;
    padding: 0 10px;
  }

  .post-main {
    flex-direction: column;
  }

  .post-img {
    width: 100%;
    height: 200px;
  }

  .circle-card {
    min-width: 80px;
    padding: 12px;
  }
}
</style>
