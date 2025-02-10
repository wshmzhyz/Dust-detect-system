package com.example.wintersubject.Worker;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @ClassName: Worker
 * @Author: WPY
 * @Date: 2025/1/5 21:37
 * @Version: 1.0
 * @Description:
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Worker {
    private Integer id;
    private String name;
    private Integer zone;
    private Double dust_inhale;
}
