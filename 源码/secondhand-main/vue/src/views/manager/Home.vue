<template>
  <div>
    <div class="card" style="padding: 15px">
      您好，{{ user?.name }}！欢迎使用本系统
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
    }
  },
  mounted() {
    const pieChart = echarts.init(document.getElementById('pie'))              // 图1：商品销售额趋势
    const pictorialChart = echarts.init(document.getElementById('pictorial'))  // 图2：商家销售额排行榜
    const categoryPieChart = echarts.init(document.getElementById('categoryPie')) // 图3：商品种类占比
    const onlineTrendChart = echarts.init(document.getElementById('onlineTrendChart')) // 图4：用户在线趋势

    // ✅ 图1：商品销售额趋势（折线图）
    this.$request.get('/orders/selectLine').then(res => {
      const data = res.data || []
      const lineOption = {
        title: {
          text: '近八日商品销售额趋势',
          subtext: '折线图',
          left: 'center'
        },
        tooltip: { trigger: 'axis' },
        xAxis: {
          type: 'category',
          data: data.map(v => v.name),
          axisLabel: { rotate: 30, interval: 0 }
        },
        yAxis: { type: 'value', name: '销售额（元）' },
        series: [{
          name: '销售额',
          type: 'line',
          smooth: true,
          data: data.map(v => v.value),
          itemStyle: { color: '#5470c6' }
        }]
      }
      pieChart.setOption(lineOption)
    })

    // ✅ 图2：商家销售额排行榜（横向条形图）
    this.$request.get('/orders/selectBar').then(res => {
      const data = (res.data || []).sort((a, b) => b.value - a.value)
      const horizontalBarOption = {
        title: {
          text: '商家销售额排行榜',
          subtext: '横向条形图（降序）',
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

    // ✅ 图3：商品种类销售数量占比（饼图）
    this.$request.get('/orders/selectCategorySalesCount').then(res => {
      const data = res.data || []
      const categoryOption = {
        title: {
          text: '商品种类销量占比',
          subtext: '饼图',
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

    // ✅ 图4：用户每日在线数量趋势图（折线图）
    this.$request.get('/user/selectOnlineTrend').then(res => {
      const data = res.data || []
      const onlineOption = {
        title: {
          text: '近八日用户在线趋势',
          subtext: '折线图',
          left: 'center'
        },
        tooltip: { trigger: 'axis' },
        xAxis: {
          type: 'category',
          data: data.map(v => v.name),
          axisLabel: { rotate: 30, interval: 0 }
        },
        yAxis: { type: 'value', name: '在线用户数' },
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
