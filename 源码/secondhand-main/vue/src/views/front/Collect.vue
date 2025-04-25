<template>
  <div class="collect-page">
    <!-- ▍批量操作 -->
    <el-button
      type="danger"
      plain
      size="mini"
      class="mb10"
      @click="delBatch"
    >批量取消收藏</el-button>

    <!-- ▍收藏列表 -->
    <el-card shadow="never">
      <el-table
        :data="tableData"
        stripe
        border
        highlight-current-row
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="50" align="center" />

        <el-table-column
          prop="goodsName"
          label="商品名称"
          min-width="180"
          show-overflow-tooltip
        />

        <el-table-column label="商品图片" width="90" align="center">
          <template #default="{ row }">
            <el-image
              v-if="row.goodsImg"
              :src="row.goodsImg"
              :preview-src-list="[row.goodsImg]"
              style="width:40px;height:40px;border-radius:4px"
            />
          </template>
        </el-table-column>

        <el-table-column label="商品链接" width="100" align="center">
          <template #default="{ row }">
            <a
              :href="`/front/goodsDetail?id=${row.fid}`"
              target="_blank"
            >查看</a>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="120" align="center">
          <template #default="{ row }">
            <el-button
              size="mini"
              type="danger"
              plain
              @click="del(row.id)"
            >取消收藏</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- ▍分页 -->
      <el-pagination
        class="pager"
        background
        :current-page="pageNum"
        :page-size="pageSize"
        :total="total"
        :page-sizes="[5, 10, 20]"
        layout="total, prev, pager, next"
        @current-change="handleCurrentChange"
      />
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'Collect',
  data() {
    return {
      tableData: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
      ids: []
    }
  },
  created() {
    this.load()
  },
  methods: {
    /* ---------- 查询 ---------- */
    async load(page = this.pageNum) {
      this.pageNum = page
      const { code, data, msg } = await this.$request.get('/collect/selectPage', {
        params: { pageNum: this.pageNum, pageSize: this.pageSize }
      })
      if (code === '200') {
        this.tableData = data.list
        this.total = data.total
      } else {
        this.$message.error(msg)
      }
    },

    /* ---------- 删除 ---------- */
    del(id) {
      this.$confirm('确定取消收藏吗？', '提示', { type: 'warning' })
        .then(() => this.$request.delete('/collect/delete/' + id))
        .then(({ code, msg }) => {
          code === '200' ? (this.$message.success('操作成功'), this.load(1)) : this.$message.error(msg)
        })
        .catch(() => {})
    },
    handleSelectionChange(rows) {
      this.ids = rows.map(v => v.id)
    },
    delBatch() {
      if (!this.ids.length) return this.$message.warning('请选择数据')
      this.$confirm('确认批量取消收藏吗？', '提示', { type: 'warning' })
        .then(() => this.$request.delete('/collect/delete/batch', { data: this.ids }))
        .then(({ code, msg }) => {
          code === '200' ? (this.$message.success('操作成功'), this.load(1)) : this.$message.error(msg)
        })
        .catch(() => {})
    },

    /* ---------- 分页 ---------- */
    handleCurrentChange(page) {
      this.load(page)
    }
  }
}
</script>

<style scoped>
.collect-page {
  width: 70%;
  margin: 20px auto;
}
.mb10 {
  margin-bottom: 10px;
}
.pager {
  margin-top: 12px;
  text-align: center;
}
</style>
