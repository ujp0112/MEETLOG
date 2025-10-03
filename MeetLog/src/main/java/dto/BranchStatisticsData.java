package dto;

import java.util.List;

public class BranchStatisticsData {
    private int totalBranches;
    private int activeBranches;
    private int totalEmployees;
    private double totalRevenue;
    private double averageRevenuePerBranch;

    private List<BranchPerformance> branchPerformances;
    private List<BranchMonthlyData> monthlyData;

    // Getters and Setters
    public int getTotalBranches() {
        return totalBranches;
    }

    public void setTotalBranches(int totalBranches) {
        this.totalBranches = totalBranches;
    }

    public int getActiveBranches() {
        return activeBranches;
    }

    public void setActiveBranches(int activeBranches) {
        this.activeBranches = activeBranches;
    }

    public int getTotalEmployees() {
        return totalEmployees;
    }

    public void setTotalEmployees(int totalEmployees) {
        this.totalEmployees = totalEmployees;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public double getAverageRevenuePerBranch() {
        return averageRevenuePerBranch;
    }

    public void setAverageRevenuePerBranch(double averageRevenuePerBranch) {
        this.averageRevenuePerBranch = averageRevenuePerBranch;
    }

    public List<BranchPerformance> getBranchPerformances() {
        return branchPerformances;
    }

    public void setBranchPerformances(List<BranchPerformance> branchPerformances) {
        this.branchPerformances = branchPerformances;
    }

    public List<BranchMonthlyData> getMonthlyData() {
        return monthlyData;
    }

    public void setMonthlyData(List<BranchMonthlyData> monthlyData) {
        this.monthlyData = monthlyData;
    }
}
