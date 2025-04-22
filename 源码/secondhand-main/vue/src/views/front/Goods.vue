<template>
  <div class="goods-container">
    <el-card class="card-box">
      <el-table
        :data="tableData"
        stripe
        border
        empty-text="暂无商品数据"
        highlight-current-row
        style="width: 100%; table-layout: fixed"
      >
        <!-- 商品名称：居中 + 均分 -->
        <el-table-column prop="name" label="名称" align="center" show-overflow-tooltip />

        <!-- 固定列 -->
        <el-table-column prop="price" label="价格" width="100" align="center">
          <template v-slot="scope">
            <span style="color: red; font-weight: bold">￥{{ scope.row.price }}</span>
          </template>
        </el-table-column>

        <el-table-column label="库存" width="100" align="center">
          <template v-slot="scope">
            <span>{{ scope.row.stock }} 件</span>
          </template>
        </el-table-column>

        <el-table-column prop="saleStatus" label="上架状态" width="100" align="center">
          <template v-slot="scope">
            <el-tag :type="scope.row.saleStatus === '上架' ? 'success' : 'info'">
              {{ scope.row.saleStatus }}
            </el-tag>
          </template>
        </el-table-column>

        <el-table-column prop="readCount" label="浏览量" width="100" align="center" />

        <!-- 操作列：居中 + 均分 -->
        <el-table-column label="操作" align="center">
          <template v-slot="scope">
            <div class="btn-group">
              <el-tooltip content="编辑商品" placement="top">
                <el-button size="mini" type="primary" icon="el-icon-edit" @click="handleEdit(scope.row)" />
              </el-tooltip>
              <el-tooltip content="删除商品" placement="top">
                <el-button size="mini" type="danger" icon="el-icon-delete" @click="del(scope.row.id)" />
              </el-tooltip>
              <el-tooltip content="修改库存" placement="top">
                <el-button size="mini" icon="el-icon-s-tools" @click="openStockDialog(scope.row)" />
              </el-tooltip>
              <el-tooltip :content="scope.row.saleStatus === '上架' ? '点击下架' : '点击上架'" placement="top">
                <el-button
                  size="mini"
                  :type="scope.row.saleStatus === '上架' ? 'warning' : 'success'"
                  @click="toggleStatus(scope.row)"
                >
                  {{ scope.row.saleStatus === '上架' ? '下架' : '上架' }}
                </el-button>
              </el-tooltip>
            </div>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination-bar">
        <el-pagination
          background
          @current-change="handleCurrentChange"
          :current-page="pageNum"
          :page-size="pageSize"
          layout="total, prev, pager, next"
          :total="total"
        />
      </div>
    </el-card>

    <!-- 修改库存弹窗 -->
    <el-dialog
      title="修改库存"
      :visible.sync="stockDialogVisible"
      width="400px"
      :close-on-click-modal="false"
    >
      <div style="margin-bottom: 20px">
        <el-input-number v-model="tempStock" :min="0" controls-position="right" style="width: 100%" />
      </div>
      <div style="text-align: right">
        <el-button @click="stockDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmUpdateStock">确认修改</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: "FrontGoods",
  data() {
    return {
      tableData: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
      stockDialogVisible: false,
      currentRow: null,
      tempStock: 0,
    }
  },
  created() {
    this.load(1)
  },
  methods: {
    handleEdit(row) {
      this.$router.push('/front/addGoods?id=' + row.id)
    },
    del(id) {
      this.$confirm('您确定删除该商品吗？', '确认操作', { type: 'warning' }).then(() => {
        this.$request.delete('/goods/delete/' + id).then(res => {
          if (res.code === '200') {
            this.$message.success('删除成功')
            this.load(1)
          } else {
            this.$message.error(res.msg)
          }
        })
      }).catch(() => {})
    },
    toggleStatus(row) {
      const newStatus = row.saleStatus === '上架' ? '下架' : '上架'
      this.$request.post('/goods/updateStockAndSaleStatus', {
        id: row.id,
        stock: row.stock,
        saleStatus: newStatus
      }).then(res => {
        if (res.code === '200') {
          row.saleStatus = newStatus
          this.$message.success(`已${newStatus}`)
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    openStockDialog(row) {
      this.currentRow = row
      this.tempStock = row.stock
      this.stockDialogVisible = true
    },
    confirmUpdateStock() {
      this.$request.post('/goods/updateStockAndSaleStatus', {
        id: this.currentRow.id,
        stock: this.tempStock,
        saleStatus: this.currentRow.saleStatus
      }).then(res => {
        if (res.code === '200') {
          this.$message.success("库存已更新")
          this.currentRow.stock = this.tempStock
          this.stockDialogVisible = false
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    load(pageNum) {
      if (pageNum) this.pageNum = pageNum
      this.$request.get('/goods/selectPage', {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize
        }
      }).then(res => {
        if (res.code === '200') {
          this.tableData = res.data?.list || []
          this.total = res.data?.total
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    handleCurrentChange(pageNum) {
      this.load(pageNum)
    }
  }
}
</script>

<style scoped>
.goods-container {
  width: 90%;
  margin: 30px auto;
}
.card-box {
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  border-radius: 12px;
}
.pagination-bar {
  margin-top: 20px;
  text-align: center;
}
.btn-group {
  display: flex;
  gap: 8px;
  justify-content: center;
  flex-wrap: wrap;
}
</style>
