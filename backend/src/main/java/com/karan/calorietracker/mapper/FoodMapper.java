package com.karan.calorietracker.mapper;

import com.karan.calorietracker.dto.request.FoodRequestDTO;
import com.karan.calorietracker.dto.response.FoodResponseDTO;
import com.karan.calorietracker.model.Food;

public class FoodMapper {
    
    public static Food toEntity(FoodRequestDTO dto){
        Food food = new Food();
        food.setName(dto.getName());
        food.setCalories(dto.getCalories());
        food.setCarbohydrates(dto.getCarbohydrates());
        food.setProtein(dto.getProtein());
        food.setFat(dto.getFat());
        return food;
    }

    public static FoodResponseDTO toResponseDto(Food food){
        FoodResponseDTO responseDTO = new FoodResponseDTO(food.getId(), food.getName(), food.getCalories(), food.getCarbohydrates(), food.getProtein(),
                food.getFat(), food.getCreatedAt());
        return responseDTO;
    }
}
