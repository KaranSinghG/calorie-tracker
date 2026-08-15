package com.karan.calorietracker.model.enums;

public enum QuantityType {
    GRAMS("Grams"),
    QUANTITY("Items");

    private final String displayName;

    QuantityType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
