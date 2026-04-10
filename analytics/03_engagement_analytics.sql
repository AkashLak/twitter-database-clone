-- ===
-- Purpose: User engagement patterns (who drives interaction, who receives it,
--          and who has generated none)
-- ===

USE twitter_clone;

-- ---
-- Q1: Users who have never received a single like on any of their tweets
-- ---
SELECT
    u.user_id,
    u.username,
    up.display_name,
    COUNT(t.tweet_id) AS tweet_count,
    u.created_at AS registered_at
FROM users u
JOIN user_profiles up ON up.user_id = u.user_id
JOIN tweets t ON t.user_id = u.user_id
WHERE u.user_id NOT IN (
    SELECT DISTINCT t2.user_id
    FROM tweets t2
    JOIN likes l ON l.tweet_id = t2.tweet_id
)
GROUP BY u.user_id, u.username, up.display_name, u.created_at
ORDER BY tweet_count DESC;

-- ---
-- Q2: Users whose tweets generate the most total engagement
--     Engagement = all likes + retweets + replies + bookmarks received
-- ---
SELECT
    u.user_id,
    u.username,
    up.display_name,
    COUNT(DISTINCT t.tweet_id) AS tweets_posted,
    COALESCE(SUM(lc.like_count), 0) AS total_likes_received,
    COALESCE(SUM(rc.retweet_count), 0) AS total_retweets_received,
    COALESCE(SUM(rpc.reply_count), 0) AS total_replies_received,
    COALESCE(SUM(bc.bookmark_count),0) AS total_bookmarks_received,
    COALESCE(SUM(lc.like_count), 0)
    + COALESCE(SUM(rc.retweet_count), 0)
    + COALESCE(SUM(rpc.reply_count), 0)
    + COALESCE(SUM(bc.bookmark_count), 0) AS total_engagement,
    DENSE_RANK() OVER (
        ORDER BY
            COALESCE(SUM(lc.like_count), 0)
          + COALESCE(SUM(rc.retweet_count), 0)
          + COALESCE(SUM(rpc.reply_count), 0)
          + COALESCE(SUM(bc.bookmark_count), 0) DESC
    ) AS engagement_rank
FROM users u
JOIN user_profiles up ON up.user_id = u.user_id
JOIN tweets t ON t.user_id = u.user_id
LEFT JOIN (
    SELECT tweet_id, COUNT(*) AS like_count
    FROM likes GROUP BY tweet_id
) lc  ON lc.tweet_id = t.tweet_id
LEFT JOIN (
    SELECT tweet_id, COUNT(*) AS retweet_count
    FROM retweets GROUP BY tweet_id
) rc  ON rc.tweet_id = t.tweet_id
LEFT JOIN (
    SELECT parent_tweet_id, COUNT(*) AS reply_count
    FROM tweets WHERE tweet_type = 'reply' AND parent_tweet_id IS NOT NULL
    GROUP BY parent_tweet_id
) rpc ON rpc.parent_tweet_id = t.tweet_id
LEFT JOIN (
    SELECT tweet_id, COUNT(*) AS bookmark_count
    FROM bookmarks GROUP BY tweet_id
) bc  ON bc.tweet_id = t.tweet_id
GROUP BY u.user_id, u.username, up.display_name
ORDER BY total_engagement DESC
LIMIT 20;

-- ---
-- Q3: Users with the highest engagement-per-tweet ratio
--     Filters to users with at least 3 tweets to avoid single-tweet outliers
-- ---
WITH user_engagement AS (
    SELECT
        t.user_id,
        COUNT(DISTINCT t.tweet_id) AS tweet_count,
        COALESCE(SUM(lc.like_count), 0)
        + COALESCE(SUM(rc.retweet_count), 0)
        + COALESCE(SUM(bc.bookmark_count), 0) AS total_engagement
    FROM tweets t
    LEFT JOIN (
        SELECT tweet_id, COUNT(*) AS like_count
        FROM likes GROUP BY tweet_id
    ) lc ON lc.tweet_id = t.tweet_id
    LEFT JOIN (
        SELECT tweet_id, COUNT(*) AS retweet_count
        FROM retweets GROUP BY tweet_id
    ) rc ON rc.tweet_id = t.tweet_id
    LEFT JOIN (
        SELECT tweet_id, COUNT(*) AS bookmark_count
        FROM bookmarks GROUP BY tweet_id
    ) bc ON bc.tweet_id = t.tweet_id
    GROUP BY t.user_id
    HAVING tweet_count >= 3
)
SELECT
    u.user_id,
    u.username,
    up.display_name,
    ue.tweet_count,
    ue.total_engagement,
    ROUND(ue.total_engagement / ue.tweet_count, 2) AS engagement_per_tweet
FROM user_engagement ue
JOIN users u ON u.user_id = ue.user_id
JOIN user_profiles up ON up.user_id = ue.user_id
ORDER BY engagement_per_tweet DESC
LIMIT 15;

-- ---
-- Q4: Users mentioned most often in tweets
-- ---
SELECT
    u.user_id,
    u.username,
    up.display_name,
    COUNT(m.mention_id) AS times_mentioned,
    DENSE_RANK() OVER (ORDER BY COUNT(m.mention_id) DESC) AS mention_rank
FROM users u
JOIN user_profiles up ON up.user_id = u.user_id
JOIN mentions m ON m.mentioned_user_id = u.user_id
GROUP BY u.user_id, u.username, up.display_name
ORDER BY times_mentioned DESC
LIMIT 15;

-- ---
-- Q5: Possible bot-like accounts — users who like or retweet at abnormally
--     high rates. Flags accounts where:
--       - likes > 2 standard deviations above the mean, OR
--       - retweets > 2 standard deviations above the mean
-- ---
WITH activity_stats AS (
    SELECT
        AVG(like_count) AS avg_likes,
        STDDEV(like_count) AS std_likes,
        AVG(rt_count) AS avg_rts,
        STDDEV(rt_count) AS std_rts
    FROM (
        SELECT
            u.user_id,
            COUNT(DISTINCT l.like_id) AS like_count,
            COUNT(DISTINCT rt.retweet_id) AS rt_count
        FROM users u
        LEFT JOIN likes l ON l.user_id = u.user_id
        LEFT JOIN retweets rt ON rt.user_id = u.user_id
        GROUP BY u.user_id
    ) AS per_user
),
per_user_activity AS (
    SELECT
        u.user_id,
        u.username,
        COUNT(DISTINCT l.like_id) AS like_count,
        COUNT(DISTINCT rt.retweet_id) AS rt_count
    FROM users u
    LEFT JOIN likes l ON l.user_id = u.user_id
    LEFT JOIN retweets rt ON rt.user_id = u.user_id
    GROUP BY u.user_id, u.username
)
SELECT
    pua.user_id,
    pua.username,
    pua.like_count,
    pua.rt_count,
    ROUND(s.avg_likes, 1) AS avg_likes_platform,
    ROUND(s.avg_rts, 1) AS avg_rts_platform,
    ROUND((pua.like_count - s.avg_likes) / NULLIF(s.std_likes, 0), 2) AS like_z_score,
    ROUND((pua.rt_count - s.avg_rts) / NULLIF(s.std_rts, 0), 2) AS rt_z_score,
    CASE
        WHEN (pua.like_count - s.avg_likes) / NULLIF(s.std_likes, 0) > 2
          OR (pua.rt_count - s.avg_rts) / NULLIF(s.std_rts, 0) > 2
        THEN 'FLAGGED'
        ELSE 'normal'
    END AS bot_flag
FROM per_user_activity pua
CROSS JOIN activity_stats s
ORDER BY like_z_score DESC, rt_z_score DESC
LIMIT 20;

-- ---
-- Q6: Users who follow many accounts but have very few followers
--     Classic signal for fake or bot accounts
--     Threshold: following >= 10, follower_count <= 2
-- ---
SELECT
    u.user_id,
    u.username,
    up.display_name,
    following_count,
    follower_count,
    ROUND(following_count / NULLIF(follower_count, 0), 1) AS follow_ratio
FROM (
    SELECT
        u.user_id,
        COUNT(DISTINCT f_out.following_id) AS following_count,
        COUNT(DISTINCT f_in.follower_id) AS follower_count
    FROM users u
    LEFT JOIN follows f_out ON f_out.follower_id = u.user_id
    LEFT JOIN follows f_in ON f_in.following_id = u.user_id
    GROUP BY u.user_id
) AS counts
JOIN users u ON u.user_id = counts.user_id
JOIN user_profiles up ON up.user_id = counts.user_id
WHERE following_count >= 10
    AND follower_count <= 2
ORDER BY follow_ratio DESC;
