package com.karan.calorietracker.mapper;

import com.karan.calorietracker.dto.request.UserRequestDTO;
import com.karan.calorietracker.dto.response.UserResponseDTO;
import com.karan.calorietracker.model.User;

public class UserMapper {
    
    public static User toEntity(UserRequestDTO dto){
        User user = new User();
        user.setUsername(dto.getUsername());
        user.setEmail(dto.getEmail());
        user.setPassword(dto.getPassword());
        user.setAge(dto.getAge());
        user.setHeight(dto.getHeight());
        user.setWeight(dto.getWeight());
        user.setGender(dto.getGender());
        user.setGoalType(dto.getGoalType());
        user.setActivityLevel(dto.getActivityLevel());
        return user;
    }

    public static UserResponseDTO toResponseDto(User user){
        UserResponseDTO responseDTO = new UserResponseDTO(user.getId(), user.getUsername(), user.getEmail(), user.getAge(), user.getGender(), user.getWeight(), user.getHeight(),
                user.getActivityLevel(), user.getGoalType(), user.getCreatedAt());
        return responseDTO;
    }

}
