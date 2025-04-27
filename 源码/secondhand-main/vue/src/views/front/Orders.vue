<template>
  <div class="orders-container">
    <!-- 顶部操作区 -->
    <div class="header-section">
      <div class="tab-group">
        <el-radio-group v-model="url" @change="load(1)" size="medium">
          <el-radio-button label="selectPage">
            <i class="el-icon-shopping-cart-2"></i> 我购买的订单
          </el-radio-button>
          <el-radio-button label="selectSalePage">
            <i class="el-icon-sold-out"></i> 我出售的订单
          </el-radio-button>
        </el-radio-group>
      </div>
      <div class="search-section">
        <el-input
          v-model="goodsName"
          placeholder="商品名称"
          prefix-icon="el-icon-goods"
          clearable
          class="search-input"
        />
        <el-input
          v-model="orderNo"
          placeholder="订单编号"
          prefix-icon="el-icon-document"
          clearable
          class="search-input"
        />
        <el-select
          v-model="status"
          placeholder="订单状态"
          clearable
          class="status-select"
        >
          <el-option value="已取消">
            <i class="el-icon-circle-close"></i> 已取消
          </el-option>
          <el-option value="待支付">
            <i class="el-icon-wallet"></i> 待支付
          </el-option>
          <el-option value="待发货">
            <i class="el-icon-box"></i> 待发货
          </el-option>
          <el-option value="待收货">
            <i class="el-icon-truck"></i> 待收货
          </el-option>
          <el-option value="已完成">
            <i class="el-icon-circle-check"></i> 已完成
          </el-option>
        </el-select>
        <div class="button-group">
          <el-button type="primary" @click="load(1)" icon="el-icon-search">搜索</el-button>
          <el-button type="warning" @click="reset" icon="el-icon-refresh-right">重置</el-button>
        </div>
      </div>
    </div>

    <!-- 订单列表 -->
    <el-card shadow="hover" class="order-card">
      <el-table 
        :data="tableData" 
        stripe 
        style="width: 100%"
        :header-cell-style="{background:'#f5f7fa', color: '#606266'}"
      >
        <el-table-column prop="id" label="序号" width="80" align="center" sortable />
        <el-table-column label="商品信息" min-width="300">
          <template #default="scope">
            <div class="goods-info">
              <el-image 
                v-if="scope.row.goodsImg" 
                :src="scope.row.goodsImg" 
                :preview-src-list="[scope.row.goodsImg]"
                fit="cover"
                class="goods-image"
              />
              <div class="goods-detail">
                <div class="goods-name">{{ scope.row.goodsName }}</div>
                <div class="goods-price">￥{{ scope.row.total }}</div>
              </div>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="订单信息" min-width="200">
          <template #default="scope">
            <div class="order-info">
              <div class="order-no">订单号：{{ scope.row.orderNo }}</div>
              <div class="order-time">下单时间：{{ scope.row.time }}</div>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="收货信息" min-width="200">
          <template #default="scope">
            <div class="delivery-info">
              <div>收货人：{{ scope.row.userName }}</div>
              <div>电话：{{ scope.row.phone }}</div>
              <div class="address">地址：{{ scope.row.address }}</div>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="saleName" label="卖家" width="120" align="center" />
        <el-table-column label="订单状态" width="100" align="center">
          <template #default="scope">
            <el-tag
              :type="getStatusType(scope.row.status)"
              effect="dark"
              size="medium"
            >{{ scope.row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="180">
          <template #default="scope">
            <div class="action-buttons">
              <div v-if="url === 'selectPage' && scope.row.status === '待支付'" class="button-group">
                <el-button 
                  size="mini" 
                  type="primary" 
                  icon="el-icon-wallet"
                  @click="pay(scope.row.orderNo)"
                >支付</el-button>
                <el-button 
                  size="mini" 
                  type="danger" 
                  icon="el-icon-close"
                  @click="changeStatus(scope.row, '已取消')"
                >取消</el-button>
              </div>
              <el-button 
                v-if="scope.row.status === '待发货' && scope.row.saleId === user.id" 
                size="mini" 
                type="success" 
                icon="el-icon-truck"
                @click="changeStatus(scope.row, '待收货')"
              >发货</el-button>
              <el-button 
                v-if="scope.row.status === '待收货' && scope.row.userId === user.id" 
                size="mini" 
                type="info" 
                icon="el-icon-box"
                @click="changeStatus(scope.row, '已完成')"
              >收货</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页器 -->
      <div class="pagination-container">
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

    <el-dialog title="订单信息" :visible.sync="fromVisible" width="40%" :close-on-click-modal="false" destroy-on-close>
      <el-form :model="form" label-width="100px" style="padding-right: 50px" :rules="rules" ref="formRef">
        <el-form-item label="商品名称" prop="goodsName">
          <el-input v-model="form.goodsName" placeholder="商品名称"></el-input>
        </el-form-item>
        <el-form-item label="商品图片" prop="goodsImg">
          <el-input v-model="form.goodsImg" placeholder="商品图片"></el-input>
        </el-form-item>
        <el-form-item label="订单编号" prop="orderNo">
          <el-input v-model="form.orderNo" placeholder="订单编号"></el-input>
        </el-form-item>
        <el-form-item label="总价" prop="total">
          <el-input v-model="form.total" placeholder="总价"></el-input>
        </el-form-item>
        <el-form-item label="下单时间" prop="time">
          <el-input v-model="form.time" placeholder="下单时间"></el-input>
        </el-form-item>
        <el-form-item label="支付单号" prop="payNo">
          <el-input v-model="form.payNo" placeholder="支付单号"></el-input>
        </el-form-item>
        <el-form-item label="支付时间" prop="payTime">
          <el-input v-model="form.payTime" placeholder="支付时间"></el-input>
        </el-form-item>
        <el-form-item label="下单人ID" prop="userId">
          <el-input v-model="form.userId" placeholder="下单人ID"></el-input>
        </el-form-item>
        <el-form-item label="收货地址" prop="address">
          <el-input v-model="form.address" placeholder="收货地址"></el-input>
        </el-form-item>
        <el-form-item label="联系方式" prop="phone">
          <el-input v-model="form.phone" placeholder="联系方式"></el-input>
        </el-form-item>
        <el-form-item label="收货人名称" prop="userName">
          <el-input v-model="form.userName" placeholder="收货人名称"></el-input>
        </el-form-item>
        <el-form-item label="订单状态" prop="status">
          <el-input v-model="form.status" placeholder="订单状态"></el-input>
        </el-form-item>
        <el-form-item label="卖家ID" prop="saleId">
          <el-input v-model="form.saleId" placeholder="卖家ID"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="fromVisible = false">取 消</el-button>
        <el-button type="primary" @click="save">确 定</el-button>
      </div>
    </el-dialog>

  </div>
</template>

<script>
export default {
  name: "Orders",
  data() {
    return {
      url: 'selectPage',
      tableData: [],  // 所有的数据
      pageNum: 1,   // 当前的页码
      pageSize: 10,  // 每页显示的个数
      total: 0,
      fromVisible: false,
      form: {},
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      rules: {
      },
      ids: [],
      goodsName: null,
      orderNo: null,
      status: null
    }
  },
  created() {
    this.load(1)
  },
  methods: {
    getStatusType(status) {
      const statusMap = {
        '已取消': 'danger',
        '待支付': 'warning',
        '待发货': 'primary',
        '待收货': 'info',
        '已完成': 'success'
      }
      return statusMap[status] || 'info'
    },
    pay(orderNo) {
      window.open('http://localhost:9090/alipay/pay?orderNo=' + orderNo)
    },
    changeStatus(row, status) {
      this.$confirm('您确认操作吗？', '确认操作', {type: "warning"}).then(response => {
        this.form = JSON.parse(JSON.stringify(row))
        this.form.status = status
        this.$request.put('/orders/update', this.form).then(res => {
          if (res.code === '200') {  // 表示成功保存
            this.$message.success('操作成功')
            this.load(1)
          } else {
            this.$message.error(res.msg)  // 弹出错误的信息
          }
        })
      }).catch(e => {})
    },
    handleAdd() {   // 新增数据
      this.form = {}  // 新增数据的时候清空数据
      this.fromVisible = true   // 打开弹窗
    },
    handleEdit(row) {   // 编辑数据
      this.form = JSON.parse(JSON.stringify(row))  // 给form对象赋值  注意要深拷贝数据
      this.fromVisible = true   // 打开弹窗
    },
    save() {   // 保存按钮触发的逻辑  它会触发新增或者更新
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          this.$request({
            url: this.form.id ? '/orders/update' : '/orders/add',
            method: this.form.id ? 'PUT' : 'POST',
            data: this.form
          }).then(res => {
            if (res.code === '200') {  // 表示成功保存
              this.$message.success('保存成功')
              this.load(1)
              this.fromVisible = false
            } else {
              this.$message.error(res.msg)  // 弹出错误的信息
            }
          })
        }
      })
    },
    del(id) {   // 单个删除
      this.$confirm('您确定删除吗？', '确认删除', {type: "warning"}).then(response => {
        this.$request.delete('/orders/delete/' + id).then(res => {
          if (res.code === '200') {   // 表示操作成功
            this.$message.success('操作成功')
            this.load(1)
          } else {
            this.$message.error(res.msg)  // 弹出错误的信息
          }
        })
      }).catch(() => {
      })
    },
    handleSelectionChange(rows) {   // 当前选中的所有的行数据
      this.ids = rows.map(v => v.id)
    },
    delBatch() {   // 批量删除
      if (!this.ids.length) {
        this.$message.warning('请选择数据')
        return
      }
      this.$confirm('您确定批量删除这些数据吗？', '确认删除', {type: "warning"}).then(response => {
        this.$request.delete('/orders/delete/batch', {data: this.ids}).then(res => {
          if (res.code === '200') {   // 表示操作成功
            this.$message.success('操作成功')
            this.load(1)
          } else {
            this.$message.error(res.msg)  // 弹出错误的信息
          }
        })
      }).catch(() => {
      })
    },
    load(pageNum) {  // 分页查询
      if (pageNum) this.pageNum = pageNum
      this.$request.get('/orders/' + this.url, {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          goodsName: this.goodsName,
          status: this.status,
          orderNo: this.orderNo,
        }
      }).then(res => {
        if (res.code === '200') {
          this.tableData = res.data?.list
          this.total = res.data?.total
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    reset() {
      this.goodsName = null
      this.orderNo = null
      this.status = null
      this.load(1)
    },
    handleCurrentChange(pageNum) {
      this.load(pageNum)
    },
  }
}
</script>

<style scoped>
.orders-container {
  width: 95%;
  max-width: 1400px;
  margin: 20px auto;
  padding: 0 20px;
}

.header-section {
  margin-bottom: 20px;
}

.tab-group {
  margin-bottom: 20px;
}

.search-section {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
  align-items: center;
  background: #fff;
  padding: 16px;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
}

.search-input {
  width: 200px;
}

.status-select {
  width: 200px;
}

.button-group {
  display: flex;
  gap: 8px;
}

.order-card {
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
}

.goods-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.goods-image {
  width: 60px;
  height: 60px;
  border-radius: 4px;
  object-fit: cover;
}

.goods-detail {
  flex: 1;
}

.goods-name {
  font-size: 14px;
  color: #303133;
  margin-bottom: 4px;
}

.goods-price {
  color: #f56c6c;
  font-weight: 500;
  font-size: 15px;
}

.order-info, .delivery-info {
  font-size: 13px;
  color: #606266;
  line-height: 1.6;
}

.order-no {
  color: #409EFF;
  font-weight: 500;
}

.address {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 200px;
}

.action-buttons {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.button-group {
  display: flex;
  gap: 8px;
  justify-content: center;
}

.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: center;
  padding: 16px 0;
}

:deep(.el-table) {
  border-radius: 8px;
  overflow: hidden;
}

:deep(.el-table th) {
  font-weight: 500;
}

:deep(.el-radio-button__inner) {
  display: flex;
  align-items: center;
  gap: 4px;
}

:deep(.el-select-dropdown__item) {
  display: flex;
  align-items: center;
  gap: 4px;
}

:deep(.el-button [class*="el-icon-"] + span) {
  margin-left: 4px;
}

:deep(.el-tag) {
  font-weight: 500;
}

:deep(.el-table__row) {
  transition: all 0.3s;
}

:deep(.el-table__row:hover) {
  background-color: #f5f7fa !important;
}

:deep(.el-button--mini) {
  padding: 6px 12px;
  font-size: 12px;
  border-radius: 4px;
}

:deep(.el-button--mini [class*="el-icon-"]) {
  margin-right: 4px;
  font-size: 14px;
}

:deep(.el-button--primary) {
  background-color: #409EFF;
  border-color: #409EFF;
}

:deep(.el-button--primary:hover) {
  background-color: #66b1ff;
  border-color: #66b1ff;
}

:deep(.el-button--danger) {
  background-color: #F56C6C;
  border-color: #F56C6C;
}

:deep(.el-button--danger:hover) {
  background-color: #f78989;
  border-color: #f78989;
}
</style>