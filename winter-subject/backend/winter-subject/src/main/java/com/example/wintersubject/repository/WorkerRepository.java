

package com.example.wintersubject.repository;
import com.example.wintersubject.entity.Worker;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface WorkerRepository extends JpaRepository<Worker, Long> {

    @EntityGraph(attributePaths = "moveHistories")
    List<Worker> findAll();
}
