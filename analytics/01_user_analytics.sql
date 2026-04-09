-- ===
-- Purpose: User-level analytics (registration, activity, and social reach)
-- ===

USE twitter_clone;

-- ---
-- Q1: The 5 oldest registered users on the platform
-- ---
SELECT
    u.user_id,
    u.username,
    up.display_name,
    u.created_at AS registered_at,
    DATEDIFF(CURRENT_DATE, u.created_at) AS days_on_platform
FROM users u
JOIN user_profiles up ON up.user_id = u.user_id
ORDER BY u.created_at ASC
LIMIT 5;

-- ---
-- Q2: Most common day of the week for new user registrations
--     Sunday=0, Monday=1 ... Saturday=6 in MySQL's DAYOFWEEK (1=Sun, 7=Sat)
-- ---
SELECT
    DAYNAME(created_at) AS registration_day,
    COUNT(*) AS signups,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_total
FROM users
GROUP BY DAYNAME(created_at), DAYOFWEEK(created_at)
ORDER BY signups DESC;

-- ---
-- Q3: Users who have never posted a single tweet (including replies/quotes)
-- ---
SELECT
    u.user_id,
    u.username,
    up.display_name,
    u.created_at AS registered_at
FROM users u
JOIN user_profiles up ON up.user_id = u.user_id
WHERE NOT EXISTS (
    SELECT 1
    FROM tweets t
    WHERE t.user_id = u.user_id
)
ORDER BY u.created_at;

-- ---
-- Q4: Most prolific tweeters - ranked by total tweet count
-- ---
SELECT
    u.user_id,
    u.username,
    up.display_name,
    COUNT(t.tweet_id) AS total_tweets,
    SUM(t.tweet_type = 'original') AS originals,
    SUM(t.tweet_type = 'reply') AS replies,
    SUM(t.tweet_type = 'quote') AS quotes,
    RANK() OVER (ORDER BY COUNT(t.tweet_id) DESC) AS tweet_rank
FROM users u
JOIN user_profiles up ON up.user_id = u.user_id
JOIN tweets t ON t.user_id = u.user_id
GROUP BY u.user_id, u.username, up.display_name
ORDER BY total_tweets DESC
LIMIT 15;

-- ---
-- Q5: Users with the most followers (top 15)
-- ---
SELECT
    u.user_id,
    u.username,
    up.display_name,
    u.is_verified,
    COUNT(f.follower_id) AS follower_count,
    RANK() OVER (ORDER BY COUNT(f.follower_id) DESC) AS follower_rank
FROM users u
JOIN user_profiles up ON up.user_id = u.user_id
LEFT JOIN follows f ON f.following_id = u.user_id
GROUP BY u.user_id, u.username, up.display_name, u.is_verified
ORDER BY follower_count DESC
LIMIT 15;

-- ---
-- Q6: Users following the most accounts (top 15)
--     High following-count with low followers is a bot/spam signal.
-- ---
SELECT
    u.user_id,
    u.username,
    up.display_name,
    COUNT(f.following_id) AS following_count,
    RANK() OVER (ORDER BY COUNT(f.following_id) DESC) AS following_rank
FROM users u
JOIN user_profiles up ON up.user_id = u.user_id
LEFT JOIN follows f ON f.follower_id = u.user_id
GROUP BY u.user_id, u.username, up.display_name
ORDER BY following_count DESC
LIMIT 15;

-- ---
-- Q7: Average number of tweets per user (across users who have tweeted)
-- ---
SELECT
    ROUND(AVG(tweet_count), 2) AS avg_tweets_per_user,
    MIN(tweet_count) AS min_tweets,
    MAX(tweet_count) AS max_tweets,
    SUM(tweet_count) AS total_tweets
FROM (
    SELECT user_id, COUNT(*) AS tweet_count
    FROM tweets
    GROUP BY user_id
) AS per_user_counts;

-- ---
-- Q8: Most active users in the last 30 days
--     Activity = tweets + likes + retweets posted in window
-- ---
SELECT
    u.user_id,
    u.username,
    up.display_name,
    COALESCE(tweet_counts.tweets, 0) AS tweets_last_30d,
    COALESCE(like_counts.likes, 0) AS likes_last_30d,
    COALESCE(rt_counts.retweets, 0) AS retweets_last_30d,
    COALESCE(tweet_counts.tweets, 0)
    + COALESCE(like_counts.likes, 0)
    + COALESCE(rt_counts.retweets, 0) AS total_actions_last_30d
FROM users u
JOIN user_profiles up ON up.user_id = u.user_id
LEFT JOIN (
    SELECT user_id, COUNT(*) AS tweets
    FROM tweets
    WHERE created_at >= NOW() - INTERVAL 30 DAY
    GROUP BY user_id
) AS tweet_counts ON tweet_counts.user_id  = u.user_id
LEFT JOIN (
    SELECT user_id, COUNT(*) AS likes
    FROM likes
    WHERE created_at >= NOW() - INTERVAL 30 DAY
    GROUP BY user_id
) AS like_counts ON like_counts.user_id = u.user_id
LEFT JOIN (
    SELECT user_id, COUNT(*) AS retweets
    FROM retweets
    WHERE created_at >= NOW() - INTERVAL 30 DAY
    GROUP BY user_id
) AS rt_counts ON rt_counts.user_id = u.user_id
HAVING total_actions_last_30d > 0
ORDER BY total_actions_last_30d DESC
LIMIT 20;

-- ---
-- Q9: Users who mostly retweet instead of posting original content
--     Defined as: retweet share of total content actions > 60%
-- ---
SELECT
    u.user_id,
    u.username,
    up.display_name,
    originals,
    retweets,
    ROUND(retweets * 100.0 / NULLIF(originals + retweets, 0), 1) AS retweet_pct
FROM (
    SELECT
        u.user_id,
        SUM(t.tweet_type = 'original') AS originals,
        COUNT(rt.retweet_id) AS retweets
    FROM users u
    LEFT JOIN tweets t ON t.user_id  = u.user_id
    LEFT JOIN retweets rt ON rt.user_id = u.user_id
    GROUP BY u.user_id
) AS content_summary
JOIN users u  ON u.user_id = content_summary.user_id
JOIN user_profiles up ON up.user_id = content_summary.user_id
WHERE (originals + retweets) > 5
ORDER BY retweet_pct DESC
LIMIT 15;

-- ---
-- Q10: Users who bookmark the most content
-- ---
SELECT
    u.user_id,
    u.username,
    up.display_name,
    COUNT(b.bookmark_id) AS bookmark_count,
    RANK() OVER (ORDER BY COUNT(b.bookmark_id) DESC) AS bookmark_rank
FROM users u
JOIN user_profiles up ON up.user_id = u.user_id
JOIN bookmarks b ON b.user_id = u.user_id
GROUP BY u.user_id, u.username, up.display_name
ORDER BY bookmark_count DESC
LIMIT 10;
