package model;

// OfficialCourse에 포함되는 "단계" 모델
public class CourseStep {
	private String type;
	private String emoji;
	private String name;
	private String description;
	private String image;

	// --- (모든 필드에 대한 Getter/Setter가 필요합니다) ---
	// (Getter/Setter를 모두 생성해주세요)
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getEmoji() {
		return emoji;
	}

	public void setEmoji(String emoji) {
		this.emoji = emoji;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}
}