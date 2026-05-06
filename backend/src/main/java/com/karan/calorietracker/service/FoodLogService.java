package com.karan.calorietracker.service;

import com.karan.calorietracker.dto.request.FoodLogRequestDTO;
import com.karan.calorietracker.model.FoodLog;

public interface FoodLogService {
    
    FoodLog logFood(FoodLogRequestDTO foodLogRequestDTO);
}
