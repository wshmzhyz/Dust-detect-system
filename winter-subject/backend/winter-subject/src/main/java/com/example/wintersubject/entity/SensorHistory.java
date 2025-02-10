package com.example.wintersubject.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import lombok.*;
import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "sensor_history", indexes = {
        @Index(name = "idx_sensor_time", columnList = "sensor_id, start_time, end_time")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SensorHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "sensor_history_id")
    private Long sensorHistoryId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sensor_id", nullable = false)
    @JsonBackReference
    private Sensor sensor;

    @Column(name = "start_time", nullable = false)
    private LocalDateTime startTime;

    @Column(name = "end_time", nullable = false)
    private LocalDateTime endTime;

    @Column(name = "dust", nullable = false)
    private Float dust;

    @Column(name = "humidity", nullable = false)
    private Float humidity;

    @Column(name = "temperature", nullable = false)
    private Float temperature;
}
