-- ===
-- Purpose: Advanced cross-domain queries (social graph analysis, content
--          quality scoring, influencer identification, and temporal patterns)
-- ===

USE twitter_clone;

-- ---
-- Q1: Full engagement scorecard per user
--     Combines content produced, reach, and social graph into one view.
--     Useful as a unified leaderboard or influencer index.
-- ---
WITH tweet_eng AS (
    SELECT
        t.user_id,
        COUNT(DISTINCT t.tweet_id) AS tweets_posted,
        COALESCE(SUM(lc.like_count), 0) AS likes_received,
        COALESCE(SUM(rc.retweet_count), 0) AS retweets_received,
        COALESCE(SUM(rpc.reply_count), 0) AS replies_received,
        COALESCE(SUM(bc.bookmark_count),0) AS bookmarks_received
    FROM tweets t
    LEFT JOIN (SELECT tweet_id, COUNT(*) AS like_count FROM likes GROUP BY tweet_id) lc
        ON lc.tweet_id = t.tweet_id
    LEFT JOIN (SELECT tweet_id, COUNT(*) AS retweet_count FROM retweets GROUP BY tweet_id) rc
        ON rc.tweet_id = t.tweet_id
    LEFT JOIN (SELECT parent_tweet_id, COUNT(*) AS reply_count FROM tweets
               WHERE tweet_type = 'reply' AND parent_tweet_id IS NOT NULL
               GROUP BY parent_tweet_id) rpc
        ON rpc.parent_tweet_id = t.tweet_id
    LEFT JOIN (SELECT tweet_id, COUNT(*) AS bookmark_count FROM bookmarks GROUP BY tweet_id) bc
        ON bc.tweet_id = t.tweet_id
    GROUP BY t.user_id
),
social AS (
    SELECT
        u.user_id,
        COUNT(DISTINCT f_in.follower_id) AS follower_count,
        COUNT(DISTINCT f_out.following_id) AS following_count
    FROM users u
    LEFT JOIN follows f_in  ON f_in.following_id = u.user_id
    LEFT JOIN follows f_out ON f_out.follower_id  = u.user_id
    GROUP BY u.user_id
)
SELECT
    u.user_id,
    u.username,
    up.display_name,
    u.is_verified,
    COALESCE(te.tweets_posted, 0) AS tweets_posted,
    COALESCE(te.likes_received, 0) AS likes_received,
    COALESCE(te.retweets_received, 0) AS retweets_received,
    COALESCE(te.replies_received, 0) AS replies_received,
    COALESCE(te.bookmarks_received, 0) AS bookmarks_received,
    COALESCE(s.follower_count, 0) AS followers,
    COALESCE(s.following_count, 0) AS following,
    COALESCE(te.likes_received, 0)
      + COALESCE(te.retweets_received, 0)
      + COALESCE(te.replies_received, 0)
      + COALESCE(te.bookmarks_received, 0)  AS total_engagement_received,
    ROUND(
        (COALESCE(te.likes_received, 0) + COALESCE(te.retweets_received, 0))
        / NULLIF(COALESCE(te.tweets_posted, 0), 0), 2) AS engagement_per_tweet
FROM users u
JOIN user_profiles up ON up.user_id = u.user_id
LEFT JOIN tweet_eng te ON te.user_id = u.user_id
LEFT JOIN social s ON s.user_id = u.user_id
ORDER BY total_engagement_received DESC
LIMIT 25;

-- ---
-- Q2: Reply chain depth (show multi-level conversation threads)
--     Uses a recursive CTE to walk down reply chains from root tweets
-- ---
WITH RECURSIVE reply_tree AS (
    -- Base: root tweets (no parent)
    SELECT
        tweet_id,
        user_id,
        content,
        parent_tweet_id,
        tweet_id AS root_tweet_id,
        0 AS depth,
        CAST(tweet_id AS CHAR(200)) AS path
    FROM tweets
    WHERE tweet_type = 'original'
      AND tweet_id IN (
          SELECT DISTINCT parent_tweet_id
          FROM tweets
          WHERE tweet_type = 'reply' AND parent_tweet_id IS NOT NULL
      )

    UNION ALL

    -- Recursive: replies to existing nodes
    SELECT
        t.tweet_id,
        t.user_id,
        t.content,
        t.parent_tweet_id,
        rt.root_tweet_id,
        rt.depth + 1,
        CONCAT(rt.path, ' -> ', t.tweet_id)
    FROM tweets t
    JOIN reply_tree rt ON rt.tweet_id = t.parent_tweet_id
    WHERE t.tweet_type = 'reply'
)
SELECT
    root_tweet_id,
    MAX(depth) AS max_depth,
    COUNT(tweet_id) - 1 AS total_replies_in_thread
FROM reply_tree
GROUP BY root_tweet_id
ORDER BY max_depth DESC, total_replies_in_thread DESC
LIMIT 10;

-- ---
-- Q3: Mutual follow relationships — users who follow each other
--     (bidirectional edges in the social graph)
-- ---
SELECT
    u1.username AS user_a,
    u2.username AS user_b,
    f1.created_at AS a_followed_b_at,
    f2.created_at AS b_followed_a_at
FROM follows f1
JOIN follows f2 ON f2.follower_id = f1.following_id
     AND f2.following_id = f1.follower_id
JOIN users u1 ON u1.user_id = f1.follower_id
JOIN users u2 ON u2.user_id = f1.following_id
WHERE f1.follower_id < f1.following_id    -- deduplicate pairs (A,B) vs (B,A)
ORDER BY f1.created_at;

-- ---
-- Q4: Users with strong one-sided follow interest
--     They follow someone who does not follow them back
--     Filtered to show the top 10 most-followed accounts among non-followers
-- ---
SELECT
    u_follower.username AS follower,
    u_followed.username AS followed_account,
    up.display_name AS followed_display_name,
    f.created_at AS followed_at
FROM follows f
JOIN users u_follower ON u_follower.user_id = f.follower_id
JOIN users u_followed ON u_followed.user_id = f.following_id
JOIN user_profiles up ON up.user_id = f.following_id
WHERE NOT EXISTS (
    SELECT 1
    FROM follows f_back
    WHERE f_back.follower_id = f.following_id
      AND f_back.following_id = f.follower_id
)
ORDER BY u_followed.user_id, f.created_at
LIMIT 30;

-- ---
-- Q5: Content diversity score per user
--     Measures whether a user posts across multiple domains (hashtag variety)
--     vs. staying in a single niche
-- ---
SELECT
    u.user_id,
    u.username,
    up.display_name,
    COUNT(DISTINCT t.tweet_id) AS total_tweets,
    COUNT(DISTINCT th.hashtag_id) AS unique_hashtags,
    ROUND(
        COUNT(DISTINCT th.hashtag_id)
        / NULLIF(COUNT(DISTINCT t.tweet_id), 0), 2) AS hashtag_diversity_score
FROM users u
JOIN user_profiles up ON up.user_id = u.user_id
JOIN tweets t ON t.user_id = u.user_id
LEFT JOIN tweet_hashtags th ON th.tweet_id = t.tweet_id
GROUP BY u.user_id, u.username, up.display_name
HAVING total_tweets >= 3
ORDER BY hashtag_diversity_score DESC
LIMIT 15;

-- ---
-- Q6: Engagement velocity (which tweets gained the most engagement fastest?)
--     Compares engagement in the first 2 hours after posting vs. total
-- ---
SELECT
    t.tweet_id,
    u.username,
    LEFT(t.content, 70) AS content_preview,
    t.created_at,
    COUNT(DISTINCT CASE WHEN l.created_at <= t.created_at + INTERVAL 2 HOUR THEN l.like_id
    END) AS likes_first_2h,
    COUNT(DISTINCT l.like_id) AS total_likes,
    ROUND(
        COUNT(DISTINCT CASE WHEN l.created_at <= t.created_at + INTERVAL 2 HOUR THEN l.like_id
        END) * 100.0 / NULLIF(COUNT(DISTINCT l.like_id), 0), 1) AS pct_earned_in_first_2h
FROM tweets t
JOIN users u ON u.user_id = t.user_id
JOIN likes l ON l.tweet_id = t.tweet_id
GROUP BY t.tweet_id, u.username, t.content, t.created_at
HAVING total_likes >= 3
ORDER BY pct_earned_in_first_2h DESC, total_likes DESC
LIMIT 15;

-- ---
-- Q7: Network centrality approximation
--     Users who appear in many mutual follow pairs have higher centrality.
--     Proxy: count of unique users reachable within 1 hop (direct follows).
-- ---
SELECT
    u.user_id,
    u.username,
    up.display_name,
    COUNT(DISTINCT f_out.following_id) AS accounts_followed,
    COUNT(DISTINCT f_in.follower_id) AS accounts_following,
    COUNT(DISTINCT f_out.following_id)
    + COUNT(DISTINCT f_in.follower_id) AS degree_centrality
FROM users u
JOIN user_profiles up ON up.user_id = u.user_id
LEFT JOIN follows f_out ON f_out.follower_id = u.user_id
LEFT JOIN follows f_in ON f_in.following_id = u.user_id
GROUP BY u.user_id, u.username, up.display_name
ORDER BY degree_centrality DESC
LIMIT 15;

-- ---
-- Q8: Trending hashtags by engagement in last 90 days
--     Ranks hashtags by combined likes + retweets on tweets that used them
--     within the recent window
-- ---
SELECT
    h.tag,
    COUNT(DISTINCT th.tweet_id) AS tweets_in_window,
    COALESCE(SUM(lc.likes), 0) AS likes_in_window,
    COALESCE(SUM(rc.rts), 0) AS retweets_in_window,
    COALESCE(SUM(lc.likes), 0)
      + COALESCE(SUM(rc.rts), 0) AS engagement_score
FROM hashtags h
JOIN tweet_hashtags th ON th.hashtag_id = h.hashtag_id
JOIN tweets t ON t.tweet_id = th.tweet_id
LEFT JOIN (
    SELECT tweet_id, COUNT(*) AS likes
    FROM likes
    WHERE created_at >= NOW() - INTERVAL 90 DAY
    GROUP BY tweet_id
) lc ON lc.tweet_id = t.tweet_id
LEFT JOIN (
    SELECT tweet_id, COUNT(*) AS rts
    FROM retweets
    WHERE created_at >= NOW() - INTERVAL 90 DAY
    GROUP BY tweet_id
) rc ON rc.tweet_id = t.tweet_id
WHERE t.created_at >= NOW() - INTERVAL 90 DAY
GROUP BY h.tag
ORDER BY engagement_score DESC
LIMIT 15;

-- ---
-- Q9: Week-over-week activity comparison
--     Compare total platform activity (tweets + likes + retweets) across
--     the last 8 weeks to spot growth or decline trends
-- ---
SELECT
    week_label,
    SUM(tweet_count) AS tweets,
    SUM(like_count) AS likes,
    SUM(rt_count) AS retweets,
    SUM(tweet_count) + SUM(like_count) + SUM(rt_count) AS total_actions
FROM (
    SELECT
        DATE_FORMAT(
            DATE_SUB(created_at, INTERVAL WEEKDAY(created_at) DAY),
            '%Y-%m-%d') AS week_label,
        COUNT(*) AS tweet_count,
        0 AS like_count,
        0 AS rt_count
    FROM tweets
    WHERE created_at >= NOW() - INTERVAL 56 DAY
    GROUP BY week_label

    UNION ALL

    SELECT
        DATE_FORMAT(
            DATE_SUB(created_at, INTERVAL WEEKDAY(created_at) DAY),
            '%Y-%m-%d') AS week_label,
        0 AS tweet_count,
        COUNT(*) AS like_count,
        0 AS rt_count
    FROM likes
    WHERE created_at >= NOW() - INTERVAL 56 DAY
    GROUP BY week_label

    UNION ALL

    SELECT
        DATE_FORMAT(
            DATE_SUB(created_at, INTERVAL WEEKDAY(created_at) DAY),
            '%Y-%m-%d') AS week_label,
        0 AS tweet_count,
        0 AS like_count,
        COUNT(*) AS rt_count
    FROM retweets
    WHERE created_at >= NOW() - INTERVAL 56 DAY
    GROUP BY week_label
) AS combined
GROUP BY week_label
ORDER BY week_label;

-- ---
-- Q10: Cross-domain amplification (which users outside a hashtag cluster)
--      retweeted content from within it? Identifies bridges between communities.
--      Ex: who retweeted #ai tweets but is not an AI content creator?
-- ---
WITH ai_tweeters AS (
    SELECT DISTINCT t.user_id
    FROM tweets t
    JOIN tweet_hashtags th ON th.tweet_id = t.tweet_id
    JOIN hashtags h  ON h.hashtag_id = th.hashtag_id
    WHERE h.tag IN ('ai', 'ml', 'machinelearning', 'llm')
),
ai_tweets AS (
    SELECT DISTINCT th.tweet_id
    FROM tweet_hashtags th
    JOIN hashtags h ON h.hashtag_id = th.hashtag_id
    WHERE h.tag IN ('ai', 'ml', 'machinelearning', 'llm')
)
SELECT
    u.username AS amplifier,
    up.display_name,
    COUNT(DISTINCT rt.tweet_id) AS ai_tweets_retweeted
FROM retweets rt
JOIN users u ON u.user_id = rt.user_id
JOIN user_profiles up ON up.user_id = u.user_id
WHERE rt.tweet_id IN (SELECT tweet_id FROM ai_tweets)
  AND rt.user_id NOT IN (SELECT user_id FROM ai_tweeters)
GROUP BY u.username, up.display_name
ORDER BY ai_tweets_retweeted DESC;
