package com.example.wintersubject.repository;


import com.example.wintersubject.entity.Sensor;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface SensorRepository extends JpaRepository<Sensor, Long> {

    Optional<Sensor> findByXAndY(Integer x, Integer y);
    @Override
    @EntityGraph(attributePaths = "sensorHistories")
    List<Sensor> findAll();
}