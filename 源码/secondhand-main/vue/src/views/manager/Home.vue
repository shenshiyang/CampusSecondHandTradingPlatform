<template>
  <div>
    <div class="card" style="padding: 15px">
      您好，{{ user?.name }}！欢迎使用本系统
    </div>

    <!-- 📊 今日销售统计卡片：本日销售额 + 本日订单数 + 销售额 + 订单数 -->
    <div class="card" style="margin: 10px 0; display: flex; align-items: center; gap: 30px; font-size: 18px">
      <!-- 销售额 -->
      <div style="display: flex; align-items: center; gap: 8px">
        <i class="el-icon-s-data" style="font-size: 22px; color: #409EFF"></i>
        <span>{{ periodLabel }}销售额：</span>
        <span style="font-weight: bold; color: red">￥{{ periodTotal }}</span>
      </div>
      <!-- 订单数 -->
      <div style="display: flex; align-items: center; gap: 8px">
        <i class="el-icon-s-order" style="font-size: 22px; color: #67C23A"></i>
        <span>{{ periodLabel }}订单数：</span>
        <span style="font-weight: bold; color: #333">{{ periodCount }}</span>
      </div>
      <!-- 周期切换按钮 -->
      <div style="margin-left: auto;">
        <el-button-group>
          <el-button :type="periodType==='day'?'primary':'default'" @click="changePeriodType('day')">本日</el-button>
          <el-button :type="periodType==='week'?'primary':'default'" @click="changePeriodType('week')">本周</el-button>
          <el-button :type="periodType==='month'?'primary':'default'" @click="changePeriodType('month')">本月</el-button>
          <el-button :type="periodType==='year'?'primary':'default'" @click="changePeriodType('year')">本年</el-button>
        </el-button-group>
      </div>
    </div>

    <!-- 第一行：图1、图2 -->
    <div style="display: flex; grid-gap: 10px; margin: 10px 0">
      <!-- 图1：销售额&订单数趋势 -->
      <div style="position: relative; flex: 1; height: 500px" class="card">
        <div style="position: absolute; right: 20px; top: 20px; z-index: 2;">
          <el-button-group>
            <el-button :type="chart1Type==='week'?'primary':'default'" @click="changeChartType(1, 'week')">按周</el-button>
            <el-button :type="chart1Type==='month'?'primary':'default'" @click="changeChartType(1, 'month')">按月</el-button>
            <el-button :type="chart1Type==='year'?'primary':'default'" @click="changeChartType(1, 'year')">按年</el-button>
          </el-button-group>
        </div>
        <div id="pie" style="height: 100%"></div>
      </div>
      <!-- 图2：商家销售额排行榜 -->
      <div style="position: relative; flex: 1; height: 500px" class="card">
        <div style="position: absolute; right: 20px; top: 20px; z-index: 2;">
          <el-button-group>
            <el-button :type="chart2Type==='week'?'primary':'default'" @click="changeChartType(2, 'week')">按周</el-button>
            <el-button :type="chart2Type==='month'?'primary':'default'" @click="changeChartType(2, 'month')">按月</el-button>
            <el-button :type="chart2Type==='year'?'primary':'default'" @click="changeChartType(2, 'year')">按年</el-button>
          </el-button-group>
        </div>
        <div id="pictorial" style="height: 100%"></div>
      </div>
    </div>

    <!-- 第二行：图3、图4 -->
    <div style="display: flex; grid-gap: 10px; margin-top: 20px">
      <!-- 图3：商品种类销量占比 -->
      <div style="position: relative; flex: 1; height: 500px" class="card">
        <div style="position: absolute; right: 20px; top: 20px; z-index: 2;">
          <el-button-group>
            <el-button :type="chart3Type==='week'?'primary':'default'" @click="changeChartType(3, 'week')">按周</el-button>
            <el-button :type="chart3Type==='month'?'primary':'default'" @click="changeChartType(3, 'month')">按月</el-button>
            <el-button :type="chart3Type==='year'?'primary':'default'" @click="changeChartType(3, 'year')">按年</el-button>
          </el-button-group>
        </div>
        <div id="categoryPie" style="height: 100%"></div>
      </div>
      <!-- 图4：用户在线趋势 -->
      <div style="position: relative; flex: 1; height: 500px" class="card">
        <div style="position: absolute; right: 20px; top: 20px; z-index: 2;">
          <el-button-group>
            <el-button :type="chart4Type==='week'?'primary':'default'" @click="changeChartType(4, 'week')">按周</el-button>
            <el-button :type="chart4Type==='month'?'primary':'default'" @click="changeChartType(4, 'month')">按月</el-button>
            <el-button :type="chart4Type==='year'?'primary':'default'" @click="changeChartType(4, 'year')">按年</el-button>
          </el-button-group>
        </div>
        <div id="onlineTrendChart" style="height: 100%"></div>
      </div>
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
      periodTotal: 0, // 顶部统计卡片-销售额
      periodCount: 0, // 顶部统计卡片-订单数
      periodType: 'week', // 顶部统计卡片周期，默认本周
      periodLabel: '本周',
      chart1Type: 'week',
      chart2Type: 'week',
      chart3Type: 'week',
      chart4Type: 'week',
    }
  },
  methods: {
    // 顶部统计卡片切换
    changePeriodType(type) {
      this.periodType = type;
      this.periodLabel = type === 'day' ? '本日' : (type === 'week' ? '本周' : (type === 'month' ? '本月' : '本年'));
      this.loadPeriodStats();
    },
    loadPeriodStats() {
      this.$request.get('/orders/todayTotal', { params: { dateType: this.periodType } }).then(res => {
        this.periodTotal = res.data || 0;
      });
      this.$request.get('/orders/todayCount', { params: { dateType: this.periodType } }).then(res => {
        this.periodCount = res.data || 0;
      });
    },
    // 图表切换
    changeChartType(idx, type) {
      this[`chart${idx}Type`] = type;
      this[`loadChart${idx}`]();
    },
    loadChart1() {
      const dom = document.getElementById('pie');
      if (echarts.getInstanceByDom(dom)) echarts.getInstanceByDom(dom).dispose();
      const pieChart = echarts.init(dom);
      // 动态标题
      let titleText = '销售额 & 订单数趋势';
      if (this.chart1Type === 'week') titleText = '近七日销售额 & 订单数趋势';
      else if (this.chart1Type === 'month') titleText = '近十二个月销售额 & 订单数趋势';
      else if (this.chart1Type === 'year') titleText = '近五年销售额 & 订单数趋势';
      this.$request.get('/orders/lineWithCount', { params: { dateType: this.chart1Type } }).then(res => {
        const data = res.data || [];
        const lineOption = {
          title: { text: titleText, left: 'center', top: 10 },
          tooltip: { trigger: 'axis' },
          legend: { data: ['销售额', '订单数'], top: 50 },
          grid: { top: 90, left: 60, right: 60, bottom: 60 },
          xAxis: { type: 'category', data: data.map(v => v.name), axisLabel: { rotate: 30 } },
          yAxis: [
            { type: 'value', name: '销售额（元）', axisLine: { lineStyle: { color: '#5470c6' } } },
            { type: 'value', name: '订单数（单）', minInterval: 1, axisLine: { lineStyle: { color: '#91cc75' } } }
          ],
          series: [
            { name: '销售额', type: 'line', smooth: true, yAxisIndex: 0, data: data.map(v => v.sales), itemStyle: { color: '#5470c6' } },
            { name: '订单数', type: 'line', smooth: true, yAxisIndex: 1, data: data.map(v => v.count), itemStyle: { color: '#91cc75' } }
          ]
        };
        pieChart.setOption(lineOption);
      });
    },
    loadChart2() {
      const dom = document.getElementById('pictorial');
      if (echarts.getInstanceByDom(dom)) echarts.getInstanceByDom(dom).dispose();
      const pictorialChart = echarts.init(dom);
      this.$request.get('/orders/selectBar', { params: { dateType: this.chart2Type } }).then(res => {
        const data = (res.data || []).sort((a, b) => b.value - a.value);
        const horizontalBarOption = {
          title: { text: '商家销售额排行榜', left: 'center' },
          tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
          grid: { left: '120px', right: '40px', bottom: '50px', top: '80px' },
          xAxis: { type: 'value', name: '销售额（元）' },
          yAxis: { type: 'category', data: data.map(v => v.name), inverse: true, axisLabel: { fontSize: 12 } },
          series: [{ name: '销售额', type: 'bar', barWidth: '50%', data: data.map(v => v.value), itemStyle: { color: '#91cc75' }, label: { show: true, position: 'right' } }]
        };
        pictorialChart.setOption(horizontalBarOption);
      });
    },
    loadChart3() {
      const dom = document.getElementById('categoryPie');
      if (echarts.getInstanceByDom(dom)) echarts.getInstanceByDom(dom).dispose();
      const categoryPieChart = echarts.init(dom);
      this.$request.get('/orders/selectCategorySalesCount', { params: { dateType: this.chart3Type } }).then(res => {
        const data = res.data || [];
        const categoryOption = {
          title: { text: '商品种类销量占比', left: 'center' },
          tooltip: { trigger: 'item' },
          legend: { orient: 'vertical', left: 'left' },
          series: [{ name: '销量', type: 'pie', radius: '60%', center: ['50%', '55%'], data: data.map(item => ({ value: item.value, name: item.name })), emphasis: { itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0, 0, 0, 0.5)' } } }]
        };
        categoryPieChart.setOption(categoryOption);
      });
    },
    loadChart4() {
      const dom = document.getElementById('onlineTrendChart');
      if (echarts.getInstanceByDom(dom)) echarts.getInstanceByDom(dom).dispose();
      const onlineTrendChart = echarts.init(dom);
      // 动态标题
      let titleText = '用户在线趋势';
      if (this.chart4Type === 'week') titleText = '近七日用户在线趋势';
      else if (this.chart4Type === 'month') titleText = '近十二个月用户在线趋势';
      else if (this.chart4Type === 'year') titleText = '近五年用户在线趋势';
      this.$request.get('/user/selectOnlineTrend', { params: { dateType: this.chart4Type } }).then(res => {
        const data = res.data || [];
        const onlineOption = {
          title: { text: titleText, left: 'center' },
          tooltip: { trigger: 'axis' },
          xAxis: { type: 'category', data: data.map(v => v.name), axisLabel: { rotate: 30, interval: 0 } },
          yAxis: { type: 'value', name: '在线用户数', minInterval: 1 },
          series: [{ name: '在线人数', type: 'line', smooth: true, data: data.map(v => v.value), itemStyle: { color: '#73c0de' } }]
        };
        onlineTrendChart.setOption(onlineOption);
      });
    }
  },
  mounted() {
    this.loadPeriodStats();
    this.loadChart1();
    this.loadChart2();
    this.loadChart3();
    this.loadChart4();
  }
}
</script>