package model;

public class CourseStep {
    // [추가] MyBatis가 step_id를 담을 변수
    private int id;
    
	private String type;
	private String emoji;
	private String name;
	private String description;
	private String image;

	// DB 저장을 위한 필드들
	private int courseId; // 이 단계가 속한 코스의 ID
	private int order;    // 코스 내 단계 순서
	private int time;     // 소요 시간 (분)
	private int cost;     // 예상 비용 (원)

	// 위치 정보
	private Double latitude;  // 위도
	private Double longitude; // 경도
	private String address;   // 주소

	// --- 모든 필드에 대한 Getter/Setter ---
	
    // [추가] id 필드의 Getter/Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

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

	public int getCourseId() {
		return courseId;
	}

	public void setCourseId(int courseId) {
		this.courseId = courseId;
	}

	public int getOrder() {
		return order;
	}

	public void setOrder(int order) {
		this.order = order;
	}

	public int getTime() {
		return time;
	}

	public void setTime(int time) {
		this.time = time;
	}

	public int getCost() {
		return cost;
	}

	public void setCost(int cost) {
		this.cost = cost;
	}

	public Double getLatitude() {
		return latitude;
	}

	public void setLatitude(Double latitude) {
		this.latitude = latitude;
	}

	public Double getLongitude() {
		return longitude;
	}

	public void setLongitude(Double longitude) {
		this.longitude = longitude;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
}