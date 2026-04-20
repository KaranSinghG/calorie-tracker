package com.karan.calorietracker.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.karan.calorietracker.model.Food;

@Repository
public interface FoodRepository extends JpaRepository<Food, Long> {
	
}
