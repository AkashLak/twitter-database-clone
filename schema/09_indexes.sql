-- ===
-- Purpose: Performance indexes for common query patterns
-- ===

USE twitter_clone;

-- ---
-- tweets: querying a user's timeline and filtering by type/date
-- ---
CREATE INDEX idx_tweets_user_id        ON tweets (user_id);
CREATE INDEX idx_tweets_created_at     ON tweets (created_at);
CREATE INDEX idx_tweets_type           ON tweets (tweet_type);
CREATE INDEX idx_tweets_parent         ON tweets (parent_tweet_id);
CREATE INDEX idx_tweets_user_created   ON tweets (user_id, created_at);

-- ---
-- follows: fast follower/following lookups from either direction
-- ---
CREATE INDEX idx_follows_follower      ON follows (follower_id);
CREATE INDEX idx_follows_following     ON follows (following_id);

-- ---
-- likes: quick per-tweet like counts and per-user like histories
-- ---
CREATE INDEX idx_likes_tweet_id        ON likes (tweet_id);
CREATE INDEX idx_likes_user_id         ON likes (user_id);
CREATE INDEX idx_likes_created_at      ON likes (created_at);

-- ---
-- retweets: quick per-tweet retweet counts
-- ---
CREATE INDEX idx_retweets_tweet_id     ON retweets (tweet_id);
CREATE INDEX idx_retweets_user_id      ON retweets (user_id);
CREATE INDEX idx_retweets_created_at   ON retweets (created_at);

-- ---
-- bookmarks: per-user bookmark lists
-- ---
CREATE INDEX idx_bookmarks_user_id     ON bookmarks (user_id);
CREATE INDEX idx_bookmarks_tweet_id    ON bookmarks (tweet_id);

-- ---
-- tweet_hashtags: hashtag trending and tweet lookups
-- ---
CREATE INDEX idx_th_hashtag_id         ON tweet_hashtags (hashtag_id);

-- ---
-- mentions: who mentions whom, and which tweets contain mentions
-- ---
CREATE INDEX idx_mentions_tweet_id     ON mentions (tweet_id);
CREATE INDEX idx_mentions_user_id      ON mentions (mentioned_user_id);

-- ---
-- notifications: unread notification feeds
-- ---
CREATE INDEX idx_notif_user_read       ON notifications (user_id, is_read);
CREATE INDEX idx_notif_created_at      ON notifications (created_at);

-- ---
-- tweet_views: view count aggregation per tweet
-- ---
CREATE INDEX idx_views_tweet_id        ON tweet_views (tweet_id);
CREATE INDEX idx_views_user_id         ON tweet_views (user_id);
CREATE INDEX idx_views_viewed_at       ON tweet_views (viewed_at);

-- ---
-- media: uploads per user
-- ---
CREATE INDEX idx_media_uploader        ON media (uploader_id);
