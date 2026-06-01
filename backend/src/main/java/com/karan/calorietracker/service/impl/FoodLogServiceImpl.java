package com.karan.calorietracker.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import org.springframework.stereotype.Service;

import com.karan.calorietracker.dto.request.FoodLogRequestDTO;
import com.karan.calorietracker.dto.response.DailySummaryResponseDTO;
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

    @Override
    public DailySummaryResponseDTO getDailySummary(Long userId, LocalDate date) {
        LocalDateTime startOfDay = date.atStartOfDay();
        LocalDateTime endOfDay = date.plusDays(1).atStartOfDay();
        Object[] result = foodLogRepository.getDailySummary(userId, startOfDay, endOfDay);
        Object[] summary = result != null ? (Object[]) result[0] : new Object[]{BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO};
        return new DailySummaryResponseDTO(
            summary[0] != null ? ((BigDecimal) summary[0]).setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO,
            summary[1] != null ? ((BigDecimal) summary[1]).setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO,
            summary[2] != null ? ((BigDecimal) summary[2]).setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO,
            summary[3] != null ? ((BigDecimal) summary[3]).setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO,
            date
        );
    }
    
}
