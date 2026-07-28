package com.karan.calorietracker.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import com.karan.calorietracker.model.User;

public interface UserRepository extends JpaRepository<User, Long> {
	
    Optional<User> findByEmail(String email);
}
