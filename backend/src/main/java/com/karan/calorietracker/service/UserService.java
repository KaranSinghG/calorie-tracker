package com.karan.calorietracker.service;

import java.util.List;
import java.util.Optional;

import com.karan.calorietracker.model.User;

public interface UserService {
    
    User registerUser(User user);
    Optional<User> findByEmail(String email);
    Optional<User> findById(Long id);
    List<User> findAll();

}
