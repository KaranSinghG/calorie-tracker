package com.karan.calorietracker.dto.response;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.karan.calorietracker.model.enums.MealType;

public class FoodLogResponseDTO {

    private Long id;
    private Long userId;
    private Long foodId;
    private MealType mealType;
    private BigDecimal quantityInGrams;
    private BigDecimal calories;
    private BigDecimal carbohydrate;
    private BigDecimal protein;
    private BigDecimal fat;
    private LocalDateTime createdAt;

    public FoodLogResponseDTO() {
    }

    public FoodLogResponseDTO(Long id, Long userId, Long foodId, MealType mealType, BigDecimal quantityInGrams,
            BigDecimal calories, BigDecimal carbohydrate, BigDecimal protein, BigDecimal fat,
            LocalDateTime createdAt) {
        this.id = id;
        this.userId = userId;
        this.foodId = foodId;
        this.mealType = mealType;
        this.quantityInGrams = quantityInGrams;
        this.calories = calories;
        this.carbohydrate = carbohydrate;
        this.protein = protein;
        this.fat = fat;
        this.createdAt = createdAt;
    }

    public Long getId() {
        return id;
    }

    public Long getUserId() {
        return userId;
    }

    public Long getFoodId() {
        return foodId;
    }

    public MealType getMealType() {
        return mealType;
    }

    public BigDecimal getQuantityInGrams() {
        return quantityInGrams;
    }

    public BigDecimal getCalories() {
        return calories;
    }

    public BigDecimal getCarbohydrate() {
        return carbohydrate;
    }

    public BigDecimal getProtein() {
        return protein;
    }

    public BigDecimal getFat() {
        return fat;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
}
