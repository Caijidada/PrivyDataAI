-- 创建数据库
CREATE DATABASE IF NOT EXISTS data_platform DEFAULT CHARACTER SET utf8mb4;

USE data_platform;

-- 用户表
CREATE TABLE `sys_user` (
                            `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
                            `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
                            `password` VARCHAR(100) NOT NULL COMMENT '密码(BCrypt加密)',
                            `email` VARCHAR(100) UNIQUE COMMENT '邮箱',
                            `real_name` VARCHAR(50) COMMENT '真实姓名',
                            `role` VARCHAR(20) NOT NULL DEFAULT 'user' COMMENT '角色: admin/analyst/user',
                            `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0停用 1正常',
                            `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
                            `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                            INDEX idx_username (username),
                            INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 插入默认管理员账号 (密码: admin123)
INSERT INTO `sys_user` (`username`, `password`, `email`, `real_name`, `role`)
VALUES ('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', 'admin@example.com', '管理员', 'admin');

-- 数据源表
CREATE TABLE `data_source` (
                               `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
                               `name` VARCHAR(100) NOT NULL COMMENT '数据源名称',
                               `type` VARCHAR(20) NOT NULL COMMENT '类型: mysql/postgresql',
                               `host` VARCHAR(100) NOT NULL COMMENT '主机地址',
                               `port` INT NOT NULL COMMENT '端口',
                               `database_name` VARCHAR(100) NOT NULL COMMENT '数据库名',
                               `username` VARCHAR(100) NOT NULL COMMENT '用户名',
                               `password` VARCHAR(200) NOT NULL COMMENT '密码(加密)',
                               `description` TEXT COMMENT '描述',
                               `creator_id` BIGINT NOT NULL COMMENT '创建人ID',
                               `status` TINYINT DEFAULT 1 COMMENT '状态: 0禁用 1启用',
                               `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
                               `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                               FOREIGN KEY (creator_id) REFERENCES sys_user(id),
                               INDEX idx_creator (creator_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数据源表';

-- 元数据表
CREATE TABLE `metadata_table` (
                                  `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
                                  `datasource_id` BIGINT NOT NULL COMMENT '数据源ID',
                                  `table_name` VARCHAR(100) NOT NULL COMMENT '表名',
                                  `table_comment` VARCHAR(500) COMMENT '表注释',
                                  `business_name` VARCHAR(100) COMMENT '业务名称',
                                  `sync_time` DATETIME COMMENT '同步时间',
                                  FOREIGN KEY (datasource_id) REFERENCES data_source(id),
                                  UNIQUE KEY uk_datasource_table (datasource_id, table_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='元数据-表';

-- 元数据列
CREATE TABLE `metadata_column` (
                                   `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
                                   `table_id` BIGINT NOT NULL COMMENT '表ID',
                                   `column_name` VARCHAR(100) NOT NULL COMMENT '字段名',
                                   `column_type` VARCHAR(50) NOT NULL COMMENT '字段类型',
                                   `column_comment` VARCHAR(500) COMMENT '字段注释',
                                   `business_name` VARCHAR(100) COMMENT '业务名称',
                                   `is_sensitive` TINYINT DEFAULT 0 COMMENT '是否敏感字段',
                                   FOREIGN KEY (table_id) REFERENCES metadata_table(id),
                                   INDEX idx_table (table_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='元数据-字段';

-- 看板表
CREATE TABLE `dashboard` (
                             `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
                             `name` VARCHAR(100) NOT NULL COMMENT '看板名称',
                             `description` TEXT COMMENT '描述',
                             `datasource_id` BIGINT NOT NULL COMMENT '关联数据源',
                             `creator_id` BIGINT NOT NULL COMMENT '创建人',
                             `is_shared` TINYINT DEFAULT 0 COMMENT '是否共享',
                             `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
                             `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                             FOREIGN KEY (datasource_id) REFERENCES data_source(id),
                             FOREIGN KEY (creator_id) REFERENCES sys_user(id),
                             INDEX idx_creator (creator_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='看板表';

-- 图表组件表
CREATE TABLE `widget` (
                          `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
                          `dashboard_id` BIGINT NOT NULL COMMENT '所属看板',
                          `type` VARCHAR(50) NOT NULL COMMENT '图表类型',
                          `title` VARCHAR(200) COMMENT '标题',
                          `config` JSON COMMENT '图表配置',
                          `position` JSON COMMENT '位置信息',
                          `sql` TEXT COMMENT 'SQL语句',
                          `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
                          `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                          FOREIGN KEY (dashboard_id) REFERENCES dashboard(id) ON DELETE CASCADE,
                          INDEX idx_dashboard (dashboard_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='图表组件表';

-- 查询历史表
CREATE TABLE `query_history` (
                                 `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
                                 `user_id` BIGINT NOT NULL COMMENT '用户ID',
                                 `datasource_id` BIGINT NOT NULL COMMENT '数据源ID',
                                 `question` TEXT COMMENT '原始问题',
                                 `sql` TEXT NOT NULL COMMENT '生成的SQL',
                                 `status` VARCHAR(20) NOT NULL COMMENT '状态',
                                 `execute_time` INT COMMENT '执行时间(ms)',
                                 `row_count` INT COMMENT '返回行数',
                                 `error_msg` TEXT COMMENT '错误信息',
                                 `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
                                 FOREIGN KEY (user_id) REFERENCES sys_user(id),
                                 FOREIGN KEY (datasource_id) REFERENCES data_source(id),
                                 INDEX idx_user_time (user_id, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='查询历史表';