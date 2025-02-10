// src/main/java/com/example/wintersubject/dto/ApiResponse.java

package com.example.wintersubject.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ApiResponse<T> {
    private String action;
    private String message;
    private T data;
}
