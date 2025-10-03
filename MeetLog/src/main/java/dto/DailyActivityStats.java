package dto;

import java.sql.Date;

public class DailyActivityStats {
    private Date statDate;
    private int reviewsCount;
    private int coursesCreatedCount;
    private int wishlistSavesCount;
    private int newFollowsCount;
    private int activeUsersCount;
    private int newUsersCount;

    public DailyActivityStats() {}

    public Date getStatDate() {
        return statDate;
    }

    public void setStatDate(Date statDate) {
        this.statDate = statDate;
    }

    public int getReviewsCount() {
        return reviewsCount;
    }

    public void setReviewsCount(int reviewsCount) {
        this.reviewsCount = reviewsCount;
    }

    public int getCoursesCreatedCount() {
        return coursesCreatedCount;
    }

    public void setCoursesCreatedCount(int coursesCreatedCount) {
        this.coursesCreatedCount = coursesCreatedCount;
    }

    public int getWishlistSavesCount() {
        return wishlistSavesCount;
    }

    public void setWishlistSavesCount(int wishlistSavesCount) {
        this.wishlistSavesCount = wishlistSavesCount;
    }

    public int getNewFollowsCount() {
        return newFollowsCount;
    }

    public void setNewFollowsCount(int newFollowsCount) {
        this.newFollowsCount = newFollowsCount;
    }

    public int getActiveUsersCount() {
        return activeUsersCount;
    }

    public void setActiveUsersCount(int activeUsersCount) {
        this.activeUsersCount = activeUsersCount;
    }

    public int getNewUsersCount() {
        return newUsersCount;
    }

    public void setNewUsersCount(int newUsersCount) {
        this.newUsersCount = newUsersCount;
    }
}
