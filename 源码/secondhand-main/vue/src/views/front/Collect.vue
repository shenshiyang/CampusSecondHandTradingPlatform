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
  width: 80%;
  max-width: 1200px;
  margin: 30px auto;
  padding: 0 20px;
}

/* 批量操作按钮 */
.mb10 {
  margin-bottom: 20px;
  padding: 10px 20px;
  border-radius: 6px;
  font-weight: 500;
  transition: all 0.3s;
}

.mb10:hover {
  background: #ff7875;
  border-color: #ff7875;
  color: #fff;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(255, 77, 79, 0.2);
}

/* 卡片样式 */
:deep(.el-card) {
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08) !important;
  margin-bottom: 20px;
}

/* 表格样式 */
:deep(.el-table) {
  border-radius: 8px;
  overflow: hidden;
}

:deep(.el-table th) {
  background-color: #fafafa;
  color: #333;
  font-weight: 500;
  padding: 12px 0;
}

:deep(.el-table td) {
  padding: 12px 0;
}

:deep(.el-table--striped .el-table__body tr.el-table__row--striped td) {
  background: #fafafa;
}

/* 商品图片样式 */
:deep(.el-image) {
  border-radius: 8px !important;
  transition: all 0.3s;
  cursor: pointer;
  border: 2px solid transparent;
}

:deep(.el-image:hover) {
  transform: scale(1.05);
  border-color: #1890ff;
  box-shadow: 0 2px 8px rgba(24, 144, 255, 0.2);
}

/* 商品链接样式 */
.el-table a {
  color: #1890ff;
  text-decoration: none;
  font-weight: 500;
  transition: all 0.3s;
  padding: 4px 8px;
  border-radius: 4px;
}

.el-table a:hover {
  color: #40a9ff;
  background: rgba(24, 144, 255, 0.1);
}

/* 操作按钮样式 */
:deep(.el-button--mini) {
  padding: 6px 12px;
  border-radius: 4px;
  transition: all 0.3s;
}

:deep(.el-button--mini:hover) {
  transform: translateY(-1px);
  background: #ff4d4f;
  border-color: #ff4d4f;
  color: #fff;
  box-shadow: 0 2px 8px rgba(255, 77, 79, 0.2);
}

/* 分页样式 */
.pager {
  margin-top: 20px;
  text-align: center;
  padding: 10px 0;
}

:deep(.el-pagination.is-background .el-pager li:not(.disabled).active) {
  background-color: #1890ff;
}

:deep(.el-pagination.is-background .el-pager li:not(.disabled):hover) {
  color: #1890ff;
}

/* 空状态样式 */
:deep(.el-table__empty-block) {
  padding: 40px 0;
}

:deep(.el-table__empty-text) {
  color: #999;
  font-size: 14px;
}
</style>
