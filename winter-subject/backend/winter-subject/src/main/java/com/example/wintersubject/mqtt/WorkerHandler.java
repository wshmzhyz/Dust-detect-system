package com.example.wintersubject.mqtt;
import com.example.wintersubject.config.MqttConfig;
import com.example.wintersubject.config.MqttProperties;
import com.example.wintersubject.dto.ApiResponse;
import com.example.wintersubject.entity.MoveHistory;
import com.example.wintersubject.entity.Worker;
import com.example.wintersubject.repository.MoveHistoryRepository;
import com.example.wintersubject.repository.WorkerRepository;
import com.example.wintersubject.service.WorkerService;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.annotation.ServiceActivator;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.stereotype.Component;

import java.sql.SQLOutput;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
@Slf4j
public class WorkerHandler {

    @Autowired
    private WorkerService workerService;  // 工人服务

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private MessageChannel mqttWorkerResponseChannel;

    @Autowired
    private MqttProperties mqttProperties;

    @Autowired
    private MoveHistoryRepository moveHistoryRepository;

    @Autowired
    private WorkerRepository workerRepository;

    @Autowired
    private MqttConfig mqttConfig;
    // 处理工人消息
    @ServiceActivator(inputChannel = "mqttWorkerInboundChannel")
    public void handleWorkerMessage(Message<String> message) {
        try {
            String payload = message.getPayload();
            log.info("接收到工人消息: {}", payload);

            Map<String, Object> msgMap = objectMapper.readValue(payload, Map.class);
            String action = (String) msgMap.get("action");

            if (action == null) {
                log.warn("消息中缺少 'action' 字段");
                return;
            }

            switch (action) {
                case "createWorker":
                    // 创建工人
//                {
//                    "action": "createWorker",
//                        "name":"turenhua",
//                        "currentAreaX":20,
//                        "currentAreaY":10
//                }
                    String name = (String) msgMap.get("name");
                    Integer x = (Integer) msgMap.get("currentAreaX");
                    Integer y = (Integer) msgMap.get("currentAreaY");
                    Worker worker= workerService.createWorker(name, x, y);
                    sendResponse("createWorker", "工人创建成功", worker, mqttProperties.getWorkerResTopic());
                    break;
                case "getAllWorkers":
                    // 获取所有工人及其移动历史
                    List<Worker> allWorkersWithMoveHistories = workerService.getAllWorkersWithMoveHistories();
                    sendResponse("getAllWorkers", "所有工人及其移动历史列表获取成功", allWorkersWithMoveHistories, mqttProperties.getWorkerResTopic());
                    break;


                default:
                    log.warn("未知的 action 类型: {}", action);
            }
        } catch (Exception e) {
            log.error("处理工人消息时发生异常", e);
        }
    }

    private void sendResponse(String action, String message, Object data,String topic) {
        try {
            ApiResponse<Object> response = new ApiResponse<>(action, message, data);
            String responsePayload = objectMapper.writeValueAsString(response);
            log.info("发送响应消息至：{}, action: {}", topic, action);

            org.springframework.messaging.Message<String> mqttMessage = org.springframework.messaging.support.MessageBuilder
                    .withPayload(responsePayload)
                    .setHeader("mqtt_topic", topic)
                    .build();
            mqttWorkerResponseChannel.send(mqttMessage);
        } catch (Exception e) {
            log.error("发送响应消息时发生异常", e);
        }
    }
}


