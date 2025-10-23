package com.meetlog.service;

import com.meetlog.dto.restaurant.*;
import com.meetlog.model.Restaurant;
import com.meetlog.repository.RestaurantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class RestaurantService {

    private final RestaurantRepository restaurantRepository;

    public RestaurantDto getRestaurant(Long restaurantId) {
        return restaurantRepository.findDtoById(restaurantId)
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));
    }

    public Map<String, Object> searchRestaurants(RestaurantSearchRequest request) {
        List<RestaurantDto> restaurants = restaurantRepository.search(request);
        int total = restaurantRepository.countSearch(request);

        Map<String, Object> result = new HashMap<>();
        result.put("restaurants", restaurants);
        result.put("total", total);
        result.put("page", request.getPage() != null ? request.getPage() : 1);
        result.put("size", request.getLimit());
        result.put("totalPages", (int) Math.ceil((double) total / request.getLimit()));

        return result;
    }

    public List<RestaurantDto> getMyRestaurants(Long ownerId) {
        return restaurantRepository.findByOwnerId(ownerId);
    }

    @Transactional
    public RestaurantDto createRestaurant(RestaurantCreateRequest request, Long ownerId) {
        if (restaurantRepository.existsByName(request.getName())) {
            throw new RuntimeException("Restaurant name already exists");
        }

        Restaurant restaurant = Restaurant.builder()
                .ownerId(ownerId)
                .name(request.getName())
                .category(request.getCategory())
                .description(request.getDescription())
                .address(request.getAddress())
                .addressDetail(request.getAddressDetail())
                .latitude(request.getLatitude())
                .longitude(request.getLongitude())
                .phone(request.getPhone())
                .operatingHours(request.getOperatingHours())
                .priceRange(request.getPriceRange())
                .imageUrl(request.getImageUrl())
                .menuInfo(request.getMenuInfo())
                .facilities(request.getFacilities())
                .parkingInfo(request.getParkingInfo())
                .capacity(request.getCapacity())
                .status("ACTIVE")
                .build();

        restaurantRepository.insert(restaurant);

        return restaurantRepository.findDtoById(restaurant.getRestaurantId())
                .orElseThrow(() -> new RuntimeException("Failed to create restaurant"));
    }

    @Transactional
    public RestaurantDto updateRestaurant(Long restaurantId, RestaurantUpdateRequest request, Long userId) {
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));

        if (!restaurant.isOwnedBy(userId)) {
            throw new RuntimeException("Unauthorized to update this restaurant");
        }

        if (request.getName() != null) restaurant.setName(request.getName());
        if (request.getCategory() != null) restaurant.setCategory(request.getCategory());
        if (request.getDescription() != null) restaurant.setDescription(request.getDescription());
        if (request.getAddress() != null) restaurant.setAddress(request.getAddress());
        if (request.getAddressDetail() != null) restaurant.setAddressDetail(request.getAddressDetail());
        if (request.getLatitude() != null) restaurant.setLatitude(request.getLatitude());
        if (request.getLongitude() != null) restaurant.setLongitude(request.getLongitude());
        if (request.getPhone() != null) restaurant.setPhone(request.getPhone());
        if (request.getOperatingHours() != null) restaurant.setOperatingHours(request.getOperatingHours());
        if (request.getPriceRange() != null) restaurant.setPriceRange(request.getPriceRange());
        if (request.getImageUrl() != null) restaurant.setImageUrl(request.getImageUrl());
        if (request.getMenuInfo() != null) restaurant.setMenuInfo(request.getMenuInfo());
        if (request.getFacilities() != null) restaurant.setFacilities(request.getFacilities());
        if (request.getParkingInfo() != null) restaurant.setParkingInfo(request.getParkingInfo());
        if (request.getCapacity() != null) restaurant.setCapacity(request.getCapacity());
        if (request.getStatus() != null) restaurant.setStatus(request.getStatus());

        restaurantRepository.update(restaurant);

        return restaurantRepository.findDtoById(restaurantId)
                .orElseThrow(() -> new RuntimeException("Failed to update restaurant"));
    }

    @Transactional
    public void deleteRestaurant(Long restaurantId, Long userId) {
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));

        if (!restaurant.isOwnedBy(userId)) {
            throw new RuntimeException("Unauthorized to delete this restaurant");
        }

        restaurantRepository.delete(restaurantId);
    }

    @Transactional
    public void updateStatus(Long restaurantId, String status, Long userId) {
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));

        if (!restaurant.isOwnedBy(userId)) {
            throw new RuntimeException("Unauthorized to update this restaurant");
        }

        restaurantRepository.updateStatus(restaurantId, status);
    }
}
