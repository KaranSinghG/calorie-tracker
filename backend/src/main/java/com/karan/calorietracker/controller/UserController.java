package com.karan.calorietracker.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.karan.calorietracker.dto.request.UserRequestDTO;
import com.karan.calorietracker.dto.response.UserResponseDTO;
import com.karan.calorietracker.mapper.UserMapper;
import com.karan.calorietracker.model.User;
import com.karan.calorietracker.service.UserService;

@RestController
@RequestMapping("/users")
public class UserController {
    
    private final UserService userService;

    UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/register")
    public ResponseEntity<UserResponseDTO> registerUser(@RequestBody UserRequestDTO requestDTO) {
        User createdUser = userService.registerUser(UserMapper.toEntity(requestDTO));
        return ResponseEntity.status(HttpStatus.CREATED).body(UserMapper.toResponseDto(createdUser));
    }

    @GetMapping("/search")
    public ResponseEntity<UserResponseDTO> searchByEmailString(@RequestParam String email) {
        return userService.findByEmail(email).map(UserMapper::toResponseDto).map(dto -> ResponseEntity.ok(dto))
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserResponseDTO> searchById(@PathVariable Long id) {
        return userService.findById(id).map(UserMapper::toResponseDto).map(dto -> ResponseEntity.ok(dto))
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/all")
    public ResponseEntity<List<UserResponseDTO>> getAllUsers() {
        return ResponseEntity.ok(userService.findAll().stream().map(UserMapper::toResponseDto).collect(Collectors.toList()));
    }
    
}
