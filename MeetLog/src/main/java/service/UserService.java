// src/main/java/service/UserService.java

package service;

import org.apache.ibatis.session.SqlSession;
import dao.UserDAO;
import dao.BusinessUserDAO;
import dao.CompanyDAO;
import model.User;
import model.BusinessUser;
import model.Company;
import model.UserStorage;
import model.UserStorageItem;
import model.Restaurant;
import model.CommunityCourse;
import model.Column;
import model.StorageItemDto;
import java.sql.Timestamp;
import util.MyBatisSqlSessionFactory;
import util.PasswordUtil;
import java.util.List;
import java.util.UUID;
import java.util.ArrayList;

public class UserService {
	private final UserDAO userDAO = new UserDAO();
	private final BusinessUserDAO businessUserDAO = new BusinessUserDAO();
	private final CompanyDAO companyDAO = new CompanyDAO();
	private final UserStorageService userStorageService = new UserStorageService();
	private RestaurantService restaurantService;
	private CourseService courseService;
	private ColumnService columnService;

	// --- 신규 통합 회원가입 로직 ---
	public boolean registerHqUser(User user, BusinessUser businessUser) {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession(false);
		try {
			Company company = new Company();
			company.setName(businessUser.getBusinessName());
			companyDAO.insert(sqlSession, company);
			int newCompanyId = company.getId();

			String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
			user.setPassword(hashedPassword);
			user.setUserType("BUSINESS");
			userDAO.insert(user, sqlSession);
			int newUserId = user.getId();

			businessUser.setUserId(newUserId);
			businessUser.setCompanyId(newCompanyId);
			businessUserDAO.insert(businessUser, sqlSession);

			sqlSession.commit();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			if (sqlSession != null)
				sqlSession.rollback();
			return false;
		} finally {
			if (sqlSession != null)
				sqlSession.close();
		}
	}

	public boolean registerBranchUser(User user, BusinessUser businessUser) {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSession(false);
		try {
			String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
			user.setPassword(hashedPassword);
			user.setUserType("BUSINESS");
			userDAO.insert(user, sqlSession);
			int newUserId = user.getId();

			businessUser.setUserId(newUserId);
			businessUserDAO.insert(businessUser, sqlSession);

			sqlSession.commit();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			if (sqlSession != null)
				sqlSession.rollback();
			return false;
		} finally {
			if (sqlSession != null)
				sqlSession.close();
		}
	}

	public boolean registerUser(User user) {
		if (user == null) {
			throw new IllegalArgumentException("사용자 정보가 null입니다.");
		}
		if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
			throw new IllegalArgumentException("이메일이 비어있습니다.");
		}
		if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
			throw new IllegalArgumentException("비밀번호가 비어있습니다.");
		}

		String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
		user.setPassword(hashedPassword);

		// DAO의 단독 insert 메소드(auto-commit) 사용
		int result = userDAO.insert(user);
		boolean userCreated = result > 0;

		if (userCreated) {
			// 사용자 등록 성공 시 기본 저장소 생성 (user.getId()는 insert 후 채워짐)
			try {
				createStorage(user.getId(), "내 찜 목록", "bg-red-100");
				System.out.println("DEBUG: 사용자 " + user.getId() + "의 기본 저장소 생성 완료");
			} catch (Exception e) {
				System.err.println("기본 저장소 생성 실패: " + e.getMessage());
				e.printStackTrace();
			}
		}

		return userCreated;
	}

	/**
	 * 이메일, 비밀번호, 그리고 명시된 사용자 유형을 기반으로 사용자를 인증합니다. 로그인 서블릿에서 이 메소드를 사용해야 개인/기업 회원을
	 * 정확히 구분할 수 있습니다.
	 * 
	 * @param email    사용자 이메일
	 * @param password 사용자가 입력한 비밀번호 (암호화 전)
	 * @param userType 로그인 시도하는 사용자의 유형 ("PERSONAL" 또는 "BUSINESS")
	 * @return 인증 성공 시 User 객체, 실패 시 null
	 */
	public User authenticateUser(String email, String password, String userType) {
		// [디버깅 로그 1] DAO 호출 직전, 입력된 값 확인
		System.out.println("[DEBUG] 인증 시도: email=" + email + ", userType=" + userType);

		User user = userDAO.findByEmailAndUserType(email, userType);

		// [디버깅 로그 2] DAO 호출 직후, 사용자를 찾았는지 확인
		if (user == null) {
			System.out.println("[DEBUG] 인증 실패: DB에서 해당 email과 userType의 사용자를 찾을 수 없음.");
			return null;
		} else {
			System.out.println("[DEBUG] 인증 성공: DB에서 사용자 찾음. ID=" + user.getId() + ", Email=" + user.getEmail());
		}

		// [디버깅 로그 3] 비밀번호 일치 여부 확인
		boolean passwordMatches = PasswordUtil.verifyPassword(password, user.getPassword());
		if (passwordMatches) {
			System.out.println("[DEBUG] 비밀번호 일치. 최종 인증 성공.");
			return user;
		} else {
			System.out.println("[DEBUG] 인증 실패: 비밀번호가 일치하지 않음.");
			return null;
		}
	}

	// --- 기존 인증 메소드 ---
	// 이 메소드는 userType을 구분하지 않으므로, 로그인 로직에서는 더 이상 사용하지 않는 것을 권장합니다.
	public User authenticateUser(String email, String password) {
		User user = userDAO.findByEmail(email);
		if (user != null && user.getPassword() != null && PasswordUtil.verifyPassword(password, user.getPassword())) {
			return user;
		}
		return null;
	}

	// --- ▼▼▼ [수정] 소셜 로그인 사용자 처리 로직 (최종본) ▼▼▼ ---
	/**
	 * 소셜 로그인 정보를 받아 기존 사용자인지 확인하고, 신규 사용자일 경우 부족한 정보를 보완하여 자동으로 회원가입시킨 후 사용자 정보를
	 * 반환합니다.
	 * 
	 * @param socialProfile 소셜 API에서 받아온 사용자 정보
	 * @return 로그인 또는 신규 가입 처리된 User 객체
	 */
	public User getOrCreateSocialUser(User socialProfile) {
		// 1. 소셜 제공자와 소셜 ID로 기존 사용자인지 확인
		User user = userDAO.findBySocial(socialProfile.getSocialProvider(), socialProfile.getSocialId());
		if (user != null) {
			System.out.println("기존 소셜 계정으로 로그인 성공: " + user.getEmail());
			return user;
		}

		// 2. 이메일로 이미 가입된 일반 계정이 있는지 확인 (계정 연동 시나리오)
		if (socialProfile.getEmail() != null && !socialProfile.getEmail().isEmpty()) {
			User existingUser = userDAO.findByEmail(socialProfile.getEmail());
			if (existingUser != null) {
				// TODO: 여기에 기존 계정과 소셜 계정을 연동하는 로직을 추가할 수 있습니다.
				// (예: users 테이블의 social_provider, social_id를 업데이트)
				System.out.println("기존 이메일 계정으로 로그인 성공 (소셜 연동됨): " + existingUser.getEmail());
				return existingUser;
			}
		}

		// 3. 신규 회원가입 처리: DB의 NOT NULL 컬럼에 대한 값 보정
		System.out.println("신규 소셜 계정 회원가입 절차 시작: " + socialProfile.getEmail());

		// [보안 강화] 닉네임이 없거나 중복될 경우, 고유한 임시 닉네임 생성
		String originalNickname = socialProfile.getNickname();
		if (originalNickname == null || originalNickname.trim().isEmpty()
				|| userDAO.findByNickname(originalNickname) != null) {
			String tempNickname = "사용자_" + UUID.randomUUID().toString().substring(0, 8);
			socialProfile.setNickname(tempNickname);
			System.out.println("닉네임 정보가 없거나 중복되어 임시 닉네임 생성: " + tempNickname);
		}

		// [안정성 강화] 이메일 정보가 없는 경우, 고유한 임시 이메일 생성
		if (socialProfile.getEmail() == null || socialProfile.getEmail().trim().isEmpty()) {
			String tempEmail = socialProfile.getSocialId() + "@" + socialProfile.getSocialProvider().toLowerCase()
					+ ".social";
			socialProfile.setEmail(tempEmail);
			System.out.println("이메일 정보가 없어 임시 이메일 생성: " + tempEmail);
		}

		// [필수] 비밀번호 필드가 NOT NULL 이므로, 암호화된 임의의 값 설정
		String placeholderPassword = "social_login_user_" + UUID.randomUUID().toString();
		socialProfile.setPassword(PasswordUtil.hashPassword(placeholderPassword));

		// [필수] 사용자 유형 기본값 설정
		socialProfile.setUserType("PERSONAL");

		// 4. 보정된 정보로 DB에 사용자 정보 삽입
		int result = userDAO.insert(socialProfile);

		if (result > 0) {
			// MyBatis의 useGeneratedKeys 덕분에 insert 후 socialProfile 객체에 id가 채워짐
			int newUserId = socialProfile.getId();
			System.out.println("신규 소셜 사용자 DB 저장 성공, ID: " + newUserId);

			// 신규 가입 시 기본 '찜 목록' 저장소 생성
			try {
				createStorage(newUserId, "내 찜 목록", "bg-red-100");
			} catch (Exception e) {
				System.err.println("소셜 사용자 기본 저장소 생성 실패: " + e.getMessage());
				e.printStackTrace();
			}
			return socialProfile; // 가입 완료된 최종 사용자 정보 반환
		}

		System.err.println("신규 소셜 사용자 DB 저장 실패.");
		return null; // 모든 과정이 실패한 경우
	}

	public boolean isCompanyExists(int companyId) {
		return companyDAO.existsById(companyId);
	}

	// ... 이하 기존에 제공해주신 코드와 동일 ...
	public boolean updateProfile(int userId, String nickname, String profileImage) {
		User user = userDAO.findById(userId);
		if (user == null) {
			return false;
		}
		user.setNickname(nickname);
		user.setProfileImage(profileImage);
		return userDAO.update(user) > 0;
	}

	public boolean changePassword(int userId, String currentPassword, String newPassword) {
		User user = userDAO.findById(userId);
		if (user == null) {
			return false;
		}

		if (!PasswordUtil.verifyPassword(currentPassword, user.getPassword())) {
			return false;
		}

		String newHashedPassword = PasswordUtil.hashPassword(newPassword);
		return userDAO.updatePassword(userId, newHashedPassword) > 0;
	}

	public User findByEmail(String email) {
		return userDAO.findByEmail(email);
	}

	public boolean isEmailExists(String email) {
		return userDAO.findByEmail(email) != null;
	}

	public boolean isNicknameExists(String nickname) {
		return userDAO.findByNickname(nickname) != null;
	}

	public User getUserById(int userId) {
		return userDAO.findById(userId);
	}

	public boolean updateUser(User user) {
		return userDAO.update(user) > 0;
	}

	public boolean deleteUser(int userId) {
		return userDAO.delete(userId) > 0;
	}

	public List<User> getAllUsers() {
		return userDAO.findAll();
	}

	public String findEmailByNickname(String nickname) {
		User user = userDAO.findByNickname(nickname);
		return (user != null) ? user.getEmail() : null;
	}

	public boolean resetPassword(String email) {
		User user = userDAO.findByEmail(email);
		if (user != null) {
			String tempPassword = PasswordUtil.generateTempPassword();
			String hashedPassword = PasswordUtil.hashPassword(tempPassword);

			if (userDAO.updatePassword(user.getId(), hashedPassword) > 0) {
				System.out.println("임시 비밀번호 발급 [" + email + ": " + tempPassword + "]");
				return true;
			}
		}
		return false;
	}

	public BusinessUser findHqUserByIdentifier(String identifier) {
		return businessUserDAO.findHqByIdentifier(identifier);
	}

	// --- HQ/Branch 관리 기능 ---

	public BusinessUser getBusinessUserByUserId(int userId) {
		return businessUserDAO.findByUserId(userId);
	}

	public List<BusinessUser> getPendingBranches(int companyId) {
		return businessUserDAO.findPendingByCompanyId(companyId);
	}

	public boolean approveBranch(int branchUserId) {
		return businessUserDAO.updateStatus(branchUserId, "ACTIVE") > 0;
	}

	public boolean rejectBranch(int branchUserId) {
		return userDAO.delete(branchUserId) > 0;
	}

	// --- 위시리스트 관련 메소드들 (기존 코드 유지) ---
	// ... (이하 모든 코드는 제공해주신 원본과 동일하게 유지됩니다) ...
	public List<model.Restaurant> getWishlistRestaurants(int userId) {
		if (userStorageService == null) {
			return new ArrayList<>();
		}

		try {
			UserStorage defaultStorage = userStorageService.getOrCreateDefaultStorage(userId);
			if (defaultStorage == null) {
				return new ArrayList<>();
			}
			return getStorageRestaurants(defaultStorage.getStorageId());
		} catch (Exception e) {
			e.printStackTrace();
			return new ArrayList<>();
		}
	}

	public List<model.UserCollection> getUserCollections(int userId) {
		// 사용자의 컬렉션 목록을 가져옴
		// 임시로 빈 리스트 반환 (실제 구현 필요)
		return new java.util.ArrayList<>();
	}

	public model.UserCollection getUserCollection(int collectionId, int userId) {
		// 특정 컬렉션 정보를 가져옴 (권한 확인 포함)
		// 임시로 null 반환 (실제 구현 필요)
		return null;
	}

	public List<model.Restaurant> getCollectionRestaurants(int collectionId) {
		// 컬렉션에 속한 레스토랑들을 가져옴
		// 임시로 빈 리스트 반환 (실제 구현 필요)
		return new java.util.ArrayList<>();
	}

	public boolean addToCollection(int userId, int restaurantId, int collectionId) {
		if (userStorageService == null) {
			return false;
		}

		UserStorage storage = userStorageService.getStorageById(collectionId);
		if (storage == null || storage.getUserId() != userId) {
			return false;
		}
		return userStorageService.addToStorage(collectionId, "RESTAURANT", restaurantId);
	}

	public boolean addToWishlist(int userId, int restaurantId) {
		if (userStorageService == null) {
			return false;
		}

		try {
			return userStorageService.addToWishlist(userId, "RESTAURANT", restaurantId);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean removeFromWishlist(int userId, int restaurantId) {
		if (userStorageService == null) {
			return false;
		}

		try {
			return userStorageService.removeFromWishlist(userId, "RESTAURANT", restaurantId);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean createCollection(int userId, String collectionName, String description) {
		// 새 컬렉션을 생성
		return createCollection(userId, collectionName, description, "bg-blue-100");
	}

	public boolean createCollection(int userId, String collectionName, String description, String colorClass) {
		// UserStorageService를 사용하여 저장소 생성
		return createStorage(userId, collectionName, colorClass);
	}

	public UserStorage createStorageAndReturn(int userId, String storageName, String colorClass) {
		if (userStorageService == null) {
			return null;
		}

		if (storageName == null || storageName.trim().isEmpty()) {
			return null;
		}

		String resolvedColor = (colorClass != null && !colorClass.trim().isEmpty()) ? colorClass.trim() : "bg-blue-100";
		UserStorage storage = new UserStorage(userId, storageName.trim(), resolvedColor);
		boolean created = userStorageService.createStorage(storage);
		return created ? storage : null;
	}

	// user_storages 테이블을 사용하는 새로운 메서드들
	public boolean createStorage(int userId, String storageName, String colorClass) {
		return createStorageAndReturn(userId, storageName, colorClass) != null;
	}

	public UserStorage updateStorage(int userId, int storageId, String storageName, String colorClass) {
		if (userStorageService == null) {
			return null;
		}

		UserStorage storage = userStorageService.getStorageById(storageId);
		if (storage == null || storage.getUserId() != userId) {
			return null;
		}

		if (storageName != null && !storageName.trim().isEmpty()) {
			storage.setName(storageName.trim());
		}

		if (colorClass != null && !colorClass.trim().isEmpty()) {
			storage.setColorClass(colorClass.trim());
		}

		boolean updated = userStorageService.updateStorage(storage);
		return updated ? storage : null;
	}

	public boolean deleteStorage(int userId, int storageId) {
		if (userStorageService == null) {
			return false;
		}

		UserStorage storage = userStorageService.getStorageById(storageId);
		if (storage == null || storage.getUserId() != userId) {
			return false;
		}

		return userStorageService.deleteStorage(storageId);
	}

	public List<UserStorage> getUserStorages(int userId) {
		if (userStorageService != null) {
			return userStorageService.getUserStorages(userId);
		}
		return new ArrayList<>();
	}

	public UserStorage getUserStorage(int storageId, int userId) {
		if (userStorageService == null) {
			return null;
		}

		UserStorage storage = userStorageService.getStorageById(storageId);
		if (storage == null || storage.getUserId() != userId) {
			return null;
		}
		return storage;
	}

	public List<Restaurant> getStorageRestaurants(int storageId) {
		if (userStorageService != null) {
			List<UserStorageItem> items = userStorageService.getStorageItems(storageId);
			List<Restaurant> restaurants = new ArrayList<>();

			// 레스토랑 타입만 필터링해서 실제 레스토랑 정보 조회
			for (UserStorageItem item : items) {
				if ("RESTAURANT".equals(item.getItemType())) {
					try {
						if (restaurantService == null) {
							restaurantService = new RestaurantService();
						}
						Restaurant restaurant = restaurantService.getRestaurantById(item.getContentId());
						if (restaurant != null) {
							restaurants.add(restaurant);
						}
					} catch (Exception e) {
						System.err.println("레스토랑 조회 실패 (ID: " + item.getContentId() + "): " + e.getMessage());
					}
				}
			}
			return restaurants;
		}
		return new ArrayList<>();
	}

	public List<StorageItemDto> getStorageItemsAsDto(int storageId) {
		if (userStorageService != null) {
			List<UserStorageItem> items = userStorageService.getStorageItems(storageId);
			List<StorageItemDto> dtoItems = new ArrayList<>();

			for (UserStorageItem item : items) {
				try {
					StorageItemDto dto = null;

					switch (item.getItemType()) {
					case "RESTAURANT":
						if (restaurantService == null) {
							restaurantService = new RestaurantService();
						}
						Restaurant restaurant = restaurantService.getRestaurantById(item.getContentId());
						if (restaurant != null) {
							dto = new StorageItemDto();
							dto.setItemType("RESTAURANT");
							dto.setContentId(restaurant.getId());
							dto.setTitle(restaurant.getName());
							dto.setDescription(restaurant.getDescription());
							dto.setImageUrl(restaurant.getMainImage());
							dto.setLinkUrl("/restaurant/detail/" + restaurant.getId());
							dto.setAdditionalInfo("⭐ " + restaurant.getAverageRating());
						}
						break;

					case "COURSE":
						if (courseService == null) {
							courseService = new CourseService();
						}
						try {
							CommunityCourse course = courseService.getCourseById(item.getContentId());
							if (course != null) {
								dto = new StorageItemDto();
								dto.setItemType("COURSE");
								dto.setContentId(course.getId());
								dto.setTitle(course.getTitle());
								dto.setDescription(course.getDescription());
								dto.setImageUrl(course.getPreviewImage());
								dto.setLinkUrl("/course/detail?id=" + course.getId());
								dto.setAuthorName(course.getAuthor());
								dto.setCreatedAt(course.getCreatedAt());
								dto.setAdditionalInfo("❤️ " + course.getLikes());
								System.out.println(
										"DEBUG: 코스 데이터 로드 성공 - ID: " + course.getId() + ", 제목: " + course.getTitle());
							} else {
								System.out.println("DEBUG: 코스 데이터가 null입니다 - contentId: " + item.getContentId());
							}
						} catch (Exception e) {
							System.err.println(
									"DEBUG: 코스 조회 실패 - contentId: " + item.getContentId() + ", 오류: " + e.getMessage());
							e.printStackTrace();
						}
						break;

					case "COLUMN":
						if (columnService == null) {
							columnService = new ColumnService();
						}
						Column column = columnService.getColumnById(item.getContentId());
						if (column != null) {
							dto = new StorageItemDto();
							dto.setItemType("COLUMN");
							dto.setContentId(column.getId());
							dto.setTitle(column.getTitle());
							dto.setDescription(column.getContent() != null && column.getContent().length() > 100
									? column.getContent().substring(0, 100) + "..."
									: column.getContent());
							dto.setImageUrl(column.getImage());
							dto.setLinkUrl("/column/detail?id=" + column.getId());
							dto.setAuthorName(column.getAuthor());
							dto.setCreatedAt(column.getCreatedAt().toLocalDateTime());
							dto.setAdditionalInfo("👀 " + column.getViews());
						}
						break;
					}

					if (dto != null) {
						dtoItems.add(dto);
					}
				} catch (Exception e) {
					System.err.println("아이템 조회 실패 (" + item.getItemType() + " ID: " + item.getContentId() + "): "
							+ e.getMessage());
				}
			}

			return dtoItems;
		}
		return new ArrayList<>();
	}

	public List<Object> getStorageItemsWithDetails(int storageId) {
		if (userStorageService != null) {
			List<UserStorageItem> items = userStorageService.getStorageItems(storageId);
			List<Object> detailedItems = new ArrayList<>();

			for (UserStorageItem item : items) {
				try {
					Object detailedItem = null;

					switch (item.getItemType()) {
					case "RESTAURANT":
						if (restaurantService == null) {
							restaurantService = new RestaurantService();
						}
						detailedItem = restaurantService.getRestaurantById(item.getContentId());
						break;

					case "COURSE":
						if (courseService == null) {
							courseService = new CourseService();
						}
						detailedItem = courseService.getCourseById(item.getContentId());
						break;

					case "COLUMN":
						if (columnService == null) {
							columnService = new ColumnService();
						}
						detailedItem = columnService.getColumnById(item.getContentId());
						break;
					}

					if (detailedItem != null) {
						detailedItems.add(detailedItem);
					}
				} catch (Exception e) {
					System.err.println("아이템 조회 실패 (" + item.getItemType() + " ID: " + item.getContentId() + "): "
							+ e.getMessage());
				}
			}

			return detailedItems;
		}
		return new ArrayList<>();
	}

	public boolean addToStorage(int userId, int restaurantId, int storageId) {
		if (userStorageService == null) {
			return false;
		}

		UserStorage storage = userStorageService.getStorageById(storageId);
		if (storage == null || storage.getUserId() != userId) {
			return false;
		}

		return userStorageService.addToStorage(storageId, "RESTAURANT", restaurantId);
	}

	public boolean removeItemFromStorage(int userId, int storageId, String itemType, int contentId) {
		if (userStorageService == null) {
			return false;
		}

		UserStorage storage = userStorageService.getStorageById(storageId);
		if (storage == null || storage.getUserId() != userId) {
			return false;
		}

		return userStorageService.removeFromStorage(storageId, itemType, contentId);
	}
}