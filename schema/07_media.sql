-- ===
-- Purpose: Media attachments (images, videos, GIFs) for tweets
-- ===

USE twitter_clone;

-- ---
-- Stores metadata for each uploaded media asset.
-- The actual file lives in object storage; this table holds the reference
-- ---
CREATE TABLE media (
    media_id    INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    uploader_id INT UNSIGNED    NOT NULL,
    media_url   VARCHAR(512)    NOT NULL,
    media_type  ENUM('image', 'video', 'gif')  NOT NULL DEFAULT 'image',
    alt_text    VARCHAR(1000)   DEFAULT NULL,
    width_px    SMALLINT UNSIGNED DEFAULT NULL,
    height_px   SMALLINT UNSIGNED DEFAULT NULL,
    file_size_kb INT UNSIGNED   DEFAULT NULL,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (media_id),

    CONSTRAINT fk_media_uploader
        FOREIGN KEY (uploader_id) REFERENCES users (user_id)
        ON DELETE CASCADE
);

-- ---
-- Many-to-many join between tweets and media.
-- display_order controls the order in which media appears in a tweet
-- ---
CREATE TABLE tweet_media (
    tweet_id        INT UNSIGNED    NOT NULL,
    media_id        INT UNSIGNED    NOT NULL,
    display_order   TINYINT UNSIGNED NOT NULL DEFAULT 1,

    PRIMARY KEY (tweet_id, media_id),

    CONSTRAINT fk_tm_tweet
        FOREIGN KEY (tweet_id) REFERENCES tweets (tweet_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_tm_media
        FOREIGN KEY (media_id) REFERENCES media (media_id)
        ON DELETE CASCADE
);
