package com.karan.calorietracker.mapper;

import java.math.BigDecimal;
import java.util.List;

import com.karan.calorietracker.dto.request.FoodLogRequestDTO;
import com.karan.calorietracker.dto.response.FoodLogResponseDTO;
import com.karan.calorietracker.model.Food;
import com.karan.calorietracker.model.FoodLog;
import com.karan.calorietracker.model.User;

public class FoodLogMapper {

    public static FoodLog toEntity(FoodLogRequestDTO dto, User user, Food food, BigDecimal caloriesConsumed,
            BigDecimal carbohydrateConsumed, BigDecimal proteinConsumed, BigDecimal fatConsumed) {
        FoodLog foodLog = new FoodLog();
        foodLog.setFood(food);
        foodLog.setUser(user);
        foodLog.setQuantityInGrams(dto.getAmount());
        foodLog.setMealType(dto.getMealType());
        foodLog.setCaloriesConsumed(caloriesConsumed);
        foodLog.setCarbohydrateConsumed(carbohydrateConsumed);
        foodLog.setProteinConsumed(proteinConsumed);
        foodLog.setFatConsumed(fatConsumed);
        return foodLog;
    }

    public static FoodLogResponseDTO toDTO(FoodLog foodLog) {
        FoodLogResponseDTO dto = new FoodLogResponseDTO(foodLog.getId(), foodLog.getUser().getId(),
                foodLog.getFood().getId(), foodLog.getFood().getName(), foodLog.getMealType(),
                foodLog.getQuantityInGrams(), foodLog.getCaloriesConsumed(), foodLog.getCarbohydrateConsumed(),
                foodLog.getProteinConsumed(), foodLog.getFatConsumed(), foodLog.getCreatedAt());
        return dto;
    }

    public static List<FoodLogResponseDTO> toDTOList(List<FoodLog> foodLogs) {
        return foodLogs.stream().map(FoodLogMapper::toDTO).toList();
    }
}
