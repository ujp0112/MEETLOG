package erpDto;

import java.util.Date;
import java.util.List;

public class Promotion {
	private Long id;
	private Long companyId;
	private String title;
	private String description;
	private Date startDate;
	private Date endDate;
	private String deletedYn;
	private Date createdAt;
	private Date updatedAt;
	private List<PromotionImage> images;
	private String imgPath;

	public String getImgPath() {
		return imgPath;
	}

	public void setImgPath(String imgPath) {
		this.imgPath = imgPath;
	}

	public List<PromotionImage> getImages() {
		return images;
	}

	public void setImages(List<PromotionImage> images) {
		this.images = images;
	}

	public List<PromotionFile> getFiles() {
		return files;
	}

	public void setFiles(List<PromotionFile> files) {
		this.files = files;
	}

	private List<PromotionFile> files;

	public Long getId() {
		return id;
	}

	public Promotion() {
		super();
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

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public String getDeletedYn() {
		return deletedYn;
	}

	public void setDeletedYn(String deletedYn) {
		this.deletedYn = deletedYn;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public Date getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(Date updatedAt) {
		this.updatedAt = updatedAt;
	}

	// Getters and Setters for all fields
}