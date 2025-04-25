<template>
  <div>
    <div class="card" style="padding: 15px">
      您好，{{ user?.name }}！欢迎使用本系统
    </div>

    <!-- 📊 今日销售统计卡片：销售额 + 订单数 -->
    <div class="card" style="margin: 10px 0; display: flex; align-items: center; gap: 30px; font-size: 18px">
      <!-- 销售额 -->
      <div style="display: flex; align-items: center; gap: 8px">
        <i class="el-icon-s-data" style="font-size: 22px; color: #409EFF"></i>
        <span>今日销售额：</span>
        <span style="font-weight: bold; color: red">￥{{ todayTotal }}</span>
      </div>
      <!-- 订单数 -->
      <div style="display: flex; align-items: center; gap: 8px">
        <i class="el-icon-s-order" style="font-size: 22px; color: #67C23A"></i>
        <span>今日订单数：</span>
        <span style="font-weight: bold; color: #333">{{ todayCount }}</span>
      </div>
    </div>

    <!-- 第一行：图1、图2 -->
    <div style="display: flex; grid-gap: 10px; margin: 10px 0">
      <div style="flex: 1; height: 500px" id="pie" class="card"></div>
      <div style="flex: 1; height: 500px" id="pictorial" class="card"></div>
    </div>

    <!-- 第二行：图3、图4 -->
    <div style="display: flex; grid-gap: 10px; margin-top: 20px">
      <div style="flex: 1; height: 500px" id="categoryPie" class="card"></div>
      <div style="flex: 1; height: 500px" id="onlineTrendChart" class="card"></div>
    </div>
  </div>
</template>

<script>
import * as echarts from 'echarts'

export default {
  name: 'Home',
  data() {
    return {
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      todayTotal: 0, // 今日销售额
      todayCount: 0  // 今日订单数
    }
  },
  mounted() {
    // 请求今日销售额
    this.$request.get('/orders/todayTotal').then(res => {
      this.todayTotal = res.data || 0
    })
    // 请求今日订单数
    this.$request.get('/orders/todayCount').then(res => {
      this.todayCount = res.data || 0
    })

    const pieChart = echarts.init(document.getElementById('pie'))
    const pictorialChart = echarts.init(document.getElementById('pictorial'))
    const categoryPieChart = echarts.init(document.getElementById('categoryPie'))
    const onlineTrendChart = echarts.init(document.getElementById('onlineTrendChart'))

    // 图1：销售额趋势
    // 图1：销售额 & 订单数双折线趋势图
this.$request.get('/orders/lineWithCount').then(res => {
  const data = res.data || []
  const lineOption = {
    title: {
      text: '近八日销售额 & 订单数趋势',
      // subtext: '双折线对比图',
      left: 'center',
      top: 10
    },
    tooltip: { trigger: 'axis' },
    legend: {
      data: ['销售额', '订单数'],
      top: 50  // ✅ 避免和标题重叠
    },
    grid: {
      top: 90,     // ✅ 给标题和图例留出充分空间
      left: 60,
      right: 60,
      bottom: 60
    },
    xAxis: {
      type: 'category',
      data: data.map(v => v.name),
      axisLabel: { rotate: 30 }
    },
    yAxis: [
      {
        type: 'value',
        name: '销售额（元）',
        axisLine: { lineStyle: { color: '#5470c6' } }
      },
      {
        type: 'value',
        name: '订单数（单）',
        minInterval: 1,
        axisLine: { lineStyle: { color: '#91cc75' } }
      }
    ],
    series: [
      {
        name: '销售额',
        type: 'line',
        smooth: true,
        yAxisIndex: 0,
        data: data.map(v => v.sales),
        itemStyle: { color: '#5470c6' }
      },
      {
        name: '订单数',
        type: 'line',
        smooth: true,
        yAxisIndex: 1,
        data: data.map(v => v.count),
        itemStyle: { color: '#91cc75' }
      }
    ]
  }
  pieChart.setOption(lineOption)
})


    // 图2：商家销售额排行榜
    this.$request.get('/orders/selectBar').then(res => {
      const data = (res.data || []).sort((a, b) => b.value - a.value)
      const horizontalBarOption = {
        title: {
          text: '商家销售额排行榜',
          // subtext: '横向条形图（降序）',
          left: 'center'
        },
        tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
        grid: { left: '120px', right: '40px', bottom: '50px', top: '80px' },
        xAxis: { type: 'value', name: '销售额（元）' },
        yAxis: {
          type: 'category',
          data: data.map(v => v.name),
          inverse: true,
          axisLabel: { fontSize: 12 }
        },
        series: [{
          name: '销售额',
          type: 'bar',
          barWidth: '50%',
          data: data.map(v => v.value),
          itemStyle: { color: '#91cc75' },
          label: { show: true, position: 'right' }
        }]
      }
      pictorialChart.setOption(horizontalBarOption)
    })

    // 图3：商品种类销量占比
    this.$request.get('/orders/selectCategorySalesCount').then(res => {
      const data = res.data || []
      const categoryOption = {
        title: {
          text: '商品种类销量占比',
          // subtext: '饼图',
          left: 'center'
        },
        tooltip: { trigger: 'item' },
        legend: { orient: 'vertical', left: 'left' },
        series: [{
          name: '销量',
          type: 'pie',
          radius: '60%',
          center: ['50%', '55%'],
          data: data.map(item => ({ value: item.value, name: item.name })),
          emphasis: {
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(0, 0, 0, 0.5)'
            }
          }
        }]
      }
      categoryPieChart.setOption(categoryOption)
    })

    // 图4：用户在线趋势图
    this.$request.get('/user/selectOnlineTrend').then(res => {
      const data = res.data || []
      const onlineOption = {
        title: {
          text: '近八日用户在线趋势',
          // subtext: '折线图',
          left: 'center'
        },
        tooltip: { trigger: 'axis' },
        xAxis: {
          type: 'category',
          data: data.map(v => v.name),
          axisLabel: { rotate: 30, interval: 0 }
        },
        yAxis: {
          type: 'value',
          name: '在线用户数',
          minInterval: 1
        },
        series: [{
          name: '在线人数',
          type: 'line',
          smooth: true,
          data: data.map(v => v.value),
          itemStyle: { color: '#73c0de' }
        }]
      }
      onlineTrendChart.setOption(onlineOption)
    })
  }
}
</script>