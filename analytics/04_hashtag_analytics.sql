-- ===
-- Purpose: Hashtag trend analysis and co-occurrence patterns
-- ===

USE twitter_clone;

-- ---
-- Q1: Most frequently used hashtags across all tweets
-- ---
SELECT
    h.hashtag_id,
    h.tag,
    COUNT(th.tweet_id) AS usage_count,
    RANK() OVER (ORDER BY COUNT(th.tweet_id) DESC) AS usage_rank
FROM hashtags h
JOIN tweet_hashtags th ON th.hashtag_id = h.hashtag_id
GROUP BY h.hashtag_id, h.tag
ORDER BY usage_count DESC
LIMIT 20;

-- ---
-- Q2: Hashtags with the highest average engagement on tagged tweets
--     (average likes + retweets per tweet that uses this hashtag)
-- ---
SELECT
    h.tag,
    COUNT(DISTINCT th.tweet_id) AS tagged_tweet_count,
    COALESCE(SUM(lc.like_count), 0) AS total_likes,
    COALESCE(SUM(rc.retweet_count), 0) AS total_retweets,
    ROUND(
        (COALESCE(SUM(lc.like_count), 0) + COALESCE(SUM(rc.retweet_count), 0))
        / NULLIF(COUNT(DISTINCT th.tweet_id), 0), 2) AS avg_engagement_per_tweet
FROM hashtags h
JOIN tweet_hashtags th ON th.hashtag_id = h.hashtag_id
LEFT JOIN (
    SELECT tweet_id, COUNT(*) AS like_count FROM likes GROUP BY tweet_id
) lc ON lc.tweet_id = th.tweet_id
LEFT JOIN (
    SELECT tweet_id, COUNT(*) AS retweet_count FROM retweets GROUP BY tweet_id
) rc ON rc.tweet_id = th.tweet_id
GROUP BY h.tag
HAVING tagged_tweet_count >= 2
ORDER BY avg_engagement_per_tweet DESC;

-- ---
-- Q3: Most common hashtag pairings (co-occurrence in the same tweet)
--     Uses a self-join on tweet_hashtags to find pairs that appear together
-- ---
SELECT
    h1.tag AS hashtag_a,
    h2.tag AS hashtag_b,
    COUNT(*) AS co_occurrence_count
FROM tweet_hashtags th1
JOIN tweet_hashtags th2 ON th2.tweet_id = th1.tweet_id
     AND th2.hashtag_id > th1.hashtag_id  -- avoids duplicates
JOIN hashtags h1 ON h1.hashtag_id = th1.hashtag_id
JOIN hashtags h2 ON h2.hashtag_id = th2.hashtag_id
GROUP BY h1.tag, h2.tag
HAVING co_occurrence_count >= 1
ORDER BY co_occurrence_count DESC
LIMIT 20;

-- ---
-- Q4: Users who use the most distinct hashtags (creative breadth)
-- ---
SELECT
    u.user_id,
    u.username,
    up.display_name,
    COUNT(DISTINCT th.hashtag_id) AS distinct_hashtags_used,
    COUNT(th.tweet_id) AS total_hashtag_uses
FROM users u
JOIN user_profiles up ON up.user_id  = u.user_id
JOIN tweets t ON t.user_id = u.user_id
JOIN tweet_hashtags th ON th.tweet_id = t.tweet_id
GROUP BY u.user_id, u.username, up.display_name
ORDER BY distinct_hashtags_used DESC
LIMIT 10;

-- ---
-- Q5: Hashtags introduced each month (when did tags first appear?)
-- ---
SELECT
    DATE_FORMAT(created_at, '%Y-%m') AS first_month,
    COUNT(*) AS new_hashtags
FROM hashtags
GROUP BY DATE_FORMAT(created_at, '%Y-%m')
ORDER BY first_month;

-- ---
-- Q6: Hashtag reach (distinct users who used each hashtag)
-- ---
SELECT
    h.tag,
    COUNT(DISTINCT t.user_id) AS unique_users,
    COUNT(th.tweet_id) AS total_uses,
    ROUND(COUNT(th.tweet_id) / NULLIF(COUNT(DISTINCT t.user_id), 0), 2) AS uses_per_user
FROM hashtags h
JOIN tweet_hashtags th ON th.hashtag_id = h.hashtag_id
JOIN tweets t  ON t.tweet_id = th.tweet_id
GROUP BY h.tag
ORDER BY unique_users DESC
LIMIT 15;
