package com.karan.calorietracker.dto.response;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class FoodResponseDTO {
    private Long id;
    private String name;
    private BigDecimal calories;
    private BigDecimal carbohydrates;
    private BigDecimal protein;
    private BigDecimal fat;
    private LocalDateTime createdAt;
    
    public FoodResponseDTO() {
    }

    public FoodResponseDTO(Long id, String name, BigDecimal calories, BigDecimal carbohydrates, BigDecimal protein,
            BigDecimal fat, LocalDateTime createdAt) {
        this.id = id;
        this.name = name;
        this.calories = calories;
        this.carbohydrates = carbohydrates;
        this.protein = protein;
        this.fat = fat;
        this.createdAt = createdAt;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public BigDecimal getCalories() {
        return calories;
    }

    public BigDecimal getCarbohydrates() {
        return carbohydrates;
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