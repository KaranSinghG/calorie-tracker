package com.karan.calorietracker.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.karan.calorietracker.model.FoodLog;

@Repository
public interface FoodLogRepository extends JpaRepository<FoodLog, Long> {
	
}
