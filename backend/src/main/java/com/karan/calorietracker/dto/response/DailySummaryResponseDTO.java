package com.karan.calorietracker.dto.response;

import java.math.BigDecimal;
import java.time.LocalDate;

public class DailySummaryResponseDTO {
    
    private BigDecimal totalProtein;
    private BigDecimal totalCarbohydrate;
    private BigDecimal totalFat;
    private BigDecimal totalCalories;
    private LocalDate date;
    
    public DailySummaryResponseDTO(BigDecimal totalProtein, BigDecimal totalCarbohydrate, BigDecimal totalFat, BigDecimal totalCalories, LocalDate date) {
        this.totalProtein = totalProtein;
        this.totalCarbohydrate = totalCarbohydrate;
        this.totalFat = totalFat;
        this.totalCalories = totalCalories;
        this.date = date;
    }

    public BigDecimal getTotalProtein() {
        return totalProtein;
    }

    public BigDecimal getTotalCarbohydrate() {
        return totalCarbohydrate;
    }

    public BigDecimal getTotalFat() {
        return totalFat;
    }

    public BigDecimal getTotalCalories() {
        return totalCalories;
    }

    public LocalDate getDate() {
        return date;
    }
}
