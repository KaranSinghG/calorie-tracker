package com.karan.calorietracker.service;

import java.util.List;
import java.util.Optional;

import com.karan.calorietracker.model.Food;

public interface FoodService {
    
    Food createFood(Food food);
    Optional<Food> findById(Long id);
    List<Food> findAll();

}
