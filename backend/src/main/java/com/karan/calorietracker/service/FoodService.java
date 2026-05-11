package com.karan.calorietracker.service;

import java.util.List;

import com.karan.calorietracker.model.Food;

public interface FoodService {
    
    Food createFood(Food food);
    Food findById(Long id);
    List<Food> findAll();

}
