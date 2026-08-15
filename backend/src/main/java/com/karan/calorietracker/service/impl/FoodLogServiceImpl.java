package com.karan.calorietracker.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;

import com.karan.calorietracker.dto.request.FoodLogRequestDTO;
import com.karan.calorietracker.dto.request.FoodLogUpdateRequestDTO;
import com.karan.calorietracker.dto.response.DailySummaryResponseDTO;
import com.karan.calorietracker.dto.response.FoodLogResponseDTO;
import com.karan.calorietracker.exception.FoodLogNotFoundException;
import com.karan.calorietracker.exception.UnauthorizedAccessException;
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
        
        // Calculate actual weight in grams based on quantity type
        BigDecimal quantityInGrams;
        if (foodLogRequestDTO.getQuantityType().equals(com.karan.calorietracker.model.enums.QuantityType.QUANTITY)) {
            // If logging by quantity (items), multiply by per-item weight
            quantityInGrams = foodLogRequestDTO.getQuantity().multiply(food.getPerItemWeight());
        } else {
            // If logging by weight (grams), use quantity directly
            quantityInGrams = foodLogRequestDTO.getQuantity();
        }
        
        // Calculate consumed macros based on actual weight
        BigDecimal caloriesConsumed = food.getCalories().multiply(quantityInGrams).divide(new BigDecimal(100), 2, RoundingMode.HALF_UP);
        BigDecimal carbohydrateConsumed = food.getCarbohydrate().multiply(quantityInGrams).divide(new BigDecimal(100), 2, RoundingMode.HALF_UP);
        BigDecimal proteinConsumed = food.getProtein().multiply(quantityInGrams).divide(new BigDecimal(100), 2, RoundingMode.HALF_UP);
        BigDecimal fatConsumed = food.getFat().multiply(quantityInGrams).divide(new BigDecimal(100), 2, RoundingMode.HALF_UP);
        
        FoodLog foodLog = FoodLogMapper.toEntity(foodLogRequestDTO, user, food, caloriesConsumed, carbohydrateConsumed, proteinConsumed, fatConsumed);
        foodLog.setQuantityInGrams(quantityInGrams);
        foodLog.setQuantityType(foodLogRequestDTO.getQuantityType());
        foodLog.setQuantityValue(foodLogRequestDTO.getQuantity());
        
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

    @Override
    public void deleteFoodLog(Long foodLogId, Long userId) {
        FoodLog foodLog = foodLogRepository.findById(foodLogId)
            .orElseThrow(() -> new FoodLogNotFoundException("Food log not found with id: " + foodLogId));
        if (!foodLog.getUser().getId().equals(userId)) {
            throw new FoodLogNotFoundException("Food log not associated with user: " + userId);
        }
        foodLogRepository.delete(foodLog);
    }

    @Override
    public List<FoodLogResponseDTO> getFoodLogByDate(Long userId, LocalDate date) {
        LocalDateTime startOfDay = date.atStartOfDay();
        LocalDateTime endOfDay = date.plusDays(1).atStartOfDay();
        List<FoodLog> foodLogs = foodLogRepository.findByUserIdAndCreatedAtBetween(userId, startOfDay, endOfDay);
        return FoodLogMapper.toDTOList(foodLogs);
    }

    @Override
    public FoodLogResponseDTO updateFoodLog(Long userId, Long foodLogId, FoodLogUpdateRequestDTO foodLogRequestDTO) {
        FoodLog foodLog = foodLogRepository.findById(foodLogId)
            .orElseThrow(() -> new FoodLogNotFoundException("Food log not found with id: " + foodLogId));
        if (!foodLog.getUser().getId().equals(userId)) {
            throw new UnauthorizedAccessException("Food log not associated with user: " + userId);
        }
        Food newFood = foodService.findById(foodLogRequestDTO.getFoodId());
        foodLog.setFood(newFood);
        foodLog.setQuantityInGrams(foodLogRequestDTO.getQuantityInGrams());
        foodLog.setMealType(foodLogRequestDTO.getMealType());
        foodLog.setCaloriesConsumed(newFood.getCalories().multiply(foodLogRequestDTO.getQuantityInGrams()).divide(new BigDecimal(100), 2, RoundingMode.HALF_UP));
        foodLog.setCarbohydrateConsumed(newFood.getCarbohydrate().multiply(foodLogRequestDTO.getQuantityInGrams()).divide(new BigDecimal(100), 2, RoundingMode.HALF_UP));
        foodLog.setProteinConsumed(newFood.getProtein().multiply(foodLogRequestDTO.getQuantityInGrams()).divide(new BigDecimal(100), 2, RoundingMode.HALF_UP));
        foodLog.setFatConsumed(newFood.getFat().multiply(foodLogRequestDTO.getQuantityInGrams()).divide(new BigDecimal(100), 2, RoundingMode.HALF_UP));
        foodLogRepository.save(foodLog);
        return FoodLogMapper.toDTO(foodLog);
    }
    
}
