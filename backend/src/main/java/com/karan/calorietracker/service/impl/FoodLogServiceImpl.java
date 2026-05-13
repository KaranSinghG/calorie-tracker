package com.karan.calorietracker.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;

import org.springframework.stereotype.Service;

import com.karan.calorietracker.dto.request.FoodLogRequestDTO;
import com.karan.calorietracker.dto.response.FoodLogResponseDTO;
import com.karan.calorietracker.mapper.FoodLogMapper;
import com.karan.calorietracker.model.Food;
import com.karan.calorietracker.model.FoodLog;
import com.karan.calorietracker.model.User;
import com.karan.calorietracker.repository.FoodLogRepository;
import com.karan.calorietracker.service.FoodLogService;
import com.karan.calorietracker.service.FoodService;
import com.karan.calorietracker.service.UserService;

@Service
public class FoodLogServiceImpl implements FoodLogService {

    private final UserService userService;
    private final FoodService foodService;
    private final FoodLogRepository foodLogRepository;

    FoodLogServiceImpl(UserService userService, FoodService foodService, FoodLogRepository foodLogRepository) {
        this.userService = userService;
        this.foodService = foodService;
        this.foodLogRepository = foodLogRepository;
    }

    @Override
    public FoodLogResponseDTO logFood(FoodLogRequestDTO foodLogRequestDTO) {
        User user = userService.findById(foodLogRequestDTO.getUserId());

        Food food = foodService.findById(foodLogRequestDTO.getFoodId());
        FoodLog foodLog = FoodLogMapper.toEntity(foodLogRequestDTO, user, food, 
            food.getCalories().multiply(foodLogRequestDTO.getQuantityInGrams()).divide(new BigDecimal(100), 2, RoundingMode.HALF_UP),
            food.getCarbohydrate().multiply(foodLogRequestDTO.getQuantityInGrams()).divide(new BigDecimal(100), 2, RoundingMode.HALF_UP),
            food.getProtein().multiply(foodLogRequestDTO.getQuantityInGrams()).divide(new BigDecimal(100), 2, RoundingMode.HALF_UP),
            food.getFat().multiply(foodLogRequestDTO.getQuantityInGrams()).divide(new BigDecimal(100), 2, RoundingMode.HALF_UP));
        foodLogRepository.save(foodLog);
        return FoodLogMapper.toDTO(foodLog);
    }
    
}
