// PurchaseOrder.java
package erpDto;

import java.util.Date;
import java.util.List;

public class PurchaseOrder {
	private Long id, companyId, branchId, totalPrice;
	private String status;
	private Date orderedAt;
	private List<PurchaseOrderLine> lines;
	private String branchName;
	private Integer itemCount;
    private String mainItemName;

    public Integer getItemCount() {
        return itemCount;
    }

    public void setItemCount(Integer itemCount) {
        this.itemCount = itemCount;
    }

    public String getMainItemName() {
        return mainItemName;
    }

    public void setMainItemName(String mainItemName) {
        this.mainItemName = mainItemName;
    }

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getCompanyId() {
		return companyId;
	}

	public void setCompanyId(Long companyId) {
		this.companyId = companyId;
	}

	public Long getBranchId() {
		return branchId;
	}

	public void setBranchId(Long branchId) {
		this.branchId = branchId;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Long getTotalPrice() {
		return totalPrice;
	}

	public void setTotalPrice(Long totalPrice) {
		this.totalPrice = totalPrice;
	}

	public Date getOrderedAt() {
		return orderedAt;
	}

	public void setOrderedAt(Date orderedAt) {
		this.orderedAt = orderedAt;
	}

	public List<PurchaseOrderLine> getLines() {
		return lines;
	}

	public void setLines(List<PurchaseOrderLine> lines) {
		this.lines = lines;
	}

	public String getBranchName() {
		return branchName;
	}

	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}
}
