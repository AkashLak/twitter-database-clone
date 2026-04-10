-- ===
-- Purpose: Tweet content - originals, replies, and quote tweets
-- ===

USE twitter_clone;

-- ---
-- Unified content table. tweet_type distinguishes originals, replies, and
-- quote tweets. Self-referencing parent_tweet_id supports threaded replies.
-- quoted_tweet_id references the tweet being quote-retweeted
-- ---
CREATE TABLE tweets (
    tweet_id        INT UNSIGNED     NOT NULL AUTO_INCREMENT,
    user_id         INT UNSIGNED     NOT NULL,
    content         VARCHAR(280)     NOT NULL,
    tweet_type      ENUM('original', 'reply', 'quote') NOT NULL DEFAULT 'original',
    parent_tweet_id INT UNSIGNED     DEFAULT NULL,   -- set when tweet_type = 'reply'
    quoted_tweet_id INT UNSIGNED     DEFAULT NULL,   -- set when tweet_type = 'quote'
    is_deleted      TINYINT(1)       NOT NULL DEFAULT 0,
    created_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (tweet_id),

    CONSTRAINT fk_tweet_user
        FOREIGN KEY (user_id) REFERENCES users (user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_tweet_parent
        FOREIGN KEY (parent_tweet_id) REFERENCES tweets (tweet_id)
        ON DELETE SET NULL,

    CONSTRAINT fk_tweet_quoted
        FOREIGN KEY (quoted_tweet_id) REFERENCES tweets (tweet_id)
        ON DELETE SET NULL
);
