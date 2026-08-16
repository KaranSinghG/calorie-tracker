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
    @NotNull(message = "Amount is required")
    @DecimalMin(value = "0.1", message = "Amount must be greater than or equal to 0.1")
    private BigDecimal amount;
    @NotNull(message = "Unit is required")
    private QuantityType unit;
    @NotNull(message = "Meal Type is required")
    private MealType mealType;

    public FoodLogRequestDTO() {
    }

    public FoodLogRequestDTO(Long userId, Long foodId, BigDecimal amount, QuantityType unit, MealType mealType) {
        this.userId = userId;
        this.foodId = foodId;
        this.amount = amount;
        this.unit = unit;
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

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public QuantityType getUnit() {
        return unit;
    }

    public void setUnit(QuantityType unit) {
        this.unit = unit;
    }

    public MealType getMealType() {
        return mealType;
    }

    public void setMealType(MealType mealType) {
        this.mealType = mealType;
    }
}
