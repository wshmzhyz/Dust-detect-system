

package com.example.wintersubject.service;

import com.example.wintersubject.entity.MoveHistory;
import com.example.wintersubject.entity.Worker;
import com.example.wintersubject.repository.MoveHistoryRepository;
import com.example.wintersubject.repository.WorkerRepository;
import jakarta.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

import java.util.concurrent.ThreadLocalRandom;

@Service
public class WorkerService {

    @Autowired
    private WorkerRepository workerRepository;

    @Autowired
    private MoveHistoryRepository moveHistoryRepository;

    /**
     * 创建工人，同时创建移动轨迹，返回创建的工人
     *
     * @param name          工人姓名
     * @param currentAreaX  当前区域X坐标
     * @param currentAreaY  当前区域Y坐标
     * @return 创建的工人
     */
    @Transactional
    public Worker createWorker(String name, Integer currentAreaX, Integer currentAreaY) {
        // 创建工人
        Worker worker = new Worker();
        worker.setName(name);
        worker.setCurrentAreaX(currentAreaX);
        worker.setCurrentAreaY(currentAreaY);
        Worker savedWorker = workerRepository.save(worker);

        // 生成随机的移动时间（10到20秒之间）
        int additionalSeconds = 10 + ThreadLocalRandom.current().nextInt(11); // 10 <= seconds < 21
        LocalDateTime startTime = LocalDateTime.now();
        LocalDateTime endTime = startTime.plusSeconds(additionalSeconds);

        // 创建移动轨迹
        MoveHistory moveHistory = new MoveHistory();
        moveHistory.setWorker(savedWorker); // 设置关联的 Worker
        moveHistory.setX(currentAreaX);
        moveHistory.setY(currentAreaY);
        moveHistory.setStartTime(startTime);
        moveHistory.setEndTime(endTime);
        moveHistoryRepository.save(moveHistory);

        return savedWorker;
    }


    /**
     * 获取所有工人及其移动历史
     *
     * @return 包含移动历史的工人列表
     */
    @Transactional
    public List<Worker> getAllWorkersWithMoveHistories() {
        return workerRepository.findAll();
    }

}

