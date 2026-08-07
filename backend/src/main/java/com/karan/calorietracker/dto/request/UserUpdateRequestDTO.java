package com.karan.calorietracker.dto.request;

import com.karan.calorietracker.model.enums.ActivityLevel;
import com.karan.calorietracker.model.enums.Gender;
import com.karan.calorietracker.model.enums.GoalType;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class UserUpdateRequestDTO {

    @NotBlank(message = "Username is required")
    private String username;
    @NotNull(message = "Age is required")
    @Min(value = 1, message = "Age must be greater than 0")
    private Integer age;
    @NotNull(message = "Gender is required")
    private Gender gender;
    @NotNull(message = "Weight is required")
    @DecimalMin(value = "1.0", message = "Weight must be greater than or equal to 1.0")
    private Double weight;
    @NotNull(message = "Height is required")
    @DecimalMin(value = "1.0", message = "Height must be greater than or equal to 1.0")
    private Double height;
    @NotNull(message = "Activity Level is required")
    private ActivityLevel activityLevel;
    @NotNull(message = "Goal Type is required")
    private GoalType goalType;

    public UserUpdateRequestDTO() {
    }

    public UserUpdateRequestDTO(String username, Integer age, Gender gender, Double weight, Double height,
            ActivityLevel activityLevel, GoalType goalType) {
        this.username = username;
        this.age = age;
        this.gender = gender;
        this.weight = weight;
        this.height = height;
        this.activityLevel = activityLevel;
        this.goalType = goalType;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public Gender getGender() {
        return gender;
    }

    public void setGender(Gender gender) {
        this.gender = gender;
    }

    public Double getWeight() {
        return weight;
    }

    public void setWeight(Double weight) {
        this.weight = weight;
    }

    public Double getHeight() {
        return height;
    }

    public void setHeight(Double height) {
        this.height = height;
    }

    public ActivityLevel getActivityLevel() {
        return activityLevel;
    }

    public void setActivityLevel(ActivityLevel activityLevel) {
        this.activityLevel = activityLevel;
    }

    public GoalType getGoalType() {
        return goalType;
    }

    public void setGoalType(GoalType goalType) {
        this.goalType = goalType;
    }

}