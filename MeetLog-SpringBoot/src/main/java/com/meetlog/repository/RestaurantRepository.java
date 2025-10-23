package com.meetlog.repository;

import com.meetlog.dto.restaurant.RestaurantDto;
import com.meetlog.dto.restaurant.RestaurantSearchRequest;
import com.meetlog.model.Restaurant;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Optional;

@Mapper
public interface RestaurantRepository {
    Optional<Restaurant> findById(@Param("restaurantId") Long restaurantId);

    Optional<RestaurantDto> findDtoById(@Param("restaurantId") Long restaurantId);

    List<RestaurantDto> search(RestaurantSearchRequest request);

    int countSearch(RestaurantSearchRequest request);

    List<RestaurantDto> findByOwnerId(@Param("ownerId") Long ownerId);

    void insert(Restaurant restaurant);

    void update(Restaurant restaurant);

    void delete(@Param("restaurantId") Long restaurantId);

    void updateStatus(@Param("restaurantId") Long restaurantId, @Param("status") String status);

    boolean existsByName(@Param("name") String name);
}
