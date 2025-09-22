package erpDto;

import java.util.Date;
import java.util.List;

public class Notice {
	private Long id;
	private Long companyId;
	private String title;
	private String content;
	private String deletedYn;
	private Date createdAt;
	private Date updatedAt;
	private List<NoticeFile> files; // 첨부파일 목록
	private List<NoticeImage> images; // 이 라인을 추가합니다.
	private int viewCount;

	public int getViewCount() {
		return viewCount;
	}

	public void setViewCount(int viewCount) {
		this.viewCount = viewCount;
	}

	public List<NoticeImage> getImages() {
		return images;
	}

	public void setImages(List<NoticeImage> images) {
		this.images = images;
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

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
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

	public List<NoticeFile> getFiles() {
		return files;
	}

	public void setFiles(List<NoticeFile> files) {
		this.files = files;
	}

}