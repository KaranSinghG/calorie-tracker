package com.karan.calorietracker.controller;

import java.time.LocalDate;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.karan.calorietracker.dto.request.FoodLogRequestDTO;
import com.karan.calorietracker.dto.response.DailySummaryResponseDTO;
import com.karan.calorietracker.dto.response.FoodLogResponseDTO;
import com.karan.calorietracker.model.User;
import com.karan.calorietracker.service.FoodLogService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/food-logs")
public class FoodLogController {

    private final FoodLogService foodLogService;

    FoodLogController(FoodLogService foodLogService) {
        this.foodLogService = foodLogService;
    }

    @PostMapping("/log")
    public ResponseEntity<FoodLogResponseDTO> logFood(@RequestBody @Valid FoodLogRequestDTO foodLogRequestDTO) {
        FoodLogResponseDTO responseDto =  foodLogService.logFood(foodLogRequestDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(responseDto);
    }

    @GetMapping("/summary")
    public ResponseEntity<DailySummaryResponseDTO> getDailySummary(
            @RequestParam LocalDate date) {
        User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long userId = user.getId();
        DailySummaryResponseDTO summary = foodLogService.getDailySummary(userId, date);
        return ResponseEntity.ok(summary);
    }

}
