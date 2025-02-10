

// MQTT 配置
const options = {
  clean: true,
  connectTimeout: 4000,
  clientId: 'vue_test' + Date.now(),
};

const connectUrl = 'ws://localhost:8083/mqtt';
const client = mqtt.connect(connectUrl, options);

// 确保客户端初始化成功
client.on('connect', () => {
  console.log('连接到 MQTT 服务器！');
});

client.on('error', (err) => {
  console.error('连接失败:', err);
});

// 导出 mqttClient 对象，包含 client 实例
export default {
  client: client
};
