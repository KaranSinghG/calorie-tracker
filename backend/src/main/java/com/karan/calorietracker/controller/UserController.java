package com.karan.calorietracker.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.karan.calorietracker.dto.request.UserRequestDTO;
import com.karan.calorietracker.dto.request.UserUpdateRequestDTO;
import com.karan.calorietracker.dto.response.UserResponseDTO;
import com.karan.calorietracker.exception.UnauthorizedAccessException;
import com.karan.calorietracker.mapper.UserMapper;
import com.karan.calorietracker.model.User;
import com.karan.calorietracker.service.UserService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/users")
public class UserController {
    
    private final UserService userService;

    UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/register")
    public ResponseEntity<UserResponseDTO> registerUser(@RequestBody @Valid UserRequestDTO requestDTO) {
        User createdUser = userService.registerUser(UserMapper.toEntity(requestDTO));
        return ResponseEntity.status(HttpStatus.CREATED).body(UserMapper.toResponseDto(createdUser));
    }

    @GetMapping("/search")
    public ResponseEntity<UserResponseDTO> searchByEmailString(@RequestParam String email) {
        UserResponseDTO userResponse = UserMapper.toResponseDto(userService.findByEmail(email));
        return ResponseEntity.ok(userResponse);
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserResponseDTO> searchById(@PathVariable Long id) {
        UserResponseDTO userResponse = UserMapper.toResponseDto(userService.findById(id));
        return ResponseEntity.ok(userResponse);
    }

    @GetMapping("/all")
    public ResponseEntity<List<UserResponseDTO>> getAllUsers() {
        return ResponseEntity.ok(userService.findAll().stream().map(UserMapper::toResponseDto).collect(Collectors.toList()));
    }

    @PutMapping("/{id}")
    public ResponseEntity<UserResponseDTO> updateUser(@PathVariable Long id,
            @RequestBody @Valid UserUpdateRequestDTO updateRequestDTO) {
        User currentUser = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (!currentUser.getId().equals(id)) {
            throw new UnauthorizedAccessException("You can only update your own profile");
        }
        User updatedUser = userService.updateUser(id, updateRequestDTO);
        return ResponseEntity.ok(UserMapper.toResponseDto(updatedUser));
    }
    
}
