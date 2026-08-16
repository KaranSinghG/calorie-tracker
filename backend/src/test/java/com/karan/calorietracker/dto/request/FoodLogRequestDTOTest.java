package com.karan.calorietracker.dto.request;

import static org.assertj.core.api.Assertions.assertThat;

import java.math.BigDecimal;

import org.junit.jupiter.api.Test;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.karan.calorietracker.model.enums.MealType;
import com.karan.calorietracker.model.enums.QuantityType;

class FoodLogRequestDTOTest {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Test
    void shouldDeserializeAmountAndUnitFields() throws Exception {
        String json = "{\"userId\":1,\"foodId\":2,\"amount\":250,\"unit\":\"GRAMS\",\"mealType\":\"BREAKFAST\"}";

        FoodLogRequestDTO dto = objectMapper.readValue(json, FoodLogRequestDTO.class);

        assertThat(dto.getAmount()).isEqualByComparingTo(new BigDecimal("250"));
        assertThat(dto.getUnit()).isEqualTo(QuantityType.GRAMS);
        assertThat(dto.getMealType()).isEqualTo(MealType.BREAKFAST);
    }

    @Test
    void shouldDeserializeItemUnitFields() throws Exception {
        String json = "{\"userId\":1,\"foodId\":2,\"amount\":3,\"unit\":\"QUANTITY\",\"mealType\":\"LUNCH\"}";

        FoodLogRequestDTO dto = objectMapper.readValue(json, FoodLogRequestDTO.class);

        assertThat(dto.getAmount()).isEqualByComparingTo(new BigDecimal("3"));
        assertThat(dto.getUnit()).isEqualTo(QuantityType.QUANTITY);
        assertThat(dto.getMealType()).isEqualTo(MealType.LUNCH);
    }

    @Test
    void shouldDeserializeFoodCreationPayloadWithPerItemWeight() throws Exception {
        String json = "{\"name\":\"Apple\",\"calories\":52,\"carbohydrate\":14,\"protein\":0.3,\"fat\":0.2,\"perItemWeight\":180}";

        FoodRequestDTO dto = objectMapper.readValue(json, FoodRequestDTO.class);

        assertThat(dto.getName()).isEqualTo("Apple");
        assertThat(dto.getCalories()).isEqualByComparingTo(new BigDecimal("52"));
        assertThat(dto.getCarbohydrate()).isEqualByComparingTo(new BigDecimal("14"));
        assertThat(dto.getProtein()).isEqualByComparingTo(new BigDecimal("0.3"));
        assertThat(dto.getFat()).isEqualByComparingTo(new BigDecimal("0.2"));
        assertThat(dto.getPerItemWeight()).isEqualByComparingTo(new BigDecimal("180"));
    }
}
