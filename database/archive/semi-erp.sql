
-- schema_multitenant.sql (MySQL 8)
-- KST timezone assumed at application layer.
-- All tables use InnoDB and utf8mb4.
SET NAMES utf8mb4;
SET time_zone = '+09:00';

CREATE TABLE IF NOT EXISTS company (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS branch (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  company_id BIGINT NOT NULL,
  name VARCHAR(100) NOT NULL,
  code VARCHAR(50) NOT NULL,
  active_yn CHAR(1) DEFAULT 'Y',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL,
  UNIQUE KEY uq_branch_company_code (company_id, code),
  KEY idx_branch_company (company_id),
  CONSTRAINT fk_branch_company FOREIGN KEY (company_id) REFERENCES company(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS app_user (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  company_id BIGINT NOT NULL,
  branch_id BIGINT NULL,
  role ENUM('HQ','BRANCH') NOT NULL,
  email VARCHAR(120) UNIQUE,
  pw_hash VARCHAR(255) NOT NULL,
  active_yn CHAR(1) DEFAULT 'Y',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL,
  KEY idx_user_company (company_id),
  KEY idx_user_branch (branch_id),
  CONSTRAINT fk_user_company FOREIGN KEY (company_id) REFERENCES company(id),
  CONSTRAINT fk_user_branch FOREIGN KEY (branch_id) REFERENCES branch(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS material (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  company_id BIGINT NOT NULL,
  name VARCHAR(120) NOT NULL,
  unit VARCHAR(30) NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  img_path VARCHAR(255),
  step DECIMAL(12,2) DEFAULT 1,
  active_yn CHAR(1) DEFAULT 'Y',
  deleted_yn CHAR(1) DEFAULT 'N',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL,
  UNIQUE KEY uq_material_company_name (company_id, name),
  KEY idx_material_company (company_id),
  UNIQUE KEY uq_material_company_id (company_id, id),
  CONSTRAINT fk_material_company FOREIGN KEY (company_id) REFERENCES company(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS menu (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  company_id BIGINT NOT NULL,
  name VARCHAR(120) NOT NULL,
  price DECIMAL(12,0) NOT NULL,
  img_path VARCHAR(255),
  active_yn CHAR(1) DEFAULT 'Y',
  deleted_yn CHAR(1) DEFAULT 'N',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL,
  UNIQUE KEY uq_menu_company_name (company_id, name),
  KEY idx_menu_company (company_id),
  UNIQUE KEY uq_menu_company_id (company_id, id),
  CONSTRAINT fk_menu_company FOREIGN KEY (company_id) REFERENCES company(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE menu
DROP CONSTRAINT uq_menu_company_name;

CREATE TABLE IF NOT EXISTS menu_ingredient (
  company_id BIGINT NOT NULL,
  menu_id BIGINT NOT NULL,
  material_id BIGINT NOT NULL,
  qty DECIMAL(12,3) NOT NULL,
  PRIMARY KEY (company_id, menu_id, material_id),
  KEY idx_mi_menu (menu_id),
  KEY idx_mi_material (material_id),
  CONSTRAINT fk_mi_menu FOREIGN KEY (company_id, menu_id) REFERENCES menu(company_id, id) ON DELETE CASCADE,
  CONSTRAINT fk_mi_material FOREIGN KEY (company_id, material_id) REFERENCES material(company_id, id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS branch_inventory (
  company_id BIGINT NOT NULL,
  branch_id BIGINT NOT NULL,
  material_id BIGINT NOT NULL,
  qty DECIMAL(12,2) NOT NULL DEFAULT 0,
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (company_id, branch_id, material_id),
  KEY idx_bi_branch (branch_id),
  KEY idx_bi_material (material_id),
  CONSTRAINT fk_bi_branch FOREIGN KEY (company_id, branch_id) REFERENCES branch(company_id, id) ON DELETE CASCADE,
  CONSTRAINT fk_bi_material FOREIGN KEY (company_id, material_id) REFERENCES material(company_id, id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS branch_menu_toggle (
  company_id BIGINT NOT NULL,
  branch_id BIGINT NOT NULL,
  menu_id BIGINT NOT NULL,
  enabled CHAR(1) NOT NULL DEFAULT 'Y',
  updated_at TIMESTAMP NULL,
  PRIMARY KEY (company_id, branch_id, menu_id),
  KEY idx_bmt_branch (branch_id),
  KEY idx_bmt_menu (menu_id),
  CONSTRAINT fk_bmt_branch FOREIGN KEY (company_id, branch_id) REFERENCES branch(company_id, id) ON DELETE CASCADE,
  CONSTRAINT fk_bmt_menu FOREIGN KEY (company_id, menu_id) REFERENCES menu(company_id, id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS purchase_order (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  company_id BIGINT NOT NULL,
  branch_id BIGINT NOT NULL,
  status ENUM('REQUESTED','APPROVED','REJECTED','RECEIVED') NOT NULL DEFAULT 'REQUESTED',
  total_price DECIMAL(14,0) NOT NULL DEFAULT 0,
  ordered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL,
  KEY idx_po_company (company_id),
  KEY idx_po_branch (branch_id),
  CONSTRAINT fk_po_branch FOREIGN KEY (company_id, branch_id) REFERENCES branch(company_id, id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS purchase_order_line (
  company_id BIGINT NOT NULL,
  order_id BIGINT NOT NULL,
  line_no INT NOT NULL,
  material_id BIGINT NOT NULL,
  qty DECIMAL(12,2) NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (company_id, order_id, line_no),
  KEY idx_pol_order (order_id),
  KEY idx_pol_material (material_id),
  CONSTRAINT fk_pol_order FOREIGN KEY (company_id, order_id) REFERENCES purchase_order(company_id, id) ON DELETE CASCADE,
  CONSTRAINT fk_pol_material FOREIGN KEY (company_id, material_id) REFERENCES material(company_id, id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- View-like helper query for inventory page (LEFT JOIN to show 0 qty)
-- Example SELECT:
-- SELECT m.id, m.name, m.unit, m.unit_price,
--        COALESCE(bi.qty, 0) AS qty
-- FROM material m
-- LEFT JOIN branch_inventory bi
--   ON bi.company_id = :companyId AND bi.branch_id = :branchId AND bi.material_id = m.id
-- WHERE m.company_id = :companyId AND m.deleted_yn = 'N' AND m.active_yn = 'Y'
-- ORDER BY m.name;

