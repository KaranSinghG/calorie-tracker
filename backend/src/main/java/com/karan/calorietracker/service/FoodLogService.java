package com.karan.calorietracker.service;

import java.time.LocalDate;
import java.util.List;

import com.karan.calorietracker.dto.request.FoodLogRequestDTO;
import com.karan.calorietracker.dto.request.FoodLogUpdateRequestDTO;
import com.karan.calorietracker.dto.response.DailySummaryResponseDTO;
import com.karan.calorietracker.dto.response.FoodLogResponseDTO;

public interface FoodLogService {
    
    FoodLogResponseDTO logFood(FoodLogRequestDTO foodLogRequestDTO);

    DailySummaryResponseDTO getDailySummary(Long userId, LocalDate date);

    void deleteFoodLog(Long foodLogId, Long userId);

    List<FoodLogResponseDTO> getFoodLogByDate(Long userId, LocalDate date);

    FoodLogResponseDTO updateFoodLog(Long userId, Long foodLogId, FoodLogUpdateRequestDTO foodLogRequestDTO);

}
