-- ===
-- Purpose: Core social graph - follows, likes, retweets, and bookmarks
-- ===

USE twitter_clone;

-- ---
-- Directed graph edge: follower_id follows following_id.
-- Composite unique key prevents duplicate follow relationships.
-- A user cannot follow themselves
-- ---
CREATE TABLE follows (
    follow_id      INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    follower_id    INT UNSIGNED    NOT NULL,
    following_id   INT UNSIGNED    NOT NULL,
    created_at     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (follow_id),
    UNIQUE KEY uq_follow (follower_id, following_id),

    CONSTRAINT fk_follow_follower
        FOREIGN KEY (follower_id) REFERENCES users (user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_follow_following
        FOREIGN KEY (following_id) REFERENCES users (user_id)
        ON DELETE CASCADE
);

-- ---
-- Records a single user liking a single tweet.
-- Composite unique key prevents duplicate likes
-- ---
CREATE TABLE likes (
    like_id     INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    user_id     INT UNSIGNED    NOT NULL,
    tweet_id    INT UNSIGNED    NOT NULL,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (like_id),
    UNIQUE KEY uq_like (user_id, tweet_id),

    CONSTRAINT fk_like_user
        FOREIGN KEY (user_id) REFERENCES users (user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_like_tweet
        FOREIGN KEY (tweet_id) REFERENCES tweets (tweet_id)
        ON DELETE CASCADE
);

-- ---
-- Records a user retweeting a tweet (simple retweet, not quote tweet).
-- Quote tweets are modeled as a tweet with tweet_type = 'quote'
-- ---
CREATE TABLE retweets (
    retweet_id  INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    user_id     INT UNSIGNED    NOT NULL,
    tweet_id    INT UNSIGNED    NOT NULL,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (retweet_id),
    UNIQUE KEY uq_retweet (user_id, tweet_id),

    CONSTRAINT fk_retweet_user
        FOREIGN KEY (user_id) REFERENCES users (user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_retweet_tweet
        FOREIGN KEY (tweet_id) REFERENCES tweets (tweet_id)
        ON DELETE CASCADE
);

-- ---
-- Private saves. A user can bookmark any tweet once
-- ---
CREATE TABLE bookmarks (
    bookmark_id INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    user_id     INT UNSIGNED    NOT NULL,
    tweet_id    INT UNSIGNED    NOT NULL,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (bookmark_id),
    UNIQUE KEY uq_bookmark (user_id, tweet_id),

    CONSTRAINT fk_bookmark_user
        FOREIGN KEY (user_id) REFERENCES users (user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_bookmark_tweet
        FOREIGN KEY (tweet_id) REFERENCES tweets (tweet_id)
        ON DELETE CASCADE
);
