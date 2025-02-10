// src/main/java/com/example/wintersubject/repository/MoveHistoryRepository.java


package com.example.wintersubject.repository;

import com.example.wintersubject.entity.MoveHistory;
import com.example.wintersubject.entity.Worker;
import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface MoveHistoryRepository extends JpaRepository<MoveHistory, Long> {
    // 根据 Worker 实体的 workerId 查询该工人的移动轨迹
    List<MoveHistory> findByWorker(Worker worker);

    // 获取工人最新的 MoveHistory 记录
    Optional<MoveHistory> findTopByWorkerOrderByEndTimeDesc(Worker worker);

}
