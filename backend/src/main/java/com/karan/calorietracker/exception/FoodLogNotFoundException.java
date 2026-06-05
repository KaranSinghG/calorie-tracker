package com.karan.calorietracker.exception;

public class FoodLogNotFoundException extends RuntimeException {
    public FoodLogNotFoundException(String message) {
        super(message);
    }
}
