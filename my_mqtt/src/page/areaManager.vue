<template>
  <div class="home">
    <div class="left" ref="chartRef"></div>
    <div class="right">
      <div class="top" ref="topChart"></div>
      <div class="middle" ref="middleChart"></div>
      <div class="buttom" ref="buttomChart"></div>
    </div>

    <!-- 视频播放器 -->
    <div
      class="video"
      :style="{
        top: itemPoint[0] + 'px',
        left: itemPoint[1] + 'px',
      }"
      v-show="videoShow"
    >
      <video autoplay loop muted src="/bgc.mp4"></video>
    </div>

    <el-dialog title="添加传感器" :visible.sync="dialogVisible" width="20%">
      <span>{{
        `是否确定在区域:【${clickPoint[0]},${clickPoint[1]}】添加传感器？`
      }}</span>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="createSensor">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>
<script>
import * as echarts from "echarts";
import mqtt from "@/plugins/mqtt";
const maxDust = 5; //粉尘浓度阈值
let currentSensorId = -1;
const requestTopic = "sensor/request";
const responseTopic = "sensor/response";
export default {
  name: "AreaManager",
  data() {
    return {
      dialogVisible: false, //弹出添加传感器的框
      clickPoint: [1, 1], //要添加传感器的区域
      videoShow: false,
      chartInstance: null,
      topChart: null,
      middleChart: null,
      buttomChart: null,
      currentSensor: {},
      currentSensorId: -1,
      itemPoint: [180, 448],
      sensorData: [],
    };
  },
  watch: {
    itemPoint: {
      handler(newVal, oldVal) {
        // console.log("视频坐标变化");
      },
      deep: true, // 开启深度监视
      immediate: true, // 可选：是否在初始化时立即执行 handler
    },
    currentSensor: {
      handler(newVal, oldVal) {
        this.setOption();
        // console.log("切换传感器");
      },
      immediate: false, // 可选：是否在初始化时立即执行 handler
    },
  },
  mounted() {
    //订阅
    mqtt.client.subscribe(responseTopic, () => {
      // console.log(`订阅成功,topic:${responseTopic}`);

      //发送一次获取所有传感器数据的消息
      let message = {
        action: "getAllSensors",
      };
      this.sendMessage(requestTopic, message);
    });

    mqtt.client.on("message", this.printMesage);

    if (this.sensorData.length > 0) {
      //初始化当前选择的传感器
      this.currentSensor = this.sensorData[0];

      currentSensorId = this.currentSensor.sensorId;
    }

    //初始化所有图表
    this.initAllCharts();

    //监听窗口
    window.addEventListener("resize", this.resizeChart);
  },
  //销毁前
  beforeDestroy() {
    // 取消订阅，避免重复订阅
    mqtt.client.unsubscribe(responseTopic, () => {
      // console.log("取消订阅:" + responseTopic);
    });
    if (this.chartInstance) {
      this.chartInstance.dispose();
    }
    if (this.topChart) {
      this.topChart.dispose();
    }
    if (this.middleChart) {
      this.middleChart.dispose();
    }
    if (this.buttomChart) {
      this.buttomChart.dispose();
    }
    window.removeEventListener("resize", this.resizeChart);
  },
  methods: {
    //发送消息的封装，topic:String,message:Object
    sendMessage(topic, message) {
      message = JSON.stringify(message);
      mqtt.client.publish(
        topic,
        message,
        { qos: 0, retain: false },
        function (error) {
          if (error) {
            console.log(error);
          } else {
            console.log("消息已发送");
          }
        }
      );
    },

    //接收消息
    printMesage(topic, message) {
      if (topic == responseTopic) {
        console.log(`接收到话题数据,topic:${topic}`);
        let tempData = JSON.parse(message);
        //接收到所有传感器消息
        if (tempData.action == "getAllSensorsWithHistories") {
          this.sensorData = tempData.data;
          //如果目前有选中的传感器
          if (currentSensorId >= 0) {
            let index = this.sensorData.findIndex((sensor) => {
              return sensor.sensorId == currentSensorId;
            });
            //找到了，还用原来的数据
            if (index >= 0) {
              this.currentSensor = this.sensorData[index];
            }
            //没找到，用第一个
            else {
              this.currentSensor = this.sensorData[0];
            }
          } else {
            this.currentSensor = this.sensorData[0];
          }
          //重置一下目前的id
          currentSensorId = this.currentSensor.sensorId;

          this.setOption();
          console.log("接收到action:getAllSensorsWithHistories");
        }

        //接收到创建传感器的信息
        else if (tempData.action == "createSensor") {
          //发送一次getall，刷新本地数据
          this.dialogVisible = false;
          //发送一次获取所有传感器数据的消息
          let message = {
            action: "getAllSensors",
          };
          this.sendMessage(requestTopic, message);
          this.$message.success("添加传感器成功!");
        }
      }
    },
    initAllCharts() {
      //获取方格区域图形实例
      this.chartInstance = echarts.init(this.$refs.chartRef);
      // 获取三个区域的折线图实例topChart 折线图
      this.topChart = echarts.init(this.$refs.topChart);
      this.middleChart = echarts.init(this.$refs.middleChart);
      this.buttomChart = echarts.init(this.$refs.buttomChart);
      //确保有数据再初始化图表
      // console.log(this.sensorData);
      if (this.sensorData.length > 0) {
        // 全部设置好配置
        this.setOption();
      }
      //监听事件
      this.listenEvents();
    },

    // 统一配置图像配置
    setOption() {
      //初始化方格图
      this.chartInstance.setOption(this.getLeftChartOption());
      // 初始化 topChart 折线图
      this.topChart.setOption(this.getTopChartOption());
      // 初始化 middleChart 折线图
      this.middleChart.setOption(this.getMiddleChartOption());
      // 初始化 buttomChart 折线图
      this.buttomChart.setOption(this.getButtomChartOption());
    },

    // 处理粉尘数据
    getTopChartOption() {
      return {
        title: {
          text: "粉尘浓度变化",
          left: "center",
        },
        tooltip: {
          trigger: "axis",
          formatter: (params) => {
            const date = new Date(params[0].value[0]);
            const time = echarts.format.formatTime("hh:mm:ss", date);
            const dustValue = params[0].value[1];
            return `时间: ${time}<br>粉尘浓度: ${dustValue} 毫克/立方米`;
          },
        },
        xAxis: {
          type: "time", // 时间轴
          axisLabel: {
            formatter: (value) => {
              return echarts.format.formatTime("hh:mm:ss", value); // 格式化显示时分秒
            },
          },
          name: "时间",
        },
        yAxis: {
          type: "value",
          name: "毫克/立方米", // Y 轴单位
          nameTextStyle: {
            fontSize: 14, // 单位字体大小
            fontWeight: "bold", // 单位字体加粗
          },
        },
        series: [
          {
            name: "粉尘浓度",
            data: this.currentSensor.sensorHistories.map((history) => [
              new Date(history.startTime).getTime(), // 时间戳
              history.dust, // 粉尘浓度
            ]),
            type: "line",
            smooth: true, // 平滑曲线
            symbol: "circle", // 显示数据点
            symbolSize: 6, // 数据点大小
            itemStyle: {
              color: (params) => {
                // 根据 dust 值动态设置颜色
                return params.value[1] >= maxDust ? "red" : "blue";
              },
            },
            lineStyle: {
              color: (params) => {
                // 根据 dust 值动态设置线段颜色
                return params.value[1] >= maxDust ? "red" : "blue";
              },
            },
          },
        ],
      };
    },

    // 处理温度数据
    getMiddleChartOption() {
      return {
        title: {
          text: "温度变化",
          left: "center",
        },
        tooltip: {
          trigger: "axis",
          formatter: (params) => {
            const date = new Date(params[0].value[0]);
            const time = echarts.format.formatTime("hh:mm:ss", date);
            const temperature = params[0].value[1];
            return `时间: ${time}<br>环境温度: ${temperature} 度`;
          },
        },
        xAxis: {
          type: "time", // 时间轴
          axisLabel: {
            formatter: (value) => {
              return echarts.format.formatTime("hh:mm:ss", value); // 格式化显示时分秒
            },
          },
          name: "时间",
        },
        yAxis: {
          type: "value",
          name: "度", // Y 轴单位
          nameTextStyle: {
            fontSize: 14, // 单位字体大小
            fontWeight: "bold", // 单位字体加粗
          },
        },
        series: [
          {
            name: "环境温度",
            data: this.currentSensor.sensorHistories.map((history) => [
              new Date(history.startTime).getTime(), // 时间戳
              history.temperature, // 粉尘浓度
            ]),
            type: "line",
            smooth: true, // 平滑曲线
            symbol: "circle", // 显示数据点
            symbolSize: 6, // 数据点大小
            itemStyle: {
              color: "blue",
            },
            lineStyle: {
              color: "#999999",
            },
          },
        ],
      };
    },

    // 湿度变化
    getButtomChartOption() {
      return {
        title: {
          text: "粉尘浓度变化",
          left: "center",
        },
        tooltip: {
          trigger: "axis",
          formatter: (params) => {
            const date = new Date(params[0].value[0]);
            const time = echarts.format.formatTime("hh:mm:ss", date);
            const humidity = params[0].value[1];
            return `时间: ${time}<br>环境湿度: ${humidity} %`;
          },
        },
        xAxis: {
          type: "time", // 时间轴
          axisLabel: {
            formatter: (value) => {
              return echarts.format.formatTime("hh:mm:ss", value); // 格式化显示时分秒
            },
          },
          name: "时间",
        },
        yAxis: {
          type: "value",
          name: " %", // Y 轴单位
          nameTextStyle: {
            fontSize: 14, // 单位字体大小
            fontWeight: "bold", // 单位字体加粗
          },
        },
        series: [
          {
            name: "环境湿度",
            data: this.currentSensor.sensorHistories.map((history) => [
              new Date(history.startTime).getTime(), // 时间戳
              history.humidity,
            ]),
            type: "line",
            smooth: true, // 平滑曲线
            symbol: "circle", // 显示数据点
            symbolSize: 6, // 数据点大小
            itemStyle: {
              color: "green",
            },
            lineStyle: {
              color: "#999999",
            },
          },
        ],
      };
    },

    //
    getLeftChartOption() {
      const option = {
        tooltip: {
          trigger: "item",
          position: (point, params, dom, rect, size) => {
            // 获取数据点的逻辑坐标
            const dataPoint = params.data;
            // 将逻辑坐标转换为像素坐标
            const pixelPoint = this.chartInstance.convertToPixel(
              { seriesIndex: params.seriesIndex },
              [dataPoint[0], dataPoint[1]] // 数据点的逻辑坐标 [x, y]
            );
            this.itemPoint[0] = pixelPoint[1] + 85;
            this.itemPoint[1] = pixelPoint[0] + 61;
            // 固定 tooltip 到数据点的像素坐标
            if (pixelPoint) {
              return [
                pixelPoint[0] + 20,
                pixelPoint[1] - size.contentSize[1] / 2,
              ];
            }
            return point; // 如果转换失败，返回鼠标位置
          },
          formatter: function (params) {
            const item = params.data;

            // 使用模板字符串和 HTML 标签美化样式
            return `
            <div style="
              padding: 5px;
              background: linear-gradient(135deg, #f5f7fa, #c3cfe2);
              border-radius: 8px 8px 0px 0px;
              box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
              color: #333;
              font-family: Arial, sans-serif;
              line-height: 1.6;
              z-index:20;
              border:0px;
              width: 300px; /* 设置固定宽度 */
            ">
              <div style="
                font-size: 20px; /* 加大字体 */
                font-weight: bold;
                margin-bottom: 8px;
                color: #2c3e50;
              ">
                传感器ID: ${item[2]}
              </div>
              <div style="margin-bottom: 6px;">
                <span style="color: #e74c3c; font-weight: bold;">灰尘浓度:</span> 
                ${item[3][item[3].length - 1].dust} 毫克/立方米
              </div>
              <div style="margin-bottom: 6px;">
                <span style="color: #3498db; font-weight: bold;">环境温度:</span> 
                ${item[3][item[3].length - 1].temperature} 度
              </div>
              <div style="margin-bottom: 6px;">
                <span style="color: #2ecc71; font-weight: bold;">环境湿度:</span> 
                ${item[3][item[3].length - 1].humidity} %
              </div>
            </div>
          `;
          },
        },
        grid: {
          left: "0%",
          right: "0%",
          top: "0%",
          bottom: "0%",
          containLabel: true,
          borderColor: "#111",
          backgroundColor: "#fff",
          borderWidth: 5,
        },
        xAxis: {
          type: "category",
          data: Array.from({ length: 8 }, (_, i) => i + 1),
          axisLabel: { show: false },
          axisLine: { show: false },
          axisTick: { show: false },
          splitLine: {
            show: true,
            lineStyle: {
              color: "#ccc",
              type: "dashed",
            },
          },
        },
        yAxis: {
          type: "category",
          data: Array.from({ length: 8 }, (_, i) => i + 1),
          axisLabel: { show: false },
          axisLine: { show: false },
          axisTick: { show: false },
          splitLine: {
            show: true,
            lineStyle: {
              color: "#ccc",
              type: "dashed",
            },
          },
        },
        series: [
          {
            name: "Circles",
            type: "scatter",
            symbol: "circle",
            symbolSize: function (params) {
              return params[2] == currentSensorId ? 65 : 50;
            },
            data: this.sensorData.map((item) => [
              item.x,
              item.y,
              item.sensorId,
              item.sensorHistories,
              item.videoSrc, // 视频链接
            ]),
            itemStyle: {
              color: function (params) {
                const item = params.data;
                if (item[3][item[3].length - 1].dust >= maxDust) {
                  return "red";
                } else {
                  return "#3498db";
                }
              },
              opacity: 1,
            },
            emphasis: {
              itemStyle: {},
            },
          },
        ],
      };
      // 设置配置
      return option;
    },

    //界面尺寸变化，调整尺寸
    resizeChart() {
      if (this.chartInstance) {
        this.chartInstance.resize();
        this.topChart.resize();
        this.middleChart.resize();
        this.buttomChart.resize();
      }
    },
    // 监听图表的事件
    listenEvents() {
      // 监听整个画布的点击事件
      this.chartInstance.getZr().on("click", this.blockClick);

      // 监听鼠标悬停事件
      this.chartInstance.on("mouseover", this.itemHover);

      // 监听鼠标离开事件
      this.chartInstance.on("mouseout", this.mouseLeave);
    },

    // 传感器鼠标悬停的事件
    itemHover(params) {
      // console.log("鼠标进入悬停,当前传感器切换");
      if (
        params.componentType === "series" &&
        params.seriesType === "scatter"
      ) {
        const item = params.data;
        let tempCurrent = {
          sensorId: item[2],
          sensorHistories: item[3],
        };
        this.currentSensor = tempCurrent;
        currentSensorId = this.currentSensor.sensorId;
        this.videoShow = true;
        // 高亮显示数据点
        this.chartInstance.dispatchAction({
          type: "highlight",
          seriesIndex: params.seriesIndex,
          dataIndex: params.dataIndex,
        });
      }
    },
    //鼠标离开数据区域事件
    mouseLeave(params) {
      if (
        params.componentType === "series" &&
        params.seriesType === "scatter"
      ) {
        // console.log("鼠标离开数据点");
        this.videoShow = false;
        // 取消高亮显示
        this.chartInstance.dispatchAction({
          type: "downplay",
          seriesIndex: params.seriesIndex,
          dataIndex: params.dataIndex,
        });
      }
    },
    // 方格区域被点击的事件
    blockClick(event) {
      const pointInPixel = [event.offsetX, event.offsetY];
      // 将像素坐标转换为逻辑坐标
      const pointInGrid = this.chartInstance.convertFromPixel(
        { seriesIndex: 0 },
        pointInPixel
      );

      // 如果需要，可以在这里处理空白区域的点击逻辑
      if (pointInGrid && pointInGrid.length === 2) {
        let index = this.sensorData.findIndex((item) => {
          return item.x == pointInGrid[0] && item.y == pointInGrid[1];
        });
        if (index >= 0) {
          return;
        } else {
          this.dialogVisible = true;
          this.clickPoint = [pointInGrid[0], pointInGrid[1]];
        }
      }
    },

    //确认添加传感器
    createSensor() {
      // console.log(this.clickPoint);
      let message = {
        action: "createSensor",
        x: this.clickPoint[0],
        y: this.clickPoint[1],
      };
      this.sendMessage(requestTopic, message);
    },
  },
};
</script>

<style scoped lang="less">
.custom-tooltip {
  padding: 10px;
  background: linear-gradient(135deg, #f5f7fa, #c3cfe2);
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  color: #333;
  font-family: Arial, sans-serif;
  line-height: 1.6;
}
.tooltip-title {
  font-size: 16px;
  font-weight: bold;
  margin-bottom: 8px;
  color: #2c3e50;
}
.tooltip-item {
  margin-bottom: 6px;
}
.tooltip-item.dust {
  color: #e74c3c;
}
.tooltip-item.temperature {
  color: #3498db;
}
.tooltip-item.humidity {
  color: #2ecc71;
}
.home {
  width: 100%;
  height: 100%;
  margin: 0;
  align-items: center;
  display: flex;
  flex-direction: row;
  justify-content: space-around;
  position: relative;
  .video {
    width: 323px;
    padding: 5px 3px 0px 3px;
    position: absolute;
    background: linear-gradient(135deg, #f5f7fa, #c3cfe2);
    border-radius: 0px 0px 8px 8px;
    border: 1px solid #6a5959;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    color: #333;
    font-family: Arial, sans-serif;
    line-height: 1.6;
    z-index: 30;
    video {
      width: 100%;
      z-index: 30;
      height: auto;
    }
  }

  .left {
    margin: 5px 5px 5px 10px;
    width: 950px;
    height: 950px;
    border: 2px solid #74b652;
    box-shadow: 0 0 2px #0830e1;
    border-radius: 10px;
  }

  .right {
    margin: 5px 5px 5px 10px;
    width: 600px;
    height: 950px;
    border-radius: 10px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: space-between;
    box-shadow: 0 0 2px #ff0000;
    border: 2px solid #4b4b4b;
    .top {
      width: 600px;
      height: 300px;
      border-bottom: 2px solid #222;
    }
    .middle {
      width: 600px;
      height: 300px;
      border-bottom: 2px solid #222;
    }
    .buttom {
      width: 600px;
      height: 300px;
    }
  }
}
</style>
