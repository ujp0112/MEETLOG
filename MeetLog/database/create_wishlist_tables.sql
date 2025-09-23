USE meetlog;

-- 사용자 저장소 테이블 (찜 폴더)
CREATE TABLE user_storages (
    storage_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    color_class VARCHAR(50) DEFAULT 'bg-blue-100',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_storages_user_id (user_id),
    INDEX idx_user_storages_created_at (created_at DESC)
);

-- 사용자 저장소 아이템 테이블
CREATE TABLE user_storage_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    storage_id INT NOT NULL,
    item_type ENUM('RESTAURANT', 'COURSE', 'COLUMN') NOT NULL,
    content_id INT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (storage_id) REFERENCES user_storages(storage_id) ON DELETE CASCADE,
    INDEX idx_storage_items_storage_id (storage_id),
    INDEX idx_storage_items_type_content (item_type, content_id),
    INDEX idx_storage_items_added_at (added_at DESC),
    UNIQUE KEY unique_storage_item (storage_id, item_type, content_id)
);

-- 기본 저장소 생성 (모든 기존 사용자에 대해)
INSERT INTO user_storages (user_id, name, color_class)
SELECT id, '내가 찜한 로그', 'bg-blue-100'
FROM users 
WHERE NOT EXISTS (
    SELECT 1 FROM user_storages WHERE user_storages.user_id = users.id
);
