// src/main/java/com/example/wintersubject/config/MqttProperties.java

package com.example.wintersubject.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Data
@Component
@ConfigurationProperties(prefix = "mqtt")
public class MqttProperties {
    private String brokerUrl;
    private String clientId;
    private String defaultTopic;
    private String workerTopic;
    private String sensorTopic;
    private String workerResTopic;
    private String sensorResTopic;
    private int completionTimeout = 5000; // 默认值
}
