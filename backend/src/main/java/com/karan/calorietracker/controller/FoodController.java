package com.karan.calorietracker.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.karan.calorietracker.dto.request.FoodRequestDTO;
import com.karan.calorietracker.dto.response.FoodResponseDTO;
import com.karan.calorietracker.mapper.FoodMapper;
import com.karan.calorietracker.model.Food;
import com.karan.calorietracker.service.FoodService;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;


@RestController
@RequestMapping("/foods")
public class FoodController {
    
    private final FoodService foodService;

    public FoodController(FoodService foodService) {
        this.foodService = foodService;
    }

    @PostMapping("/create")
    public ResponseEntity<FoodResponseDTO> createFood(@RequestBody FoodRequestDTO food) {
        Food createdFood = foodService.createFood(FoodMapper.toEntity(food));
        return ResponseEntity.status(HttpStatus.CREATED).body(FoodMapper.toResponseDto(createdFood));
    }

    @GetMapping("/{id}")
    public ResponseEntity<FoodResponseDTO> getFoodById(@PathVariable Long id) {
        return foodService.findById(id).map(FoodMapper::toResponseDto).map(dto -> ResponseEntity.ok(dto))
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/all")
    public ResponseEntity<List<FoodResponseDTO>> getAllFoods() {
        return ResponseEntity.ok(foodService.findAll().stream().map(FoodMapper::toResponseDto).collect(Collectors.toList()));
    }
    
}
