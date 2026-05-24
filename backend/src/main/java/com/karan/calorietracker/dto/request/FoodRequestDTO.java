package com.karan.calorietracker.dto.request;

import java.math.BigDecimal;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class FoodRequestDTO {
    
    @NotBlank(message = "Food name is required")
    private String name;
    @NotNull(message = "Calories is required")
    @DecimalMin(value = "0", message = "Calories must be greater than or equal to 0")
    private BigDecimal calories;
    @NotNull(message = "Carbohydrate is required")
    @DecimalMin(value = "0", message = "Carbohydrate must be greater than or equal to 0")
    private BigDecimal carbohydrate;
    @NotNull(message = "Protein is required")
    @DecimalMin(value = "0", message = "Protein must be greater than or equal to 0")
    private BigDecimal protein;
    @NotNull(message = "Fat is required")
    @DecimalMin(value = "0", message = "Fat must be greater than or equal to 0")
    private BigDecimal fat;

    public FoodRequestDTO() {
    }

    public FoodRequestDTO(String name, BigDecimal calories, BigDecimal carbohydrate, BigDecimal protein, BigDecimal fat) {
        this.name = name;
        this.calories = calories;
        this.carbohydrate = carbohydrate;
        this.protein = protein;
        this.fat = fat;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public BigDecimal getCalories() {
        return calories;
    }

    public void setCalories(BigDecimal calories) {
        this.calories = calories;
    }

    public BigDecimal getCarbohydrate() {
        return carbohydrate;
    }

    public void setCarbohydrate(BigDecimal carbohydrate) {
        this.carbohydrate = carbohydrate;
    }

    public BigDecimal getProtein() {
        return protein;
    }

    public void setProtein(BigDecimal protein) {
        this.protein = protein;
    }

    public BigDecimal getFat() {
        return fat;
    }

    public void setFat(BigDecimal fat) {
        this.fat = fat;
    }
}
