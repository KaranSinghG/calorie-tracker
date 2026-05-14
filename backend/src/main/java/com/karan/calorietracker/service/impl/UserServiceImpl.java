package com.karan.calorietracker.service.impl;

import java.util.List;


import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.karan.calorietracker.exception.UserNotFoundException;
import com.karan.calorietracker.model.User;
import com.karan.calorietracker.model.enums.Role;
import com.karan.calorietracker.repository.UserRepository;
import com.karan.calorietracker.service.UserService;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    UserServiceImpl(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public User registerUser(User user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRole(Role.USER);
        return userRepository.save(user);
    }

    @Override
    public User findByEmail(String email) {
        if (email == null) {
            throw new UserNotFoundException("Email cannot be null");
        }
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new UserNotFoundException("User not found"));
    }

    @Override
    public User findById(Long id) {
       if (id == null) {
            throw new UserNotFoundException("User ID cannot be null");
        }
        return userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException("User not found"));
    }

    @Override
    public List<User> findAll() {
        return userRepository.findAll();
    }    
    
}
