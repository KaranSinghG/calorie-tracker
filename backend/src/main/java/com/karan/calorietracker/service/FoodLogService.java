package com.karan.calorietracker.service;

import java.time.LocalDate;

import com.karan.calorietracker.dto.request.FoodLogRequestDTO;
import com.karan.calorietracker.dto.response.DailySummaryResponseDTO;
import com.karan.calorietracker.dto.response.FoodLogResponseDTO;

public interface FoodLogService {
    
    FoodLogResponseDTO logFood(FoodLogRequestDTO foodLogRequestDTO);

    DailySummaryResponseDTO getDailySummary(Long userId, LocalDate date);
}
