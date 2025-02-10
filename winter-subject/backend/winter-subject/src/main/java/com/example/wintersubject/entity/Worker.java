// src/main/java/com/example/wintersubject/entity/Worker.java

package com.example.wintersubject.entity;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import lombok.*;
import jakarta.persistence.*;
import java.util.List;
@Entity
@Table(name = "worker")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Worker {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "worker_id")
    private Long workerId;

    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @Column(name = "current_area_x", nullable = false)
    private Integer currentAreaX;

    @Column(name = "current_area_y", nullable = false)
    private Integer currentAreaY;

    @OneToMany(mappedBy = "worker", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JsonManagedReference
    private List<MoveHistory> moveHistories;
}
