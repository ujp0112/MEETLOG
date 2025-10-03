package dto;

import java.util.List;

public class BranchMonthlyData {
    private String yearMonth;
    private double totalRevenue;
    private List<BranchPerformance> branches;

    public BranchMonthlyData() {}

    public BranchMonthlyData(String yearMonth, double totalRevenue) {
        this.yearMonth = yearMonth;
        this.totalRevenue = totalRevenue;
    }

    public String getYearMonth() {
        return yearMonth;
    }

    public void setYearMonth(String yearMonth) {
        this.yearMonth = yearMonth;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public List<BranchPerformance> getBranches() {
        return branches;
    }

    public void setBranches(List<BranchPerformance> branches) {
        this.branches = branches;
    }
}
