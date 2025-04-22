<template>
  <div class="help-container">
    <!-- 查询栏 -->
    <div class="search-bar">
      <el-input
        v-model="title"
        placeholder="请输入标题关键字查询"
        clearable
        class="search-input"
      />
      <el-button type="primary" @click="load(1)">查询</el-button>
    </div>

    <!-- 求助卡片列表 -->
    <el-card
      class="help-card"
      v-for="item in tableData"
      :key="item.id"
    >
      <div class="help-header">
        <img :src="item.avatar" alt="用户头像" class="user-avatar" />
        <div class="help-info">
          <div class="help-title">
            <strong>{{ item.title }}</strong>
            <el-tag type="danger" v-if="item.solved === '未解决'">未解决</el-tag>
            <el-tag type="success" v-if="item.solved === '已解决'">已解决</el-tag>
          </div>
          <div class="meta">
            <span>{{ item.userName }}</span>
            <span>{{ item.time }}</span>
          </div>
        </div>
      </div>

      <el-image
        class="help-img"
        :src="item.img"
        :preview-src-list="[item.img]"
        fit="cover"
        v-if="item.img"
      />

      <div class="help-content" v-html="item.content"></div>

      <el-button
        class="comment-toggle-btn"
        type="primary"
        size="small"
        @click="handleCommentShow(item)"
      >
        展开 / 折叠 求购评论
      </el-button>

      <div v-if="item.showComment" class="comment-section">
        <Comment :fid="item.id" module="help" />
      </div>
    </el-card>

    <!-- 分页 -->
    <div class="pagination-wrapper" v-if="total > 0">
      <el-pagination
        background
        layout="total, prev, pager, next"
        :current-page="pageNum"
        :page-size="pageSize"
        :total="total"
        :page-sizes="[5, 10, 20]"
        @current-change="handleCurrentChange"
      />
    </div>
  </div>
</template>

<script>
import Comment from "@/components/Comment";
export default {
  name: "Help",
  components: { Comment },
  data() {
    return {
      tableData: [],
      pageNum: 1,
      pageSize: 5,
      total: 0,
      title: '',
    };
  },
  created() {
    this.load(1);
  },
  methods: {
    handleCommentShow(help) {
      this.$set(help, 'showComment', !help.showComment);
    },
    load(pageNum) {
      if (pageNum) this.pageNum = pageNum;
      this.$request.get('/help/selectFrontPage', {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          title: this.title
        }
      }).then(res => {
        if (res.code === '200') {
          this.tableData = res.data?.list;
          this.total = res.data?.total;
        } else {
          this.$message.error(res.msg);
        }
      });
    },
    handleCurrentChange(pageNum) {
      this.load(pageNum);
    },
  }
};
</script>

<style scoped>
.help-container {
  width: 60%;
  margin: 20px auto;
}
.search-bar {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
}
.search-input {
  width: 300px;
  margin-right: 10px;
}
.help-card {
  margin-bottom: 20px;
  padding: 20px;
}
.help-header {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
}
.user-avatar {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  object-fit: cover;
  margin-right: 15px;
}
.help-info {
  flex: 1;
}
.help-title {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 16px;
  margin-bottom: 5px;
}
.meta {
  color: #888;
  font-size: 13px;
  display: flex;
  gap: 20px;
}
.help-img {
  width: 100%;
  max-width: 300px;
  margin: 15px 0;
}
.help-content {
  font-size: 14px;
  color: #444;
  margin: 10px 0 15px;
}
.comment-toggle-btn {
  margin-bottom: 10px;
}
.pagination-wrapper {
  text-align: center;
  margin-top: 30px;
}
</style>
