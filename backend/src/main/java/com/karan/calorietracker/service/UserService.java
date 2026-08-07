package com.karan.calorietracker.service;

import java.util.List;

import com.karan.calorietracker.dto.request.UserUpdateRequestDTO;
import com.karan.calorietracker.model.User;

public interface UserService {
    
    User registerUser(User user);
    User findByEmail(String email);
    User findById(Long id);
    List<User> findAll();
    User updateUser(Long id, UserUpdateRequestDTO updateRequestDTO);

}
