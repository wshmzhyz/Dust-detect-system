<template>
  <div class="home">
    <canvas ref="canvas" class="canvas"></canvas>
    <div class="left" ref="chartRef" id="left"></div>
    <div class="right">
      <div class="top" ref="topChart"></div>
      <div class="middle">
        <span>接尘量预警列表</span>
        <el-table
          :data="warnWorkerList"
          style="width: 98%"
          :border="true"
          max-height="600"
        >
          <el-table-column
            prop="workerId"
            label="工人ID"
            width="100"
            fixed
            sortable
          >
          </el-table-column>
          <el-table-column prop="name" label="姓名" width="140">
          </el-table-column>
          <el-table-column
            prop="cumulativeDust"
            label="累计接尘量"
            width="140"
            sortable
          >
          </el-table-column>

          <el-table-column fixed="right" label="操作" width="180">
            <template slot-scope="scope">
              <el-button
                @click="handleClick(scope.row)"
                type="text"
                size="small"
                >查看接尘量变化</el-button
              >
            </template>
          </el-table-column>
        </el-table>
      </div>
    </div>

    <el-dialog title="添加传感器" :visible.sync="dialogVisible" width="20%">
      <span>{{
        `是否确定在区域:【${clickPoint[0]},${clickPoint[1]}】添加工人？`
      }}</span>
      <el-input v-model="workerName" placeholder="请输入工人姓名"></el-input>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="createWorker" :disabled="!workerName"
          >确 定</el-button
        >
      </span>
    </el-dialog>
  </div>
</template>

<script>
import * as echarts from "echarts";
import mqtt from "@/plugins/mqtt";

const maxDust = 50; // 吸入粉尘浓度阈值
let currentWorkerId = -1;
const requestTopic = "worker/request";
const responseTopic = "worker/response";

export default {
  name: "WorkerManager",
  data() {
    return {
      isClickItem: false,
      workerData: [],
      workerName: "",
      dialogVisible: false,
      currentWorker: {},
      chartInstance: null,
      topChart: null,
      warnWorkerList: [],
      points: [],
      duration: 3000, // 绘制总时间（毫秒）
      startTime: null, // 动画开始时间
      animationFrame: null, // 用于存储 requestAnimationFrame 的 ID
      ctx: null, // Canvas 上下文
      canvasWidth: 950,
      canvasHeight: 950,
      arrowSpacing: 10, // 箭头间隔（像素）
      clickPoint: [],
    };
  },
  watch: {
    points: {
      handler(newVal, oldVal) {
        //只有一个点，不绘制
        this.stopAnimation();
        if (newVal.length <= 1) {
          this.$message.warning("该工人还未移动");
          return;
        }
        //重新绘制路径
        this.startAnimation();
      },
      immediate: false,
    },
    currentWorker: {
      handler(newVal, oldVal) {
        this.setOption();
      },
      immediate: false,
    },
    workerData: {
      handler(newVal, oldVal) {
        this.warnWorkerList = newVal
          .map((item) => {
            const lastMoveHistory =
              item.moveHistories[item.moveHistories.length - 1];
            if (lastMoveHistory.cumulativeDust > maxDust) {
              return {
                name: item.name,
                workerId: item.workerId,
                cumulativeDust: lastMoveHistory.cumulativeDust,
                currentAreaX: item.currentAreaX,
                currentAreaY: item.currentAreaY,
                moveHistories: item.moveHistories,
              };
            }
            return null; // 不满足条件时返回 null
          })
          .filter((item) => item !== null); // 过滤掉 null 值
      },
      immediate: false,
    },
  },
  mounted() {
    //订阅
    mqtt.client.subscribe(responseTopic, () => {
      console.log(`订阅成功,topic:${responseTopic}`);

      //发送一次获取所有传感器数据的消息
      let message = {
        action: "getAllWorkers",
      };
      this.sendMessage(requestTopic, message);
    });
    mqtt.client.on("message", this.printMesage);
    // 初始化所有图表
    this.initAllCharts();
    this.ctx = this.$refs.canvas.getContext("2d");
    // 获取设备像素比
    const ratio = window.devicePixelRatio || 1;

    // 获取Canvas的CSS宽高
    this.canvasWidth = this.$refs.canvas.clientWidth;
    this.canvasHeight = this.$refs.canvas.clientHeight;

    // 设置Canvas的实际像素大小
    this.$refs.canvas.width = this.canvasWidth * ratio;
    this.$refs.canvas.height = this.canvasHeight * ratio;
  },
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
    window.removeEventListener("resize", this.resizeChart);
  },
  methods: {
    createWorker() {
      // console.log(this.clickPoint);
      let message = {
        action: "createWorker",
        name: this.workerName,
        currentAreaX: this.clickPoint[0],
        currentAreaY: this.clickPoint[1],
      };
      this.sendMessage(requestTopic, message);
    },
    // 表格的点击
    handleClick(e) {
      this.currentWorker = e;
      currentWorkerId = this.currentWorker.workerId;
    },

    // 处理数据，添加随机的偏移量
    updateData() {
      for (let i = 0; i < this.workerData.length; i++) {
        const randomOffsetX = Math.random();
        const randomOffsetY = Math.random();
        this.workerData[i].currentAreaX =
          this.workerData[i].currentAreaX + randomOffsetX;
        this.workerData[i].currentAreaY =
          this.workerData[i].currentAreaY + randomOffsetY;
      }
    },

    // 发送消息的封装，topic:String,message:Object
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

    // 接收消息
    printMesage(topic, message) {
      if (topic == responseTopic) {
        console.log(`接收到话题数据,topic:${topic}`);
        let tempData = JSON.parse(message);
        // 接收到所有工人消息
        if (tempData.action == "getAllWorkers") {
          //停止绘画
          this.stopAnimation();
          this.workerData = tempData.data;

          this.updateData();
          // 如果目前有选中的工人
          if (currentWorkerId >= 0) {
            let index = this.workerData.findIndex((worker) => {
              return worker.workerId == currentWorkerId;
            });
            // 找到了，还用原来的数据
            if (index >= 0) {
              this.currentWorker = this.workerData[index];
            }
            // 没找到，用第一个
            else {
              this.currentWorker = this.workerData[0];
            }
          } else {
            this.currentWorker = this.workerData[0];
          }
          // 重置一下目前的id
          currentWorkerId = this.currentWorker.workerId;
          this.setOption();
          //console.log("接收到action:getAllSensorsWithHistories");
        } else if (tempData.action == "createWorker") {
          //发送一次getall，刷新本地数据
          this.dialogVisible = false;
          //发送一次获取所有传感器数据的消息
          let message = {
            action: "getAllWorkers",
          };
          this.sendMessage(requestTopic, message);
          this.$message.success("添加工人成功!");
        }
      }
    },

    //初始化表格
    initAllCharts() {
      // 获取方格区域图形实例
      this.chartInstance = echarts.init(this.$refs.chartRef);
      this.topChart = echarts.init(this.$refs.topChart);
      // 确保有数据再初始化图表
      if (this.workerData.length > 0) {
        // 全部设置好配置
        this.setOption();
      }
      // 监听事件
      this.listenEvents();
    },

    // 统一配置图像配置
    setOption() {
      // 初始化方格图
      this.chartInstance.setOption(this.getLeftChartOption());
      // 初始化 topChart 折线图
      this.topChart.setOption(this.getTopChartOption());
    },

    // 处理接尘数据
    getTopChartOption() {
      return {
        title: {
          text: "累计接尘量变化",
          left: "center",
        },
        tooltip: {
          trigger: "axis",
          formatter: (params) => {
            const date = new Date(params[0].value[0]);
            const time = echarts.format.formatTime("hh:mm:ss", date);
            const cumulativeDust = params[0].value[1];
            return `时间: ${time}<br>累计接尘量: ${cumulativeDust} 毫克`;
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
          name: "毫克", // Y 轴单位
          nameTextStyle: {
            fontSize: 14, // 单位字体大小
            fontWeight: "bold", // 单位字体加粗
          },
        },
        series: [
          {
            name: "粉尘浓度",
            data: this.currentWorker.moveHistories.map((history) => [
              new Date(history.startTime).getTime(), // 时间戳
              history.cumulativeDust, // 粉尘浓度
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

    getLeftChartOption() {
      const option = {
        tooltip: {
          trigger: "item",
          formatter: function (params) {
            const item = params.data;
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
                width: 200px;
              ">
                <div style="
                  font-size: 20px;
                  font-weight: bold;
                  margin-bottom: 8px;
                  color: #2c3e50;
                ">
                  工人ID: ${item[2]}
                </div>
                <div style="margin-bottom: 6px;">
                  <span style="color: #e74c3c; font-weight: bold;">工人姓名:</span>
                  ${item[4]}
                </div>
                <div style="margin-bottom: 6px;">
                  <span style="color: #3498db; font-weight: bold;">累计接尘量:</span>
                  ${item[3][item[3].length - 1].cumulativeDust} 毫克
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
          borderWidth: 1,
        },
        xAxis: {
          type: "value", // 保持 value 类型
          min: 0, // 设置最小值
          max: 8, // 设置最大值
          interval: 1, // 设置刻度间隔为 1
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
          type: "value", // 保持 value 类型
          min: 0, // 设置最小值
          max: 8, // 设置最大值
          interval: 1, // 设置刻度间隔为 1
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
              return params[2] == currentWorkerId ? 20 : 10;
            },
            data: this.workerData.map((item) => {
              return [
                item.currentAreaX,
                item.currentAreaY,
                item.workerId,
                item.moveHistories,
                item.name,
              ];
            }),
            itemStyle: {
              color: function (params) {
                const item = params.data;
                if (item[3][item[3].length - 1].cumulativeDust >= maxDust) {
                  return "red";
                } else {
                  return "#3498db";
                }
              },
              opacity: 1,
            },
            emphasis: {
              itemStyle: {
                opacity: 1,
              },
              symbolSize: 20,
            },
          },
        ],
      };
      return option;
    },

    // 界面尺寸变化，调整尺寸
    resizeChart() {
      if (this.chartInstance) {
        this.chartInstance.resize();
        this.topChart.resize();
      }
    },

    // 监听图表的事件
    listenEvents() {
      // 监听鼠标悬停事件
      this.chartInstance.on("mouseover", this.itemHover);
      // 监听整个画布的点击事件
      this.chartInstance.getZr().on("click", this.blockClick);
      // 监听鼠标离开事件
      this.chartInstance.on("mouseout", this.mouseLeave);
      // 监听鼠标离开事件
      this.chartInstance.on("click", this.itemClick);
    },
    // 方格区域被点击的事件
    blockClick(event) {
      if (this.isClickItem) {
        return;
      }
      this.dialogVisible = true;
      const pointInPixel = [event.offsetX, event.offsetY];
      // 将像素坐标转换为逻辑坐标
      const pointInGrid = this.chartInstance.convertFromPixel(
        { seriesIndex: 0 },
        pointInPixel
      );

      // 如果需要，可以在这里处理空白区域的点击逻辑
      if (pointInGrid && pointInGrid.length === 2) {
        this.clickPoint[0] = Math.floor(pointInGrid[0]);
        this.clickPoint[1] = Math.floor(pointInGrid[1]);
      }
    },

    //工人被点击
    itemClick(params) {
      let lastPoint = [
        parseFloat(params.data[0].toFixed(2)),
        parseFloat(params.data[1].toFixed(2)),
      ];
      this.getRealPoints(lastPoint);
    },

    getRealPoints(lastPoint) {
      let points = [];
      points = this.currentWorker.moveHistories.map((item) => {
        return [item.x + 0.5, item.y + 0.5];
      });
      points[points.length - 1] = lastPoint;
      this.points = points;
    },

    // 传感器鼠标悬停的事件
    itemHover(params) {
      this.isClickItem = true;
      //console.log("鼠标进入悬停,当前工人切换");
      if (
        params.componentType === "series" &&
        params.seriesType === "scatter"
      ) {
        const item = params.data;
        let tempCurrent = {
          workerId: item[2],
          moveHistories: item[3],
        };
        this.currentWorker = tempCurrent;
        currentWorkerId = this.currentWorker.workerId;
        // 高亮显示数据点
        this.chartInstance.dispatchAction({
          type: "highlight",
          seriesIndex: params.seriesIndex,
          dataIndex: params.dataIndex,
        });
      }
    },
    // 鼠标离开数据区域事件
    mouseLeave(params) {
      this.isClickItem = false;
      if (
        params.componentType === "series" &&
        params.seriesType === "scatter"
      ) {
        // 取消高亮显示
        this.chartInstance.dispatchAction({
          type: "downplay",
          seriesIndex: params.seriesIndex,
          dataIndex: params.dataIndex,
        });
      }
    },
    // 开始动画
    startAnimation() {
      this.startTime = null;
      this.animationFrame = requestAnimationFrame(this.animate);
    },

    // 停止动画并清空画布
    stopAnimation() {
      if (this.animationFrame) {
        cancelAnimationFrame(this.animationFrame);
        this.animationFrame = null; // 重置动画帧ID，防止重复取消
      }
      if (this.ctx) {
        this.ctx.clearRect(0, 0, this.canvasWidth, this.canvasHeight); // 清空画布
      }
    },

    // 绘制箭头
    drawArrow(x, y, angle) {
      this.ctx.save();
      this.ctx.translate(x, y);
      this.ctx.rotate(angle);
      this.ctx.beginPath();
      this.ctx.moveTo(0, 0);
      this.ctx.lineTo(-10, -5);
      this.ctx.lineTo(-10, 5);
      this.ctx.closePath();
      this.ctx.fillStyle = "black";
      this.ctx.fill();
      this.ctx.restore();
    },

    // 绘制路径
    drawPath(progress) {
      // 清空画布
      this.ctx.clearRect(0, 0, this.canvasWidth, this.canvasHeight);
      this.ctx.beginPath();

      // 移动到起点
      const startX = this.points[0][0] * (this.canvasWidth / 8);
      const startY =
        this.canvasHeight - this.points[0][1] * (this.canvasHeight / 8);
      this.ctx.moveTo(startX, startY);

      // 计算总路径长度
      let totalLength = 0;
      for (let i = 1; i < this.points.length; i++) {
        const x1 = this.points[i - 1][0] * (this.canvasWidth / 8);
        const y1 =
          this.canvasHeight - this.points[i - 1][1] * (this.canvasHeight / 8);
        const x2 = this.points[i][0] * (this.canvasWidth / 8);
        const y2 =
          this.canvasHeight - this.points[i][1] * (this.canvasHeight / 8);
        const dx = x2 - x1;
        const dy = y2 - y1;
        totalLength += Math.sqrt(dx * dx + dy * dy);
      }

      // 根据进度绘制路径
      let currentLength = totalLength * progress;
      let accumulatedLength = 0;

      for (let i = 1; i < this.points.length; i++) {
        const x1 = this.points[i - 1][0] * (this.canvasWidth / 8);
        const y1 =
          this.canvasHeight - this.points[i - 1][1] * (this.canvasHeight / 8);
        const x2 = this.points[i][0] * (this.canvasWidth / 8);
        const y2 =
          this.canvasHeight - this.points[i][1] * (this.canvasHeight / 8);
        const dx = x2 - x1;
        const dy = y2 - y1;
        const segmentLength = Math.sqrt(dx * dx + dy * dy);

        if (accumulatedLength + segmentLength >= currentLength) {
          const t = (currentLength - accumulatedLength) / segmentLength;
          const x = x1 + dx * t;
          const y = y1 + dy * t;
          this.ctx.lineTo(x, y);
          break;
        } else {
          this.ctx.lineTo(x2, y2);
          accumulatedLength += segmentLength;
        }
      }

      this.ctx.stroke();

      // 绘制箭头
      accumulatedLength = 0;
      for (let i = 1; i < this.points.length; i++) {
        const x1 = this.points[i - 1][0] * (this.canvasWidth / 8);
        const y1 =
          this.canvasHeight - this.points[i - 1][1] * (this.canvasHeight / 8);
        const x2 = this.points[i][0] * (this.canvasWidth / 8);
        const y2 =
          this.canvasHeight - this.points[i][1] * (this.canvasHeight / 8);
        const dx = x2 - x1;
        const dy = y2 - y1;
        const segmentLength = Math.sqrt(dx * dx + dy * dy);
        const angle = Math.atan2(dy, dx);

        for (let j = 0; j < segmentLength; j += this.arrowSpacing) {
          if (accumulatedLength + j <= currentLength) {
            const t = j / segmentLength;
            const x = x1 + dx * t;
            const y = y1 + dy * t;
            this.drawArrow(x, y, angle);
          }
        }

        accumulatedLength += segmentLength;
      }
    },

    // 动画循环
    animate(timestamp) {
      if (!this.startTime) this.startTime = timestamp;
      const elapsed = timestamp - this.startTime;
      const progress = Math.min(elapsed / this.duration, 1);
      this.drawPath(progress);

      if (progress < 1) {
        this.animationFrame = requestAnimationFrame(this.animate);
      } else {
        // 绘制完成后清空画布，等待 1 秒后重新开始
        setTimeout(() => {
          this.startAnimation();
        }, 1000);
      }
    },
  },
};
</script>

<style scoped lang="less">
.home {
  width: 100%;
  height: 100%;
  margin: 0;
  align-items: center;
  display: flex;
  flex-direction: row;
  justify-content: space-around;
  position: relative;

  .canvas {
    position: absolute; /* 绝对定位 */
    top: 8px;
    left: 42px;
    width: 950px;
    height: 950px;
    z-index: 1; /* 确保 canvas 在 left 区域之上 */
  }

  .left {
    margin: 5px 5px 5px 10px;
    width: 950px;
    height: 950px;
    border: 2px solid #74b652;
    box-shadow: 0 0 2px #0830e1;
    border-radius: 10px;
    z-index: 10;
    position: relative; /* 确保 canvas 的定位相对于 left 区域 */
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
      height: 640px;
      padding: 0px 5px;
      display: flex;
      flex-direction: column;
      align-items: center;

      span {
        font-size: 17px;
        font-weight: 700;
        margin-bottom: 5px;
        color: #6a5959;
      }
    }
  }
}
</style>
