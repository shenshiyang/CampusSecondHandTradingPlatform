<template>
  <div class="goods-container">
    <!-- Card Box for Product Table -->
    <el-card class="card-box">
      <el-table
        :data="tableData"
        stripe
        border
        empty-text="暂无商品数据"
        highlight-current-row
        style="width: 100%; table-layout: fixed"
      >
        <!-- 商品名称 -->
        <el-table-column prop="name" label="名称" align="center" show-overflow-tooltip />

        <!-- 价格列 -->
        <el-table-column prop="price" label="价格" width="100" align="center">
          <template v-slot="scope">
            <span class="price-text">￥{{ scope.row.price }}</span>
          </template>
        </el-table-column>

        <!-- 库存列 -->
        <el-table-column label="库存" width="100" align="center">
          <template v-slot="scope">
            <span>{{ scope.row.stock }} 件</span>
          </template>
        </el-table-column>

        <!-- 上架状态列 -->
        <el-table-column prop="saleStatus" label="上架状态" width="100" align="center">
          <template v-slot="scope">
            <el-tag :type="scope.row.saleStatus === '上架' ? 'success' : 'info'">
              {{ scope.row.saleStatus }}
            </el-tag>
          </template>
        </el-table-column>

        <!-- 审核状态列 -->
        <el-table-column prop="status" label="审核状态" width="100" align="center">
          <template v-slot="scope">
            <el-tag
              :type="scope.row.status === '通过' ? 'success' : (scope.row.status === '拒绝' ? 'danger' : 'info')"
            >
              {{ scope.row.status }}
            </el-tag>
          </template>
        </el-table-column>

        <!-- 浏览量列 -->
        <el-table-column prop="readCount" label="浏览量" width="100" align="center" />

        <!-- 操作列 -->
        <el-table-column label="操作" align="center" width="220">
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

      <!-- Pagination -->
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
      <div class="stock-input">
        <el-input-number v-model="tempStock" :min="0" controls-position="right" style="width: 100%" />
      </div>
      <div class="dialog-footer">
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
    };
  },
  created() {
    this.load(1);
  },
  methods: {
    handleEdit(row) {
      this.$router.push('/front/addGoods?id=' + row.id);
    },
    del(id) {
      this.$confirm('您确定删除该商品吗？', '确认操作', { type: 'warning' }).then(() => {
        this.$request.delete('/goods/delete/' + id).then(res => {
          if (res.code === '200') {
            this.$message.success('删除成功');
            this.load(1);
          } else {
            this.$message.error(res.msg);
          }
        });
      }).catch(() => {});
    },
    toggleStatus(row) {
      const newStatus = row.saleStatus === '上架' ? '下架' : '上架';
      this.$request.post('/goods/updateStockAndSaleStatus', {
        id: row.id,
        stock: row.stock,
        saleStatus: newStatus
      }).then(res => {
        if (res.code === '200') {
          row.saleStatus = newStatus;
          this.$message.success(`已${newStatus}`);
        } else {
          this.$message.error(res.msg);
        }
      });
    },
    openStockDialog(row) {
      this.currentRow = row;
      this.tempStock = row.stock;
      this.stockDialogVisible = true;
    },
    confirmUpdateStock() {
      this.$request.post('/goods/updateStockAndSaleStatus', {
        id: this.currentRow.id,
        stock: this.tempStock,
        saleStatus: this.currentRow.saleStatus
      }).then(res => {
        if (res.code === '200') {
          this.$message.success("库存已更新");
          this.currentRow.stock = this.tempStock;
          this.stockDialogVisible = false;
        } else {
          this.$message.error(res.msg);
        }
      });
    },
    load(pageNum) {
      if (pageNum) this.pageNum = pageNum;
      this.$request.get('/goods/selectPage', {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize
        }
      }).then(res => {
        if (res.code === '200') {
          this.tableData = res.data?.list || [];
          this.total = res.data?.total;
        } else {
          this.$message.error(res.msg);
        }
      });
    },
    handleCurrentChange(pageNum) {
      this.load(pageNum);
    }
  }
};
</script>

<style scoped>
/* Container Styling */
.goods-container {
  width: 90%;
  max-width: 1400px;
  min-width: 1200px;
  margin: 30px auto;
  padding: 0 20px;
}

/* Card Box Styling */
.card-box {
  padding: 25px;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08) !important;
  background: #fff;
  overflow-x: auto;
}

/* Table Styling */
:deep(.el-table) {
  border-radius: 8px;
  overflow: hidden;
}

:deep(.el-table th) {
  background-color: #fafafa;
  color: #333;
  font-weight: 500;
  padding: 12px 0;
  font-size: 14px;
}

:deep(.el-table td) {
  padding: 16px 0;
}

:deep(.el-table--striped .el-table__body tr.el-table__row--striped td) {
  background: #fafafa;
}

:deep(.el-table--border) {
  border-color: #f0f0f0;
}

:deep(.el-table--border th), :deep(.el-table--border td) {
  border-color: #f0f0f0;
}

/* Price Text Styling */
.price-text {
  color: #ff4d4f;
  font-weight: 500;
  font-size: 15px;
}

/* Status Tag Styling */
:deep(.el-tag) {
  padding: 4px 12px;
  border-radius: 4px;
  font-weight: 500;
}

:deep(.el-tag--success) {
  background: rgba(82, 196, 26, 0.1);
  border-color: rgba(82, 196, 26, 0.2);
  color: #52c41a;
}

:deep(.el-tag--info) {
  background: rgba(0, 0, 0, 0.04);
  border-color: rgba(0, 0, 0, 0.08);
  color: #666;
}

/* Button Group Styling */
.btn-group {
  display: flex;
  gap: 8px;
  justify-content: center;
  align-items: center;
}

:deep(.el-button--mini) {
  padding: 6px 12px;
  border-radius: 4px;
  transition: all 0.3s;
}

:deep(.el-button--mini:hover) {
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

/* Operation Buttons Styling */
:deep(.el-button--primary) {
  background: #1890ff;
  border-color: #1890ff;
}

:deep(.el-button--primary:hover) {
  background: #40a9ff;
  border-color: #40a9ff;
  box-shadow: 0 2px 8px rgba(24, 144, 255, 0.2);
}

:deep(.el-button--danger) {
  background: #ff4d4f;
  border-color: #ff4d4f;
  color: #fff;
}

:deep(.el-button--danger:hover) {
  background: #ff7875;
  border-color: #ff7875;
  box-shadow: 0 2px 8px rgba(255, 77, 79, 0.2);
}

:deep(.el-button--warning) {
  background: #faad14;
  border-color: #faad14;
  color: #fff;
}

:deep(.el-button--warning:hover) {
  background: #ffc53d;
  border-color: #ffc53d;
  box-shadow: 0 2px 8px rgba(250, 173, 20, 0.2);
}

:deep(.el-button--success) {
  background: #52c41a;
  border-color: #52c41a;
  color: #fff;
}

:deep(.el-button--success:hover) {
  background: #73d13d;
  border-color: #73d13d;
  box-shadow: 0 2px 8px rgba(82, 196, 26, 0.2);
}

/* Pagination Bar Styling */
.pagination-bar {
  margin-top: 25px;
  text-align: center;
  padding: 10px 0;
}

:deep(.el-pagination.is-background .el-pager li:not(.disabled).active) {
  background-color: #1890ff;
  color: #fff;
}

:deep(.el-pagination.is-background .el-pager li:not(.disabled):hover) {
  color: #1890ff;
}

/* Stock Dialog Styling */
:deep(.el-dialog) {
  border-radius: 12px;
  overflow: hidden;
}

:deep(.el-dialog__header) {
  background: #fafafa;
  padding: 15px 20px;
  margin: 0;
}

:deep(.el-dialog__title) {
  font-size: 16px;
  font-weight: 500;
  color: #333;
}

:deep(.el-dialog__body) {
  padding: 30px 20px;
}

.stock-input {
  margin-bottom: 25px;
}

:deep(.el-input-number) {
  width: 100%;
}

:deep(.el-input-number__increase), :deep(.el-input-number__decrease) {
  background-color: #fafafa;
  border-color: #e8e8e8;
  color: #666;
}

.dialog-footer {
  text-align: right;
  padding-top: 10px;
}

/* Empty State Styling */
:deep(.el-table__empty-block) {
  min-height: 200px;
}

:deep(.el-table__empty-text) {
  color: #999;
  font-size: 14px;
}
</style>
