package model;

import java.util.List;

// JSP의 "오늘의 추천코스" 섹션에 필요한 데이터를 담는 모델
public class OfficialCourse {
	private int id;
	private String title;
	private List<String> tags; // Nested 쿼리 결과
	private List<CourseStep> steps; // Nested 쿼리 결과

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

	public List<String> getTags() {
		return tags;
	}

	public void setTags(List<String> tags) {
		this.tags = tags;
	}

	public List<CourseStep> getSteps() {
		return steps;
	}

	public void setSteps(List<CourseStep> steps) {
		this.steps = steps;
	}
}