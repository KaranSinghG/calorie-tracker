package com.karan.calorietracker.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.karan.calorietracker.model.User;
import com.karan.calorietracker.model.enums.ActivityLevel;
import com.karan.calorietracker.model.enums.Gender;
import com.karan.calorietracker.model.enums.GoalType;
import com.karan.calorietracker.model.enums.Role;
import com.karan.calorietracker.repository.UserRepository;

@Configuration
public class DataSeeder {

    @Bean
    public CommandLineRunner seedAdmin(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        return args -> {
            if(userRepository.findByEmail("admin@calorietracker.com").isEmpty()) {
                User admin = new User();
                admin.setUsername("admin");
                admin.setPassword(passwordEncoder.encode("admin123"));
                admin.setRole(Role.ADMIN);
                admin.setEmail("admin@calorietracker.com");
                admin.setAge(30);
                admin.setGender(Gender.OTHER);
                admin.setWeight(70.0);
                admin.setHeight(175.0);
                admin.setActivityLevel(ActivityLevel.VERY_ACTIVE);
                admin.setGoalType(GoalType.MAINTAINING);
                userRepository.save(admin);
            }
        };
    }
}
