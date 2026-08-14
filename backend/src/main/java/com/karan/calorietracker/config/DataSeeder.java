package com.karan.calorietracker.config;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.karan.calorietracker.model.Food;
import com.karan.calorietracker.model.User;
import com.karan.calorietracker.model.enums.ActivityLevel;
import com.karan.calorietracker.model.enums.Gender;
import com.karan.calorietracker.model.enums.GoalType;
import com.karan.calorietracker.model.enums.Role;
import com.karan.calorietracker.repository.FoodRepository;
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

    @Bean
    public CommandLineRunner seedFoods(FoodRepository foodRepository) {
        return args -> {
            List<Food> missing = defaultFoodCatalog().stream()
                    .filter(food -> !foodRepository.existsByName(food.getName()))
                    .collect(Collectors.toList());
            if (!missing.isEmpty()) {
                foodRepository.saveAll(missing);
            }
        };
    }

    /**
     * Default catalog of everyday Indian diet foods, macros are per 100g (as served).
     * "Chicken Breast" is intentionally excluded so we do not touch the one already present.
     */
    private List<Food> defaultFoodCatalog() {
        return List.of(
                // Grains & breads
                food("Basmati Rice (Cooked)", "130", "25.2", "2.6", "0.3"),
                food("Whole Wheat Roti",      "297", "49.0", "8.3", "7.0"),
                food("Naan",                  "279", "48.9", "8.5", "5.8"),
                food("Idli",                  "151", "27.5", "4.0", "2.1"),
                food("Dosa",                  "198", "36.4", "3.6", "4.0"),
                food("Poha (Beaten Rice)",    "175", "19.5", "3.5", "8.5"),
                food("Upma",                  "170", "24.0", "3.5", "2.2"),
                food("Khichdi",               "120", "21.0", "4.0", "2.5"),
                // Dals & pulses (cooked)
                food("Toor Dal (Cooked)",     "100", "15.5", "6.0", "0.5"),
                food("Moong Dal (Cooked)",    "105", "17.0", "7.0", "0.4"),
                food("Masoor Dal (Cooked)",   "104", "18.0", "9.0", "0.4"),
                food("Chana Dal (Cooked)",    "125", "25.0", "7.7", "1.2"),
                food("Rajma (Kidney Beans)",  "127", "22.8", "8.7", "0.5"),
                food("Chole (Chickpea Curry)","149", "22.0", "8.5", "3.5"),
                food("Sambhar",               "55",  "8.0",  "3.0", "1.5"),
                // Vegetables & curries
                food("Palak Paneer",          "180", "6.0",  "8.0",  "13.0"),
                food("Mixed Vegetable Sabzi", "80",  "10.0", "2.5", "3.5"),
                food("Aloo Sabzi",            "110", "12.0", "1.8", "6.0"),
                food("Bhindi (Okra)",         "65",  "7.5",  "1.9", "0.2"),
                food("Baingan Bharta",        "85",  "7.0",  "1.5", "5.0"),
                // Dairy
                food("Paneer",                "265", "1.6",  "18.0", "20.8"),
                food("Curd (Dahi)",           "61",  "4.7",  "3.5", "3.3"),
                food("Buttermilk",            "62",  "4.5",  "2.0", "1.5"),
                food("Milk (Buffalo)",        "97",  "5.2",  "3.6", "6.6"),
                // Protein
                food("Egg",                   "143", "1.1",  "12.6", "9.5"),
                food("Chicken Curry",         "130", "4.0",  "15.0", "6.0"),
                food("Mutton Curry",          "260", "8.0",  "17.0", "18.0"),
                food("Fish (Fresh Water)",    "150", "0.0",  "17.5", "4.2"),
                // Fruits
                food("Mango",                 "60",  "15.0", "0.8", "0.4"),
                food("Banana",                "89",  "22.8", "1.1", "0.3"),
                food("Guava",                 "68",  "14.9", "2.5", "0.7"),
                food("Dates",                 "282", "75.0", "2.5", "0.4"),
                // Nuts & protein snacks
                food("Peanuts",               "587", "12.5", "25.4", "49.5"),
                food("Almonds",               "579", "21.6", "21.2", "49.5")
        );
    }

    private Food food(String name, String calories, String carbohydrates, String protein, String fat) {
        Food food = new Food();
        food.setName(name);
        food.setCalories(new BigDecimal(calories));
        food.setCarbohydrate(new BigDecimal(carbohydrates));
        food.setProtein(new BigDecimal(protein));
        food.setFat(new BigDecimal(fat));
        return food;
    }
}
