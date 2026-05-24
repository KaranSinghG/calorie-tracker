package com.karan.calorietracker.service;

import com.karan.calorietracker.dto.request.LoginRequestDTO;

public interface AuthService {
    
    String login(LoginRequestDTO loginRequest);
}
