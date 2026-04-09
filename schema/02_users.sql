-- ===
-- Purpose: Core user identity and profile tables
-- ===

USE twitter_clone;

-- ---
-- Central identity table. Stores credentials, flags, and registration time.
-- Display names and bios live in user_profiles (extended data)
-- ---
CREATE TABLE users (
    user_id        INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    username       VARCHAR(50)     NOT NULL,
    email          VARCHAR(255)    NOT NULL,
    password_hash  VARCHAR(255)    NOT NULL,
    is_verified    TINYINT(1)      NOT NULL DEFAULT 0,
    is_private     TINYINT(1)      NOT NULL DEFAULT 0,
    is_suspended   TINYINT(1)      NOT NULL DEFAULT 0,
    is_bot         TINYINT(1)      NOT NULL DEFAULT 0,
    created_at     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (user_id),
    UNIQUE KEY uq_username (username),
    UNIQUE KEY uq_email    (email)
);

-- ---
-- One-to-one extension of users. Keeps the users table lean
-- ---
CREATE TABLE user_profiles (
    user_id          INT UNSIGNED    NOT NULL,
    display_name     VARCHAR(100)    NOT NULL,
    bio              VARCHAR(160)    DEFAULT NULL,
    location         VARCHAR(100)    DEFAULT NULL,
    website_url      VARCHAR(255)    DEFAULT NULL,
    profile_image_url VARCHAR(255)   DEFAULT NULL,
    header_image_url  VARCHAR(255)   DEFAULT NULL,
    birth_date       DATE            DEFAULT NULL,

    PRIMARY KEY (user_id),
    CONSTRAINT fk_profile_user
        FOREIGN KEY (user_id) REFERENCES users (user_id)
        ON DELETE CASCADE
);
