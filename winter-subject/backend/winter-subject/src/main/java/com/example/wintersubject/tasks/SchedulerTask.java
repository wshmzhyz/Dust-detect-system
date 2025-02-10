package com.example.wintersubject.tasks;

import com.example.wintersubject.entity.MoveHistory;
import com.example.wintersubject.entity.Sensor;
import com.example.wintersubject.entity.SensorHistory;
import com.example.wintersubject.entity.Worker;
import com.example.wintersubject.repository.MoveHistoryRepository;
import com.example.wintersubject.repository.SensorHistoryRepository;
import com.example.wintersubject.repository.SensorRepository;
import com.example.wintersubject.repository.WorkerRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.support.MessageBuilder;
import org.springframework.messaging.MessageChannel;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;

@Component
@Slf4j
public class SchedulerTask {

    private final SensorRepository sensorRepository;
    private final SensorHistoryRepository sensorHistoryRepository;
    private final WorkerRepository workerRepository;
    private final MoveHistoryRepository moveHistoryRepository;
    private final Random random = new Random();
    private final ObjectMapper objectMapper;
    private final MessageChannel mqttSensorInboundChannel;
    private final MessageChannel mqttWorkerInboundChannel;

    @Autowired
    public SchedulerTask(SensorRepository sensorRepository,
                         SensorHistoryRepository sensorHistoryRepository,
                         WorkerRepository workerRepository,
                         MoveHistoryRepository moveHistoryRepository,
                         ObjectMapper objectMapper,
                         MessageChannel mqttSensorInboundChannel,
                         MessageChannel mqttWorkerInboundChannel) {
        this.sensorRepository = sensorRepository;
        this.sensorHistoryRepository = sensorHistoryRepository;
        this.workerRepository = workerRepository;
        this.moveHistoryRepository = moveHistoryRepository;
        this.objectMapper = objectMapper;
        this.mqttSensorInboundChannel = mqttSensorInboundChannel;
        this.mqttWorkerInboundChannel = mqttWorkerInboundChannel;
    }

    /**
     * 定时生成传感器历史记录
     * 每隔 1000000 毫秒（约 16.67 分钟）执行一次
     */
    @Scheduled(fixedRate = 15000)
    public void generateSensorHistory() {
        log.info("开始执行 generateSensorHistory 任务");
        try {
            // 获取所有传感器
            List<Sensor> sensors = sensorRepository.findAll();
            log.info("找到 {} 个传感器", sensors.size());

            if (sensors.isEmpty()) {
                log.warn("没有找到任何传感器，跳过历史记录生成");
            } else {
                // 遍历每个传感器并更新其历史记录
                for (Sensor sensor : sensors) {
                    // 生成随机数据
                    float dust = 1 + random.nextFloat() * 14; // (1, 15)
                    float humidity = 50 + random.nextFloat() * 20; // (50, 70)
                    float temperature = 25 + random.nextFloat() * 20; // (25, 45)

                    // 设置开始和结束时间
                    LocalDateTime startTime = LocalDateTime.now();
                    LocalDateTime endTime = startTime.plusSeconds(5);

                    // 创建并保存 SensorHistory
                    SensorHistory sensorHistory = new SensorHistory(null, sensor, startTime, endTime, dust, humidity, temperature);
                    sensorHistoryRepository.save(sensorHistory);
                }
                log.info("成功生成所有传感器的历史记录");
            }

            // 发送 getAllSensors 消息
            sendActionMessage("getAllSensors", mqttSensorInboundChannel);
            log.info("已发送 'getAllSensors' 消息到 mqttSensorInboundChannel");
        } catch (Exception e) {
            log.error("在执行 generateSensorHistory 任务时发生异常", e);
        }
    }

    /**
     * 定时生成工人移动历史记录
     * 每隔 1000000 毫秒（约 16.67 分钟）执行一次
     */
    @Scheduled(fixedRate = 15000)
    @Transactional
    public void generateMoveHistory() {
        log.info("开始执行 generateMoveHistory 任务");
        try {
            // 获取所有工人
            List<Worker> workers = workerRepository.findAll();
            log.info("找到 {} 个工人", workers.size());

            if (workers.isEmpty()) {
                log.warn("没有找到任何工人，跳过移动历史记录生成");
                return; // 如果没有工人，则跳过
            }

            // 随机选择五个不同的工人
            List<Worker> selectedWorkers = getRandomWorkers(workers, 5);
            log.info("随机选择 {} 个工人进行移动", selectedWorkers.size());

            for (Worker worker : selectedWorkers) {
                moveWorker(worker);
            }

            log.info("成功生成所选工人的移动历史记录");

            // 发送 getAllWorkers 消息
            sendActionMessage("getAllWorkers", mqttWorkerInboundChannel);
            log.info("已发送 'getAllWorkers' 消息到 mqttWorkerInboundChannel");
        } catch (Exception e) {
            log.error("在执行 generateMoveHistory 任务时发生异常", e);
        }
    }

    /**
     * 随机选择指定数量的不同工人
     *
     * @param workers       所有工人列表
     * @param numberOfMoves 需要移动的工人数量
     * @return 随机选择的工人列表
     */
    private List<Worker> getRandomWorkers(List<Worker> workers, int numberOfMoves) {
        if (workers.size() <= numberOfMoves) {
            return new ArrayList<>(workers);
        }
        List<Worker> shuffled = new ArrayList<>(workers);
        Collections.shuffle(shuffled, random);
        return shuffled.subList(0, numberOfMoves);
    }

    /**
     * 执行单个工人的移动逻辑
     *
     * @param worker 需要移动的工人
     */
    private void moveWorker(Worker worker) {
        try {
            int currentX = worker.getCurrentAreaX();
            int currentY = worker.getCurrentAreaY();

            // 确定新的位置在范围 (0,7) 内
            int[][] directions = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}}; // 右, 左, 下, 上
            int[] move = directions[random.nextInt(directions.length)];
            int newX = currentX + move[0];
            int newY = currentY + move[1];

            if (newX < 0 || newX > 7 || newY < 0 || newY > 7) {
                return; // 如果超出范围，则跳过
            }

            // 设置开始和结束时间
            LocalDateTime startTime = LocalDateTime.now();
            LocalDateTime endTime = startTime.plusSeconds(5);

            // 获取工人最新的 MoveHistory 记录，按 endTime 倒序
            Optional<MoveHistory> lastMoveHistoryOpt = moveHistoryRepository.findTopByWorkerOrderByEndTimeDesc(worker);
            Float previousCumulativeDust = 0f;
            if (lastMoveHistoryOpt.isPresent()) {
                previousCumulativeDust = lastMoveHistoryOpt.get().getCumulativeDust();
            }

            // 生成本次移动的粉尘量 (1, 15)
            float dustInhaledThisMove = 1 + random.nextFloat() * 14; // (1, 15)

            // 计算新的累计粉尘量
            Float newCumulativeDust = previousCumulativeDust + dustInhaledThisMove;

            // 更新工人的当前位置
            worker.setCurrentAreaX(newX);
            worker.setCurrentAreaY(newY);
            workerRepository.save(worker); // 在事务内，save 足够

            // 创建并保存 MoveHistory，记录新的位置和累计粉尘量
            MoveHistory moveHistory = new MoveHistory(null, worker, newX, newY, startTime, endTime, newCumulativeDust);
            moveHistoryRepository.save(moveHistory);
        } catch (Exception e) {
            // 异常处理逻辑（记录异常）
            log.error("移动工人 ID={} 时发生异常", worker.getWorkerId(), e);
        }
    }

    /**
     * 发送包含特定 action 的消息到指定的 MessageChannel
     *
     * @param action  要发送的 action 类型
     * @param channel 目标 MessageChannel
     */
    private void sendActionMessage(String action, MessageChannel channel) {
        try {
            Map<String, Object> messageMap = new HashMap<>();
            messageMap.put("action", action);
            String payload = objectMapper.writeValueAsString(messageMap);

            org.springframework.messaging.Message<String> message = MessageBuilder.withPayload(payload)
                    .setHeader("mqtt_topic", determineTopic(action))
                    .build();

            boolean sent = channel.send(message);
            if (sent) {
                log.info("成功发送 '{}' 消息到 channel", action);
            } else {
                log.warn("未能发送 '{}' 消息到 channel", action);
            }
        } catch (Exception e) {
            log.error("发送 '{}' 消息到 channel 时发生异常", action, e);
        }
    }

    /**
     * 根据 action 类型确定发送的 MQTT 主题
     *
     * @param action 动作类型
     * @return 对应的 MQTT 主题
     */
    private String determineTopic(String action) {
        if ("getAllSensors".equals(action)) {
            return "sensor/request"; // 请替换为实际的传感器请求主题
        } else if ("getAllWorkers".equals(action)) {
            return "worker/request"; // 请替换为实际的工人请求主题
        } else {
            return "default/topic"; // 默认主题
        }
    }
}
