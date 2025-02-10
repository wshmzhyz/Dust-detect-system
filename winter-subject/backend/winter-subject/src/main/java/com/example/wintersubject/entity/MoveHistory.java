// src/main/java/com/example/wintersubject/entity/MoveHistory.java

package com.example.wintersubject.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.Entity;
import lombok.*;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "move_history", indexes = {
        @Index(name = "idx_worker_time", columnList = "worker_id, start_time, end_time"),
        @Index(name = "idx_position_time", columnList = "x, y, start_time, end_time")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
public class MoveHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "move_history_id")
    private Long moveHistoryId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "worker_id", nullable = false)
    @JsonBackReference
    private Worker worker;

    @Column(name = "x", nullable = false)
    private Integer x;

    @Column(name = "y", nullable = false)
    private Integer y;

    @Column(name = "start_time", nullable = false)
    private LocalDateTime startTime;

    @Column(name = "end_time", nullable = false)
    private LocalDateTime endTime;

    // 累计吸入粉尘
    @Column(name = "cumulative_dust", nullable = false)
    private Float cumulativeDust = 0f;
}
