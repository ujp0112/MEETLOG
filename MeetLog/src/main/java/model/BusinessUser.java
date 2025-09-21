package model;

public class BusinessUser {
	// 기존 필드
	private int userId;
	private String businessName;
	private String ownerName;
	private String businessNumber;
	private String role;
	private String status;
	private Integer companyId;

	// ▼▼▼ [추가] JSP에서 보여줄 사용자 정보를 담을 필드 ▼▼▼
	private String email;
	private String nickname; // users 테이블의 nickname (가입 시 businessName으로 저장됨)

	// --- Getters and Setters ---

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getBusinessName() {
		return businessName;
	}

	public void setBusinessName(String businessName) {
		this.businessName = businessName;
	}

	public String getOwnerName() {
		return ownerName;
	}

	public void setOwnerName(String ownerName) {
		this.ownerName = ownerName;
	}

	public String getBusinessNumber() {
		return businessNumber;
	}

	public void setBusinessNumber(String businessNumber) {
		this.businessNumber = businessNumber;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Integer getCompanyId() {
		return companyId;
	}

	public void setCompanyId(Integer companyId) {
		this.companyId = companyId;
	}

	// ▼▼▼ [추가] 새로운 필드의 Getters and Setters ▼▼▼
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
}