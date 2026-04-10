-- ===
-- Purpose: Tweet-level analytics (likes, retweets, replies, and engagement)
-- ===

USE twitter_clone;

-- ---
-- Q1: Tweets with the most likes (top 15)
-- ---
SELECT
    t.tweet_id,
    u.username,
    LEFT(t.content, 80) AS content_preview,
    t.tweet_type,
    COUNT(l.like_id) AS like_count,
    DENSE_RANK() OVER (ORDER BY COUNT(l.like_id) DESC) AS like_rank
FROM tweets t
JOIN users u ON u.user_id = t.user_id
JOIN likes l ON l.tweet_id = t.tweet_id
GROUP BY t.tweet_id, u.username, t.content, t.tweet_type
ORDER BY like_count DESC
LIMIT 15;

-- ---
-- Q2: Tweets with the most retweets (top 15)
-- ---
SELECT
    t.tweet_id,
    u.username,
    LEFT(t.content, 80) AS content_preview,
    t.tweet_type,
    COUNT(r.retweet_id) AS retweet_count,
    DENSE_RANK() OVER (ORDER BY COUNT(r.retweet_id) DESC) AS retweet_rank
FROM tweets t
JOIN users u ON u.user_id = t.user_id
JOIN retweets r ON r.tweet_id = t.tweet_id
GROUP BY t.tweet_id, u.username, t.content, t.tweet_type
ORDER BY retweet_count DESC
LIMIT 15;

-- ---
-- Q3: Tweets with the highest total engagement
--     Engagement = likes + retweets + replies + bookmarks
-- ---
SELECT
    t.tweet_id,
    u.username,
    LEFT(t.content, 80) AS content_preview,
    t.tweet_type,
    t.created_at,
    COALESCE(lc.like_count, 0) AS likes,
    COALESCE(rc.retweet_count, 0) AS retweets,
    COALESCE(rpc.reply_count, 0) AS replies,
    COALESCE(bc.bookmark_count, 0) AS bookmarks,
    COALESCE(lc.like_count, 0)
    + COALESCE(rc.retweet_count, 0)
    + COALESCE(rpc.reply_count, 0)
    + COALESCE(bc.bookmark_count, 0) AS total_engagement
FROM tweets t
JOIN users u ON u.user_id = t.user_id
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
ORDER BY total_engagement DESC
LIMIT 20;

-- ---
-- Q4: Tweets with zero engagement (no likes, retweets, replies, or bookmarks)
--     Useful for identifying dead content or inactive users
-- ---
SELECT
    t.tweet_id,
    u.username,
    LEFT(t.content, 80) AS content_preview,
    t.tweet_type,
    t.created_at
FROM tweets t
JOIN users u ON u.user_id = t.user_id
WHERE t.tweet_id NOT IN (SELECT DISTINCT tweet_id FROM likes)
  AND t.tweet_id NOT IN (SELECT DISTINCT tweet_id FROM retweets)
  AND t.tweet_id NOT IN (SELECT DISTINCT tweet_id FROM bookmarks)
  AND t.tweet_id NOT IN (
      SELECT DISTINCT parent_tweet_id
      FROM tweets
      WHERE tweet_type = 'reply' AND parent_tweet_id IS NOT NULL
  )
ORDER BY t.created_at DESC
LIMIT 20;

-- ---
-- Q5: Tweets with the most replies (identifies discussion-driving content)
-- ---
SELECT
    t.tweet_id,
    u.username,
    LEFT(t.content, 80) AS content_preview,
    t.tweet_type,
    t.created_at,
    COUNT(r.tweet_id) AS reply_count,
    DENSE_RANK() OVER (ORDER BY COUNT(r.tweet_id) DESC) AS reply_rank
FROM tweets t
JOIN users u ON u.user_id = t.user_id
JOIN tweets r ON r.parent_tweet_id = t.tweet_id AND r.tweet_type = 'reply'
GROUP BY t.tweet_id, u.username, t.content, t.tweet_type, t.created_at
ORDER BY reply_count DESC
LIMIT 15;

-- ---
-- Q6: Tweet engagement breakdown by type (original vs reply vs quote)
-- ---
SELECT
    t.tweet_type,
    COUNT(DISTINCT t.tweet_id) AS tweet_count,
    COALESCE(SUM(lc.like_count), 0) AS total_likes,
    COALESCE(SUM(rc.retweet_count), 0) AS total_retweets,
    ROUND(COALESCE(AVG(lc.like_count), 0), 2) AS avg_likes_per_tweet,
    ROUND(COALESCE(AVG(rc.retweet_count), 0), 2) AS avg_retweets_per_tweet
FROM tweets t
LEFT JOIN (
    SELECT tweet_id, COUNT(*) AS like_count
    FROM likes GROUP BY tweet_id
) lc ON lc.tweet_id = t.tweet_id
LEFT JOIN (
    SELECT tweet_id, COUNT(*) AS retweet_count
    FROM retweets GROUP BY tweet_id
) rc ON rc.tweet_id = t.tweet_id
GROUP BY t.tweet_type;

-- ---
-- Q7: Reply threads — show root tweet and how deep the conversation went
--     Shows tweets that spawned at least 2 replies
-- ---
WITH reply_counts AS (
    SELECT
        parent_tweet_id,
        COUNT(*) AS reply_count
    FROM tweets
    WHERE tweet_type = 'reply' AND parent_tweet_id IS NOT NULL
    GROUP BY parent_tweet_id
    HAVING reply_count >= 2
)
SELECT
    t.tweet_id,
    u.username AS original_poster,
    LEFT(t.content, 80) AS original_content,
    t.created_at,
    rc.reply_count
FROM tweets t
JOIN users u ON u.user_id = t.user_id
JOIN reply_counts rc ON rc.parent_tweet_id = t.tweet_id
ORDER BY rc.reply_count DESC;

-- ---
-- Q8: Hourly tweet distribution — what time of day is most active?
-- ---
SELECT
    HOUR(created_at) AS hour_of_day,
    COUNT(*) AS tweet_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_total
FROM tweets
GROUP BY HOUR(created_at)
ORDER BY tweet_count DESC;
