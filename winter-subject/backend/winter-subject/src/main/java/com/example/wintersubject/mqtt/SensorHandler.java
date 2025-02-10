package com.example.wintersubject.mqtt;
import com.example.wintersubject.config.MqttConfig;
import com.example.wintersubject.config.MqttProperties;
import com.example.wintersubject.dto.ApiResponse;
import com.example.wintersubject.entity.Sensor;
import com.example.wintersubject.repository.SensorRepository;
import com.example.wintersubject.service.SensorService;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.annotation.ServiceActivator;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.stereotype.Component;
import java.util.Map;
import java.util.Optional;
import java.util.List;


@Component
@Slf4j
public class SensorHandler {

    @Autowired
    private SensorService sensorService;  // 传感器服务

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private MessageChannel mqttSensorResponseChannel;

    @Autowired
    private MqttProperties mqttProperties;

    @Autowired
    private SensorRepository sensorRepository;

    @Autowired
    private MqttConfig mqttConfig;

    // 处理传感器消息
    @ServiceActivator(inputChannel = "mqttSensorInboundChannel")
    public void handleSensorMessage(Message<String> message) {
        try {
            String payload = message.getPayload();
            log.info("接收到传感器消息: {}", payload);

            Map<String, Object> msgMap = objectMapper.readValue(payload, Map.class);
            String action = (String) msgMap.get("action");

            if (action == null) {
                log.warn("消息中缺少 'action' 字段");
                return;
            }

            switch (action) {
                // 创建传感器
                case "createSensor":
                    Integer x = (Integer) msgMap.get("x");
                    Integer y = (Integer) msgMap.get("y");
                    Optional<Sensor> sensorOptional = sensorRepository.findByXAndY(x, y);
                    if (sensorOptional.isPresent()) {
                        // 传感器已存在
                        log.info("传感器已存在: x={}, y={}", x, y);
                        sendResponse("createSensor", "传感器已存在", null, mqttProperties.getSensorResTopic());
                    } else {
                        try {
                            // 创建新的传感器
                            Sensor sensor = sensorService.createSensor(x, y);
                            log.info("成功创建传感器: x={}, y={}", x, y);
                            sendResponse("createSensor", "已经创建Sensor", sensor, mqttProperties.getSensorResTopic());
                        } catch (Exception e) {
                            log.error("创建传感器时发生异常: x={}, y={}", x, y, e);
                            sendResponse("createSensor", "创建传感器失败", null, mqttProperties.getSensorResTopic());
                        }
                    }
                    break;

                // 查询所有传感器及其历史记录
                case "getAllSensors":
                    log.info("处理传感器动作: getAllSensors");
                    try {
                        List<Sensor> allSensorsWithHistories = sensorService.getAllSensorsWithHistories();
                        sendResponse("getAllSensorsWithHistories", "所有传感器及其历史记录获取成功", allSensorsWithHistories, mqttProperties.getSensorResTopic());
                    } catch (Exception e) {
                        log.error("查询所有传感器时发生异常", e);
                        sendResponse("getAllSensorsWithHistories", "查询所有传感器失败", null, mqttProperties.getSensorResTopic());
                    }
                    break;

                default:
                    log.warn("未知的 action 类型: {}", action);
            }
        } catch (Exception e) {
            log.error("处理传感器消息时发生异常", e);
        }
    }

    private void sendResponse(String action, String message, Object data, String topic) {
        try {
            ApiResponse<Object> response = new ApiResponse<>(action, message, data);
            String responsePayload = objectMapper.writeValueAsString(response);
            log.info("发送响应消息至：{}, action: {}", topic, action);

            org.springframework.messaging.Message<String> mqttMessage = org.springframework.messaging.support.MessageBuilder
                    .withPayload(responsePayload)
                    .setHeader("mqtt_topic", topic)
                    .build();
            mqttSensorResponseChannel.send(mqttMessage);
        } catch (Exception e) {
            log.error("发送响应消息时发生异常", e);
        }
    }
}

