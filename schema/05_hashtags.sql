-- ===
-- Purpose: Hashtag normalization and tweet-hashtag join table
-- ===

USE twitter_clone;

-- ---
-- Stores each unique hashtag exactly once (lowercased at insert time).
-- created_at records when the tag first appeared on the platform
-- ---
CREATE TABLE hashtags (
    hashtag_id  INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    tag         VARCHAR(100)    NOT NULL,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (hashtag_id),
    UNIQUE KEY uq_tag (tag)
);

-- ---
-- tweet_hashtags
-- Many-to-many join between tweets and hashtags.
-- Composite primary key is also the uniqueness constraint
-- ---
CREATE TABLE tweet_hashtags (
    tweet_id    INT UNSIGNED    NOT NULL,
    hashtag_id  INT UNSIGNED    NOT NULL,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (tweet_id, hashtag_id),

    CONSTRAINT fk_th_tweet
        FOREIGN KEY (tweet_id) REFERENCES tweets (tweet_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_th_hashtag
        FOREIGN KEY (hashtag_id) REFERENCES hashtags (hashtag_id)
        ON DELETE CASCADE
);
