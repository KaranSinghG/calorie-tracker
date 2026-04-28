package com.karan.calorietracker.dto.request;

import com.karan.calorietracker.model.enums.ActivityLevel;
import com.karan.calorietracker.model.enums.Gender;
import com.karan.calorietracker.model.enums.GoalType;

public class UserRequestDTO {
    
    private String username;
    private String email;
    private String password;
    private String confirmPassword;
    private Integer age;
    private Gender gender;
    private Double weight;
    private Double height;
    private ActivityLevel activityLevel;
    private GoalType goalType;


    public UserRequestDTO() {
    }

    public UserRequestDTO(String username, String email, String password, String confirmPassword, Integer age,
            Gender gender, Double weight, Double height, ActivityLevel activityLevel, GoalType goalType) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.confirmPassword = confirmPassword;
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getConfirmPassword() {
        return confirmPassword;
    }

    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
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
