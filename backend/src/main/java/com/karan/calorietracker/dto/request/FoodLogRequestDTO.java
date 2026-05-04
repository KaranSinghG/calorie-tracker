package com.karan.calorietracker.dto.request;

import java.math.BigDecimal;

import com.karan.calorietracker.model.enums.MealType;

public class FoodLogRequestDTO {
    
    private Long userId;
    private Long foodId;
    private BigDecimal quantityInGrams;
    private MealType mealType;

    public FoodLogRequestDTO() {
    }

    public FoodLogRequestDTO(Long userId, Long foodId, BigDecimal quantityInGrams, MealType mealType) {
        this.userId = userId;
        this.foodId = foodId;
        this.quantityInGrams = quantityInGrams;
        this.mealType = mealType;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getFoodId() {
        return foodId;
    }

    public void setFoodId(Long foodId) {
        this.foodId = foodId;
    }

    public BigDecimal getQuantityInGrams() {
        return quantityInGrams;
    }

    public void setQuantityInGrams(BigDecimal quantityInGrams) {
        this.quantityInGrams = quantityInGrams;
    }

    public MealType getMealType() {
        return mealType;
    }

    public void setMealType(MealType mealType) {
        this.mealType = mealType;
    }

}
