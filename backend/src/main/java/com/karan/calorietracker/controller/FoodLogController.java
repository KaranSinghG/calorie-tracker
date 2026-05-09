package com.karan.calorietracker.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.karan.calorietracker.dto.request.FoodLogRequestDTO;
import com.karan.calorietracker.dto.response.FoodLogResponseDTO;
import com.karan.calorietracker.service.FoodLogService;

@RestController
@RequestMapping("/food-logs")
public class FoodLogController {

    private final FoodLogService foodLogService;

    FoodLogController(FoodLogService foodLogService) {
        this.foodLogService = foodLogService;
    }

    @PostMapping("/log")
    public ResponseEntity<FoodLogResponseDTO> logFood(@RequestBody FoodLogRequestDTO foodLogRequestDTO) {
        FoodLogResponseDTO responseDto =  foodLogService.logFood(foodLogRequestDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(responseDto);
    }

}
