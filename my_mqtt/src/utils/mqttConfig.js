
const options = {
  // WebSocket 连接地址
  protocol: 'ws', // 使用 WebSocket 协议
  port: 9001, // 连接 WebSocket 端口
  host: 'ws://localhost', // Docker 容器的 IP 或主机地址
  clientId: 'vue-client-' + Math.random().toString(16).substr(2, 8), // 用随机字符串生成唯一 clientId
};

// 创建 MQTT 客户端
const mqttClient = mqtt.connect(options);

// 设置连接成功后的回调
mqttClient.on('connect', () => {
  console.log('Connected to MQTT Broker via WebSocket');
  // 订阅某个 topic
  mqttClient.subscribe('topic/worker', (err) => {
    if (err) {
      console.error('Failed to subscribe:', err);
    } else {
      console.log('Subscribed to topic/worker');
    }
  });
});

// 设置接收消息的回调
mqttClient.on('message', (topic, message) => {
  console.log(`Received message on topic ${topic}:`, message.toString());
});

// 导出 mqttClient
export default mqttClient;
