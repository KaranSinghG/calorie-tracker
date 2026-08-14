package com.karan.calorietracker.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.karan.calorietracker.model.Food;

public interface FoodRepository extends JpaRepository<Food, Long> {

	boolean existsByName(String name);

}
