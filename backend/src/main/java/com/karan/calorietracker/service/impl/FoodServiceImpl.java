package com.karan.calorietracker.service.impl;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.karan.calorietracker.model.Food;
import com.karan.calorietracker.repository.FoodRepository;
import com.karan.calorietracker.service.FoodService;

@Service
public class FoodServiceImpl implements FoodService {

    private final FoodRepository foodRepository;

    FoodServiceImpl(FoodRepository foodRepository) {
        this.foodRepository = foodRepository;
    }

    @Override
    public Food createFood(Food food) {
        return foodRepository.save(food);
    }

    @Override
    public Optional<Food> findById(Long id) {
        return foodRepository.findById(id);
    }

    @Override
    public List<Food> findAll() {
        return foodRepository.findAll();
    }
    
}
