package com.karan.calorietracker.model;

import java.math.BigDecimal;

import com.karan.calorietracker.model.enums.MealType;
import com.karan.calorietracker.model.enums.QuantityType;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "food_logs")
public class FoodLog extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "food_id", nullable = false)
    private Food food;

    @Column(name = "meal_type", nullable = false)
    @Enumerated(EnumType.STRING)
    private MealType mealType;

    @Column(name = "quantity_type", nullable = false)
    @Enumerated(EnumType.STRING)
    private QuantityType quantityType;

    @Column(name = "quantity_in_grams", nullable = false, precision = 10, scale = 2)
    private BigDecimal quantityValue;

    @Column(name = "calories_consumed", nullable = false, precision = 10, scale = 2)
    private BigDecimal caloriesConsumed;

    @Column(name = "carbohydrates_consumed", nullable = false, precision = 10, scale = 2)
    private BigDecimal carbohydrateConsumed;

    @Column(name = "proteins_consumed", nullable = false, precision = 10, scale = 2)
    private BigDecimal proteinConsumed;

    @Column(name = "fats_consumed", nullable = false, precision = 10, scale = 2)
    private BigDecimal fatConsumed;

    // Getters and Setters
    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Food getFood() {
        return food;
    }

    public void setFood(Food food) {
        this.food = food;
    }

    public MealType getMealType() {
        return mealType;
    }

    public void setMealType(MealType mealType) {
        this.mealType = mealType;
    }

    public QuantityType getQuantityType() {
        return quantityType;
    }

    public void setQuantityType(QuantityType quantityType) {
        this.quantityType = quantityType;
    }

    public BigDecimal getQuantityValue() {
        return quantityValue;
    }

    public void setQuantityValue(BigDecimal quantityValue) {
        this.quantityValue = quantityValue;
    }

    public BigDecimal getQuantityInGrams() {
        return quantityValue;
    }

    public void setQuantityInGrams(BigDecimal quantityInGrams) {
        this.quantityValue = quantityInGrams;
    }

    public BigDecimal getCaloriesConsumed() {
        return caloriesConsumed;
    }

    public void setCaloriesConsumed(BigDecimal caloriesConsumed) {
        this.caloriesConsumed = caloriesConsumed;
    }

    public BigDecimal getCarbohydrateConsumed() {
        return carbohydrateConsumed;
    }

    public void setCarbohydrateConsumed(BigDecimal carbohydrateConsumed) {
        this.carbohydrateConsumed = carbohydrateConsumed;
    }

    public BigDecimal getProteinConsumed() {
        return proteinConsumed;
    }

    public void setProteinConsumed(BigDecimal proteinConsumed) {
        this.proteinConsumed = proteinConsumed;
    }

    public BigDecimal getFatConsumed() {
        return fatConsumed;
    }

    public void setFatConsumed(BigDecimal fatConsumed) {
        this.fatConsumed = fatConsumed;
    }

}
