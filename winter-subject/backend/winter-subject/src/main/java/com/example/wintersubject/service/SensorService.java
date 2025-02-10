

package com.example.wintersubject.service;
import com.example.wintersubject.entity.Sensor;
import com.example.wintersubject.entity.SensorHistory;
import com.example.wintersubject.repository.SensorHistoryRepository;
import com.example.wintersubject.repository.SensorRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

@Service
public class SensorService {

    private final SensorRepository sensorRepository;
    private final SensorHistoryRepository sensorHistoryRepository;
    @Autowired
    public SensorService(SensorRepository sensorRepository, SensorHistoryRepository sensorHistoryRepository) {
        this.sensorRepository = sensorRepository;
        this.sensorHistoryRepository=sensorHistoryRepository;
    }

    /**
     * 创建传感器，同时创建传感器历史记录，返回创建的传感器
     *
     * @param currentAreaX  当前区域X坐标
     * @param currentAreaY  当前区域Y坐标
     * @return 创建的传感器
     */
    @Transactional
    public Sensor createSensor(Integer currentAreaX, Integer currentAreaY) {
        // 创建并保存Sensor
        Sensor sensor = new Sensor();
        sensor.setCreateTime(LocalDateTime.now());
        sensor.setX(currentAreaX);
        sensor.setY(currentAreaY);
        sensor.setVideoSrc("fake_video_src");  // 可以根据需要进行参数化
        Sensor savedSensor = sensorRepository.save(sensor);

        // 生成随机值
        float dust = generateRandomFloat(1, 15);
        float humidity = generateRandomFloat(50, 70);
        float temperature = generateRandomFloat(25, 45);

        // 设置时间
        LocalDateTime startTime = LocalDateTime.now();
        LocalDateTime endTime = startTime.plusSeconds(5);  // 根据用户的代码

        // 创建并保存SensorHistory
        SensorHistory sensorHistory = new SensorHistory();
        sensorHistory.setSensor(savedSensor);
        sensorHistory.setStartTime(startTime);
        sensorHistory.setEndTime(endTime);
        sensorHistory.setDust(dust);
        sensorHistory.setHumidity(humidity);
        sensorHistory.setTemperature(temperature);

        sensorHistoryRepository.save(sensorHistory);

        return savedSensor;
    }

    /**
     * 获取所有传感器及其历史记录
     *
     * @return 传感器列表，包含历史记录
     */
    public List<Sensor> getAllSensorsWithHistories() {
        return sensorRepository.findAll();
    }

    /**
     * 生成指定范围内的随机浮点数
     *
     * @param min 最小值（包含）
     * @param max 最大值（包含）
     * @return 随机浮点数
     */
    private float generateRandomFloat(int min, int max) {
        return ThreadLocalRandom.current().nextFloat() * (max - min) + min;
    }
}
