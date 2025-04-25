<template>
  <div class="posts-page">
    <!-- ▍圈子筛选 -->
    <section class="circle-wrap">
      <!-- 「全部」 -->
      <div
        class="circle-card"
        :class="{ active: circle === '全部' }"
        @click="loadCircle('全部')"
      >
        <img src="@/assets/imgs/全部.png" />
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
        <img :src="c.img" />
        <span>{{ c.name }}</span>
      </div>
    </section>

    <!-- ▍帖子列表 / 骨架屏  —— 保证 v-if / v-else 相邻 -->
    <section>
      <template v-if="loading">
        <el-skeleton :rows="5" animated />
      </template>

      <template v-else>
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
                <span><i class="el-icon-user" /> {{ p.userName }}</span>
                <span><i class="el-icon-time" /> {{ p.time }}</span>
                <span><i class="el-icon-reading" /> {{ p.readCount }}</span>
              </div>
            </div>

            <!-- 缩略图 -->
            <el-image
              v-if="p.img"
              :src="p.img"
              :preview-src-list="[p.img]"
              class="post-img"
              fit="cover"
            />
          </div>
        </el-card>

        <!-- 分页 -->
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
  width: 60%;
  margin: 20px auto;
}

/* 圈子 */
.circle-wrap {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 20px;
}
.circle-card {
  display: flex;
  align-items: center;
  padding: 8px 12px;
  border-radius: 4px;
  cursor: pointer;
  transition: background 0.2s;
}
.circle-card img {
  width: 46px;
  height: 46px;
  margin-right: 6px;
}
.circle-card:hover,
.circle-card.active {
  background: #ffedd8;
}

/* 帖子卡片 */
.post-card {
  margin-bottom: 14px;
  cursor: pointer;
}
.post-main {
  display: flex;
  gap: 10px;
}
.post-body {
  flex: 1;
}
.post-title {
  font-size: 18px;
  margin-bottom: 6px;
}
.post-descr {
  color: #666;
  margin-bottom: 8px;
}
.post-meta {
  color: #909399;
  font-size: 13px;
  display: flex;
  gap: 18px;
}
.post-img {
  width: 90px;
  height: 90px;
  border-radius: 4px;
}

/* 分页 */
.pager {
  margin-top: 22px;
  text-align: center;
}
</style>
