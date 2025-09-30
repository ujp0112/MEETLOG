-- 추천 성능 메트릭 테이블 생성

CREATE TABLE IF NOT EXISTS `recommendation_metrics` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NOT NULL,
  `recommendation_count` INT(11) NOT NULL,
  `avg_score` DOUBLE DEFAULT 0.0,
  `category_diversity` INT(11) DEFAULT 0,
  `timestamp` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `timestamp` (`timestamp`),
  CONSTRAINT `recommendation_metrics_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 추천 메트릭 상세 테이블 (개별 추천 항목 저장)
CREATE TABLE IF NOT EXISTS `recommendation_items` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `metric_id` INT(11) NOT NULL,
  `restaurant_id` INT(11) NOT NULL,
  `recommendation_score` DOUBLE DEFAULT 0.0,
  `predicted_rating` DOUBLE DEFAULT 0.0,
  `reason` VARCHAR(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `metric_id` (`metric_id`),
  KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `recommendation_items_ibfk_1` FOREIGN KEY (`metric_id`) REFERENCES `recommendation_metrics` (`id`) ON DELETE CASCADE,
  CONSTRAINT `recommendation_items_ibfk_2` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;