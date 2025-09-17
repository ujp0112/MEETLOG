package model;

import java.util.List;

// JSP의 "모두의 코스" 섹션에 필요한 데이터를 담는 모델
public class CommunityCourse {
	private int id;
	private String title;
	private String previewImage;
	private String authorName;
	private String authorImage;
	private int likes;
	private List<String> tags; // Nested 쿼리 결과

	// --- (모든 필드에 대한 Getter/Setter가 필요합니다) ---
	// (Getter/Setter를 모두 생성해주세요)
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getPreviewImage() {
		return previewImage;
	}

	public void setPreviewImage(String previewImage) {
		this.previewImage = previewImage;
	}

	public String getAuthorName() {
		return authorName;
	}

	public void setAuthorName(String authorName) {
		this.authorName = authorName;
	}

	public String getAuthorImage() {
		return authorImage;
	}

	public void setAuthorImage(String authorImage) {
		this.authorImage = authorImage;
	}

	public int getLikes() {
		return likes;
	}

	public void setLikes(int likes) {
		this.likes = likes;
	}

	public List<String> getTags() {
		return tags;
	}

	public void setTags(List<String> tags) {
		this.tags = tags;
	}
}