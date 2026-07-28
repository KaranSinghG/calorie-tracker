package com.karan.calorietracker.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.karan.calorietracker.model.FoodLog;

public interface FoodLogRepository extends JpaRepository<FoodLog, Long> {

    @Query("SELECT SUM(fl.proteinConsumed), SUM(fl.carbohydrateConsumed), SUM(fl.fatConsumed),SUM(fl.caloriesConsumed) "
            +
            "FROM FoodLog fl " +
            "WHERE fl.user.id = :userId AND fl.createdAt >= :startOfDay AND fl.createdAt < :endOfDay")
    Object[] getDailySummary(@Param("userId") Long userId, @Param("startOfDay") LocalDateTime startOfDay,
            @Param("endOfDay") LocalDateTime endOfDay);

    List<FoodLog> findByUserIdAndCreatedAtBetween(Long userId, LocalDateTime startDateTime, LocalDateTime endDateTime);
}
