package com.example.wintersubject.repository;


import com.example.wintersubject.entity.Sensor;
import com.example.wintersubject.entity.SensorHistory;
import org.springframework.data.jpa.repository.JpaRepository;


import java.util.List;


public interface SensorHistoryRepository extends JpaRepository<SensorHistory, Long> {
    List<SensorHistory> findBySensor(Sensor sensor);
}