package dto;

import java.time.LocalDateTime;

public class Material {
  private Long id;
  private Long companyId;

  private String name;
  private String unit;
  private Double unitPrice;
  private Double step;
  private String imgPath;

  private String activeYn;
  private String deletedYn;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }

  public Long getCompanyId() { return companyId; }
  public void setCompanyId(Long companyId) { this.companyId = companyId; }

  public String getName() { return name; }
  public void setName(String name) { this.name = name; }

  public String getUnit() { return unit; }
  public void setUnit(String unit) { this.unit = unit; }

  public Double getUnitPrice() { return unitPrice; }
  public void setUnitPrice(Double unitPrice) { this.unitPrice = unitPrice; }

  public Double getStep() { return step; }
  public void setStep(Double step) { this.step = step; }

  public String getImgPath() { return imgPath; }
  public void setImgPath(String imgPath) { this.imgPath = imgPath; }

  public String getActiveYn() { return activeYn; }
  public void setActiveYn(String activeYn) { this.activeYn = activeYn; }

  public String getDeletedYn() { return deletedYn; }
  public void setDeletedYn(String deletedYn) { this.deletedYn = deletedYn; }

  public LocalDateTime getCreatedAt() { return createdAt; }
  public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

  public LocalDateTime getUpdatedAt() { return updatedAt; }
  public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
