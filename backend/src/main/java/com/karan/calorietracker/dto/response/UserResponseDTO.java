package com.karan.calorietracker.dto.response;

import java.time.LocalDateTime;

import com.karan.calorietracker.model.enums.ActivityLevel;
import com.karan.calorietracker.model.enums.Gender;
import com.karan.calorietracker.model.enums.GoalType;

public class UserResponseDTO {
    
    private Long id;
    private String username;
    private String email;
    private Integer age;
    private Gender gender;
    private Double weight;
    private Double height;
    private ActivityLevel activityLevel;
    private GoalType goalType;
    private LocalDateTime createdAt;

    public UserResponseDTO() {
    }

    public UserResponseDTO(Long id, String username, String email, Integer age, Gender gender, Double weight, Double height,
            ActivityLevel activityLevel, GoalType goalType, LocalDateTime createdAt) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.age = age;
        this.gender = gender;
        this.weight = weight;
        this.height = height;
        this.activityLevel = activityLevel;
        this.goalType = goalType;
        this.createdAt = createdAt;
    }

    public Long getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public String getEmail() {
        return email;
    }

    public Integer getAge() {
        return age;
    }

    public Gender getGender() {
        return gender;
    }

    public Double getWeight() {
        return weight;
    }

    public Double getHeight() {
        return height;
    }

    public ActivityLevel getActivityLevel() {
        return activityLevel;
    }

    public GoalType getGoalType() {
        return goalType;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

}
