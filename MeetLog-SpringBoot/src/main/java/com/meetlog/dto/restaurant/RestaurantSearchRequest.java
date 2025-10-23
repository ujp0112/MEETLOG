package com.meetlog.dto.restaurant;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RestaurantSearchRequest {
    private String keyword;
    private String category;
    private String address;
    private Integer priceRange;
    private Integer minCapacity;
    private String sortBy; // name, rating, created_at
    private String sortOrder; // asc, desc
    private Integer page;
    private Integer size;

    public int getOffset() {
        int p = page != null ? page : 1;
        int s = size != null ? size : 10;
        return (p - 1) * s;
    }

    public int getLimit() {
        return size != null ? size : 10;
    }

    public String getSortColumn() {
        if ("rating".equals(sortBy)) return "average_rating";
        if ("created_at".equals(sortBy)) return "created_at";
        return "name";
    }

    public String getSortDirection() {
        return "asc".equalsIgnoreCase(sortOrder) ? "ASC" : "DESC";
    }
}
