package com.karan.calorietracker.dto.request;

import java.math.BigDecimal;

import com.karan.calorietracker.model.enums.MealType;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;

public class FoodLogUpdateRequestDTO {
    
    @NotNull(message = "Food ID is required")
    private Long foodId;
    @NotNull(message = "Quantity in grams is required")
    @DecimalMin(value = "0.1", message = "Quantity in grams must be greater than or equal to 0.1")
    private BigDecimal quantityInGrams;
    @NotNull(message = "Meal Type is required")
    private MealType mealType;

    public FoodLogUpdateRequestDTO() {
    }

    public FoodLogUpdateRequestDTO(Long foodId, BigDecimal quantityInGrams, MealType mealType) {
        this.foodId = foodId;
        this.quantityInGrams = quantityInGrams;
        this.mealType = mealType;
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
