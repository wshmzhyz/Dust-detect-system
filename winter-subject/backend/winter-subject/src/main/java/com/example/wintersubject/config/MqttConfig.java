// src/main/java/com/example/wintersubject/config/MqttConfig.java

package com.example.wintersubject.config;

import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.integration.annotation.ServiceActivator;
import org.springframework.integration.channel.DirectChannel;
import org.springframework.integration.mqtt.core.DefaultMqttPahoClientFactory;
import org.springframework.integration.mqtt.core.MqttPahoClientFactory;
import org.springframework.integration.mqtt.inbound.MqttPahoMessageDrivenChannelAdapter;
import org.springframework.integration.mqtt.outbound.MqttPahoMessageHandler;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.MessageHandler;

@Configuration
public class MqttConfig {

    @Autowired
    private MqttProperties mqttProperties;

    // 定义 MQTT 连接工厂
    @Bean
    public MqttPahoClientFactory mqttClientFactory() {
        DefaultMqttPahoClientFactory factory = new DefaultMqttPahoClientFactory();
        MqttConnectOptions options = new MqttConnectOptions();
        options.setServerURIs(new String[] { mqttProperties.getBrokerUrl() });
        factory.setConnectionOptions(options);
        return factory;
    }



    // 定义接收工人消息的消息通道
    @Bean
    public MessageChannel mqttWorkerInboundChannel() {
        return new DirectChannel();
    }
    // 工人消息的适配器，订阅工人主题
    @Bean
    public MqttPahoMessageDrivenChannelAdapter mqttWorkerInboundAdapter(MqttPahoClientFactory mqttClientFactory) {
        System.out.println("Worker:"+mqttProperties.getWorkerTopic());
        MqttPahoMessageDrivenChannelAdapter adapter =
                new MqttPahoMessageDrivenChannelAdapter("workerClient", mqttClientFactory, mqttProperties.getWorkerTopic());
        adapter.setOutputChannel(mqttWorkerInboundChannel()); // 消息传输到mqttWorkerInboundChannel
        return adapter;
    }



    //发送响应工人消息的消息通道
    @Bean
    public MessageChannel mqttWorkerResponseChannel() {
        return new DirectChannel();  // 用来发送 worker 相关的响应
    }

    // 发送响应工人消息的处理器
    @Bean
    @ServiceActivator(inputChannel = "mqttWorkerResponseChannel")
    public MessageHandler mqttWorkerResponseOutbound() {
        MqttPahoMessageHandler messageHandler = new MqttPahoMessageHandler(mqttProperties.getClientId() + "-outbound", mqttClientFactory());
        messageHandler.setAsync(true);
        messageHandler.setDefaultTopic(mqttProperties.getWorkerResTopic());
        return messageHandler;
    }



    //发送响应传感器消息的消息通道
    @Bean
    public MessageChannel mqttSensorResponseChannel() {
        return new DirectChannel();  // 用来发送 worker 相关的响应
    }

    // 发送响应传感器消息的处理器
    @Bean
    @ServiceActivator(inputChannel = "mqttSensorResponseChannel")
    public MessageHandler mqttSensorResponseOutbound() {
        MqttPahoMessageHandler messageHandler = new MqttPahoMessageHandler(
                mqttProperties.getClientId() + "-outbound", mqttClientFactory());
        messageHandler.setAsync(true);
        messageHandler.setDefaultTopic(mqttProperties.getSensorResTopic());
        return messageHandler;
    }




    // 定义接收传感器消息的消息通道
    @Bean
    public MessageChannel mqttSensorInboundChannel() {
        return new DirectChannel();
    }
    // 传感器消息的适配器，订阅传感器主题
    @Bean
    public MqttPahoMessageDrivenChannelAdapter mqttSensorInboundAdapter(MqttPahoClientFactory mqttClientFactory) {
        System.out.println("Sensor:"+mqttProperties.getSensorTopic());
        MqttPahoMessageDrivenChannelAdapter adapter =
                new MqttPahoMessageDrivenChannelAdapter("sensorClient", mqttClientFactory, mqttProperties.getSensorTopic());
        adapter.setOutputChannel(mqttSensorInboundChannel()); // 消息传输到mqttSensorInboundChannel
        return adapter;
    }


}

