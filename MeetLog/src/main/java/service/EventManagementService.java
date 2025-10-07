package service;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import javax.servlet.http.Part;

import dao.EventManagementDAO;
import model.AdminEvent;
import util.AppConfig;

public class EventManagementService {
    private static final long MAX_IMAGE_SIZE = 5L * 1024 * 1024; // 5MB
    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of(
            "image/png",
            "image/jpeg",
            "image/jpg",
            "image/gif",
            "image/webp"
    );
    private static final String EVENTS_DIRECTORY = "events";
    private static final String DEFAULT_EVENT_IMAGE = "https://placehold.co/600x400/0ea5e9/ffffff?text=MEETLOG+EVENT";

    private final EventManagementDAO eventDAO = new EventManagementDAO();

    /**
     * 관리자 페이지의 모든 이벤트 목록을 가져옵니다.
     * @return AdminEvent 목록
     */
    public List<AdminEvent> getAllEventsForAdmin() {
        return eventDAO.selectAllEventsForAdmin();
    }
    
    /**
     * 새로운 이벤트를 DB에 추가합니다.
     * @param event 추가할 이벤트 정보
     */
    public void addEvent(AdminEvent event) {
        addEvent(event, null, null);
    }

    /**
     * 새로운 이벤트를 DB에 추가합니다. (이미지 업로드 포함)
     * @param event 이벤트 정보
     * @param imagePart 업로드된 이미지 파트 (선택)
     * @param imageUrl 직접 입력한 이미지 URL (선택)
     */
    public void addEvent(AdminEvent event, Part imagePart, String imageUrl) {
        if (event == null) {
            throw new IllegalArgumentException("이벤트 정보가 필요합니다.");
        }

        normalizeTextFields(event);
        validateEvent(event);

        String uploadedPath = null;

        try {
            if (imagePart != null && imagePart.getSize() > 0) {
                uploadedPath = handleImageUpload(imagePart);
                event.setImage(uploadedPath);
            } else if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                event.setImage(imageUrl.trim());
            } else if (event.getImage() == null || event.getImage().isEmpty()) {
                event.setImage(DEFAULT_EVENT_IMAGE);
            }

            eventDAO.insertEvent(event);
        } catch (IllegalArgumentException e) {
            if (uploadedPath != null) {
                removeStoredImage(uploadedPath);
            }
            throw e;
        } catch (Exception e) {
            if (uploadedPath != null) {
                removeStoredImage(uploadedPath);
            }
            throw new RuntimeException("이벤트 등록 중 오류가 발생했습니다.", e);
        }
    }
    
    /**
     * 기존 이벤트 정보를 수정합니다.
     * @param event 수정할 이벤트 정보
     */
    public void updateEvent(AdminEvent event) {
        updateEvent(event, null, null, event != null ? event.getImage() : null);
    }

    /**
     * 기존 이벤트 정보를 수정합니다. (이미지 업로드 포함)
     * @param event 수정할 이벤트 정보
     * @param imagePart 새로 업로드된 이미지 (선택)
     * @param imageUrl 직접 입력한 이미지 URL (선택)
     * @param existingImagePath 기존 이미지 경로
     */
    public void updateEvent(AdminEvent event, Part imagePart, String imageUrl, String existingImagePath) {
        if (event == null) {
            throw new IllegalArgumentException("이벤트 정보가 필요합니다.");
        }

        normalizeTextFields(event);
        validateEvent(event);

        String currentImage = trimToNull(existingImagePath);
        if (currentImage == null) {
            currentImage = trimToNull(event.getImage());
        }

        String uploadedPath = null;

        try {
            if (imagePart != null && imagePart.getSize() > 0) {
                uploadedPath = handleImageUpload(imagePart);
                event.setImage(uploadedPath);
            } else if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                event.setImage(imageUrl.trim());
            } else if (event.getImage() == null || event.getImage().isEmpty()) {
                event.setImage(currentImage != null ? currentImage : DEFAULT_EVENT_IMAGE);
            }

            eventDAO.updateEvent(event);

            if (uploadedPath != null && currentImage != null && !currentImage.equals(uploadedPath)) {
                removeStoredImage(currentImage);
            }
        } catch (IllegalArgumentException e) {
            if (uploadedPath != null) {
                removeStoredImage(uploadedPath);
            }
            throw e;
        } catch (Exception e) {
            if (uploadedPath != null) {
                removeStoredImage(uploadedPath);
            }
            throw new RuntimeException("이벤트 수정 중 오류가 발생했습니다.", e);
        }
    }
    
    /**
     * ID에 해당하는 이벤트를 삭제합니다.
     * @param eventId 삭제할 이벤트 ID
     */
    public void deleteEvent(int eventId) {
        eventDAO.deleteEvent(eventId);
    }

    private void validateEvent(AdminEvent event) {
        if (event.getTitle() == null || event.getTitle().isEmpty()) {
            throw new IllegalArgumentException("이벤트 제목을 입력해주세요.");
        }
        if (event.getStartDate() == null || event.getEndDate() == null) {
            throw new IllegalArgumentException("이벤트 기간을 입력해주세요.");
        }
        if (event.getEndDate().before(event.getStartDate())) {
            throw new IllegalArgumentException("이벤트 종료일은 시작일 이후여야 합니다.");
        }
    }

    private void normalizeTextFields(AdminEvent event) {
        event.setTitle(requiredTrim(event.getTitle()));
        event.setSummary(trimToNull(event.getSummary()));
        event.setContent(trimToNull(event.getContent()));
        event.setImage(trimToNull(event.getImage()));
    }

    private String requiredTrim(String value) {
        if (value == null) {
            return null;
        }
        return value.trim();
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private String handleImageUpload(Part imagePart) throws IOException {
        if (imagePart == null || imagePart.getSize() == 0) {
            return null;
        }

        if (imagePart.getSize() > MAX_IMAGE_SIZE) {
            throw new IllegalArgumentException("이미지 파일은 최대 5MB까지 업로드할 수 있습니다.");
        }

        String contentType = imagePart.getContentType();
        if (contentType == null || !ALLOWED_CONTENT_TYPES.contains(contentType.toLowerCase())) {
            throw new IllegalArgumentException("지원하지 않는 이미지 형식입니다.");
        }

        String uploadRoot = AppConfig.getUploadPath();
        if (uploadRoot == null || uploadRoot.isBlank()) {
            throw new IllegalStateException("파일 업로드 경로가 설정되지 않았습니다.");
        }

        File eventsDir = new File(uploadRoot, EVENTS_DIRECTORY);
        if (!eventsDir.exists() && !eventsDir.mkdirs()) {
            throw new IOException("이벤트 이미지 디렉터리를 생성할 수 없습니다.");
        }

        String originalName = imagePart.getSubmittedFileName();
        String extension = extractExtension(originalName, contentType);
        String storedName = UUID.randomUUID().toString() + extension;
        File target = new File(eventsDir, storedName);
        imagePart.write(target.getAbsolutePath());

        return "/uploads/" + EVENTS_DIRECTORY + "/" + storedName;
    }

    private String extractExtension(String originalName, String contentType) {
        if (originalName != null && originalName.lastIndexOf('.') != -1) {
            return originalName.substring(originalName.lastIndexOf('.')).toLowerCase();
        }

        if (contentType == null) {
            return "";
        }

        switch (contentType.toLowerCase()) {
            case "image/png":
                return ".png";
            case "image/jpeg":
            case "image/jpg":
                return ".jpg";
            case "image/gif":
                return ".gif";
            case "image/webp":
                return ".webp";
            default:
                return "";
        }
    }

    private void removeStoredImage(String imagePath) {
        if (imagePath == null || imagePath.isBlank()) {
            return;
        }

        if (!imagePath.contains("/" + EVENTS_DIRECTORY + "/")) {
            return; // 다른 경로는 삭제하지 않음
        }

        String uploadRoot = AppConfig.getUploadPath();
        if (uploadRoot == null || uploadRoot.isBlank()) {
            return;
        }

        String fileName = imagePath.substring(imagePath.lastIndexOf('/') + 1);
        if (fileName.isBlank()) {
            return;
        }

        File target = new File(uploadRoot + File.separator + EVENTS_DIRECTORY, fileName);
        if (target.exists()) {
            if (!target.delete()) {
                System.err.println("이벤트 이미지 삭제 실패: " + target.getAbsolutePath());
            }
        }
    }
}
