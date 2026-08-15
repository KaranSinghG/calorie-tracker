package com.karan.calorietracker.dto.request;

import java.math.BigDecimal;

import com.karan.calorietracker.model.enums.MealType;
import com.karan.calorietracker.model.enums.QuantityType;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;

public class FoodLogRequestDTO {
    
    @NotNull(message = "User ID is required")
    private Long userId;
    @NotNull(message = "Food ID is required")
    private Long foodId;
    @NotNull(message = "Quantity is required")
    @DecimalMin(value = "0.1", message = "Quantity must be greater than or equal to 0.1")
    private BigDecimal quantity;
    @NotNull(message = "Quantity Type is required")
    private QuantityType quantityType;
    @NotNull(message = "Meal Type is required")
    private MealType mealType;

    public FoodLogRequestDTO() {
    }

    public FoodLogRequestDTO(Long userId, Long foodId, BigDecimal quantity, QuantityType quantityType, MealType mealType) {
        this.userId = userId;
        this.foodId = foodId;
        this.quantity = quantity;
        this.quantityType = quantityType;
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

    public BigDecimal getQuantity() {
        return quantity;
    }

    public void setQuantity(BigDecimal quantity) {
        this.quantity = quantity;
    }

    public QuantityType getQuantityType() {
        return quantityType;
    }

    public void setQuantityType(QuantityType quantityType) {
        this.quantityType = quantityType;
    }

    public MealType getMealType() {
        return mealType;
    }

    public void setMealType(MealType mealType) {
        this.mealType = mealType;
    }

    // Backward compatibility: for old API clients using quantityInGrams
    @Deprecated
    public BigDecimal getQuantityInGrams() {
        return quantity;
    }

    @Deprecated
    public void setQuantityInGrams(BigDecimal quantityInGrams) {
        this.quantity = quantityInGrams;
        this.quantityType = QuantityType.GRAMS;
    }

}
