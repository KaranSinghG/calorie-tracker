package com.karan.calorietracker.service;

import com.karan.calorietracker.dto.request.FoodLogRequestDTO;
import com.karan.calorietracker.dto.response.FoodLogResponseDTO;

public interface FoodLogService {
    
    FoodLogResponseDTO logFood(FoodLogRequestDTO foodLogRequestDTO);
}
