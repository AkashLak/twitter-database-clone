-- ===
-- Purpose: User mentions extracted from tweet content
-- ===

USE twitter_clone;

-- ---
-- Stores @username references parsed from tweet content.
-- A single tweet can mention multiple users, but each user only once per tweet.
-- mentioned_user_id links to the users table for JOIN-based queries
-- ---
CREATE TABLE mentions (
    mention_id          INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    tweet_id            INT UNSIGNED    NOT NULL,
    mentioned_user_id   INT UNSIGNED    NOT NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (mention_id),
    UNIQUE KEY uq_mention (tweet_id, mentioned_user_id),

    CONSTRAINT fk_mention_tweet
        FOREIGN KEY (tweet_id) REFERENCES tweets (tweet_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_mention_user
        FOREIGN KEY (mentioned_user_id) REFERENCES users (user_id)
        ON DELETE CASCADE
);
