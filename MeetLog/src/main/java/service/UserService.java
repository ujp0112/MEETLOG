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
import util.PasswordUtil; // 새로 만든 PasswordUtil 클래스를 import 합니다.
import java.util.List;
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
            if (sqlSession != null) sqlSession.rollback();
            return false;
        } finally {
            if (sqlSession != null) sqlSession.close();
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
            if (sqlSession != null) sqlSession.rollback();
            return false;
        } finally {
            if (sqlSession != null) sqlSession.close();
        }
    }

    public boolean registerUser(User user) {
        // 입력값 검증
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
        
        boolean userCreated = userDAO.insert(user) > 0;
        
        if (userCreated) {
            // 사용자 등록 성공 시 기본 저장소 생성
            try {
                createStorage(user.getId(), "내 찜 목록", "bg-red-100");
                System.out.println("DEBUG: 사용자 " + user.getId() + "의 기본 저장소 생성 완료");
            } catch (Exception e) {
                System.err.println("기본 저장소 생성 실패: " + e.getMessage());
                e.printStackTrace();
                // 저장소 생성 실패는 사용자 등록을 막지 않음
            }
        }
        
        return userCreated;
    }

    // --- 기존 서비스 메소드들 ---
    public User authenticateUser(String email, String password) {
        User user = userDAO.findByEmail(email);
        if (user != null && PasswordUtil.verifyPassword(password, user.getPassword())) {
            return user;
        }
        return null;
    }
    
    public boolean isCompanyExists(int companyId) {
        return companyDAO.existsById(companyId);
    }

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

    // --- 위시리스트 관련 메소드들 ---

    public List<model.Restaurant> getWishlistRestaurants(int userId) {
        // UserCollectionDAO를 통해 사용자의 위시리스트 레스토랑들을 가져옴
        // 임시로 빈 리스트 반환 (실제 구현 필요)
        return new java.util.ArrayList<>();
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
        // 컬렉션에 레스토랑을 추가
        // 임시로 true 반환 (실제 구현 필요)
        return true;
    }

    public boolean addToWishlist(int userId, int restaurantId) {
        // 기본 위시리스트에 레스토랑을 추가
        // 임시로 true 반환 (실제 구현 필요)
        return true;
    }

    public boolean removeFromWishlist(int userId, int restaurantId) {
        // 위시리스트에서 레스토랑을 제거
        // 임시로 true 반환 (실제 구현 필요)
        return true;
    }

    public boolean createCollection(int userId, String collectionName, String description) {
        // 새 컬렉션을 생성
        return createCollection(userId, collectionName, description, "bg-blue-100");
    }

    public boolean createCollection(int userId, String collectionName, String description, String colorClass) {
        // UserStorageService를 사용하여 저장소 생성
        return createStorage(userId, collectionName, colorClass);
    }

    // user_storages 테이블을 사용하는 새로운 메서드들
    public boolean createStorage(int userId, String storageName, String colorClass) {
        if (userStorageService != null) {
            UserStorage storage = new UserStorage(userId, storageName, colorClass != null ? colorClass : "bg-blue-100");
            return userStorageService.createStorage(storage);
        }
        return true;
    }

    public List<UserStorage> getUserStorages(int userId) {
        if (userStorageService != null) {
            return userStorageService.getUserStorages(userId);
        }
        return new ArrayList<>();
    }

    public UserStorage getUserStorage(int storageId, int userId) {
        if (userStorageService != null) {
            // 보안을 위해 userId는 일단 무시하고 storageId로만 조회 (실제로는 권한 체크 필요)
            return userStorageService.getStorageById(storageId);
        }
        return null;
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

    /**
     * 저장소의 모든 아이템들을 DTO로 변환하여 조회 (코스, 칼럼, 레스토랑 포함)
     */
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
                                    System.out.println("DEBUG: 코스 데이터 로드 성공 - ID: " + course.getId() + ", 제목: " + course.getTitle());
                                } else {
                                    System.out.println("DEBUG: 코스 데이터가 null입니다 - contentId: " + item.getContentId());
                                }
                            } catch (Exception e) {
                                System.err.println("DEBUG: 코스 조회 실패 - contentId: " + item.getContentId() + ", 오류: " + e.getMessage());
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
                    System.err.println("아이템 조회 실패 (" + item.getItemType() + " ID: " + item.getContentId() + "): " + e.getMessage());
                }
            }

            return dtoItems;
        }
        return new ArrayList<>();
    }

    /**
     * 저장소의 모든 아이템들을 상세 정보와 함께 조회 (코스, 칼럼, 레스토랑 포함)
     * @deprecated getStorageItemsAsDto 사용 권장
     */
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
                    System.err.println("아이템 조회 실패 (" + item.getItemType() + " ID: " + item.getContentId() + "): " + e.getMessage());
                }
            }

            return detailedItems;
        }
        return new ArrayList<>();
    }

    public boolean addToStorage(int userId, int restaurantId, int storageId) {
        if (userStorageService != null) {
            return userStorageService.addToStorage(storageId, "RESTAURANT", restaurantId);
        }
        return true;
    }
}