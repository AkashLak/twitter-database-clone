-- ===
-- Purpose: Extended platform features - notifications, blocks, mutes,
--          tweet views, lists, and list membership
-- ===

USE twitter_clone;

-- ---
-- Tracks in-platform events surfaced to users.
-- actor_id is the user who caused the notification.
-- tweet_id is nullable — follow notifications have no associated tweet
-- ---
CREATE TABLE notifications (
    notification_id INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    user_id         INT UNSIGNED    NOT NULL,   -- recipient
    actor_id        INT UNSIGNED    NOT NULL,   -- who triggered it
    notification_type ENUM('like', 'retweet', 'follow', 'mention', 'reply', 'quote') NOT NULL,
    tweet_id        INT UNSIGNED    DEFAULT NULL,
    is_read         TINYINT(1)      NOT NULL DEFAULT 0,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (notification_id),

    CONSTRAINT fk_notif_user
        FOREIGN KEY (user_id) REFERENCES users (user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_notif_actor
        FOREIGN KEY (actor_id) REFERENCES users (user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_notif_tweet
        FOREIGN KEY (tweet_id) REFERENCES tweets (tweet_id)
        ON DELETE CASCADE
);

-- ---
-- One-directional block: blocker_id has blocked blocked_id.
-- Prevents content visibility and interaction in both directions
-- ---
CREATE TABLE blocks (
    block_id    INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    blocker_id  INT UNSIGNED    NOT NULL,
    blocked_id  INT UNSIGNED    NOT NULL,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (block_id),
    UNIQUE KEY uq_block (blocker_id, blocked_id),

    CONSTRAINT fk_block_blocker
        FOREIGN KEY (blocker_id) REFERENCES users (user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_block_blocked
        FOREIGN KEY (blocked_id) REFERENCES users (user_id)
        ON DELETE CASCADE
);

-- ---
-- Soft suppression: muter_id will not see content from muted_id,
-- but the relationship is not visible to the muted user
-- ---
CREATE TABLE muted_users (
    mute_id     INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    muter_id    INT UNSIGNED    NOT NULL,
    muted_id    INT UNSIGNED    NOT NULL,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (mute_id),
    UNIQUE KEY uq_mute (muter_id, muted_id),

    CONSTRAINT fk_mute_muter
        FOREIGN KEY (muter_id) REFERENCES users (user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_mute_muted
        FOREIGN KEY (muted_id) REFERENCES users (user_id)
        ON DELETE CASCADE
);

-- ---
-- Impression tracking. user_id is nullable to allow anonymous views.
-- High-volume table — designed for append-only writes
-- ---
CREATE TABLE tweet_views (
    view_id     BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    tweet_id    INT UNSIGNED     NOT NULL,
    user_id     INT UNSIGNED     DEFAULT NULL,
    viewed_at   DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (view_id),

    CONSTRAINT fk_view_tweet
        FOREIGN KEY (tweet_id) REFERENCES tweets (tweet_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_view_user
        FOREIGN KEY (user_id) REFERENCES users (user_id)
        ON DELETE SET NULL
);

-- ---
-- Curated lists of accounts. Can be public or private
-- ---
CREATE TABLE lists (
    list_id     INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    owner_id    INT UNSIGNED    NOT NULL,
    name        VARCHAR(100)    NOT NULL,
    description VARCHAR(255)    DEFAULT NULL,
    is_private  TINYINT(1)      NOT NULL DEFAULT 0,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (list_id),

    CONSTRAINT fk_list_owner
        FOREIGN KEY (owner_id) REFERENCES users (user_id)
        ON DELETE CASCADE
);

-- ---
-- Membership table connecting users to lists they belong to
-- ---
CREATE TABLE list_members (
    list_id     INT UNSIGNED    NOT NULL,
    user_id     INT UNSIGNED    NOT NULL,
    added_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (list_id, user_id),

    CONSTRAINT fk_lm_list
        FOREIGN KEY (list_id) REFERENCES lists (list_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_lm_user
        FOREIGN KEY (user_id) REFERENCES users (user_id)
        ON DELETE CASCADE
);
