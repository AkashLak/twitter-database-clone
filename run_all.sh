#!/usr/bin/env bash
# ===
# Twitter_MySQL_Clone — run_all.sh
# Executes all SQL files in the correct dependency order.
# Usage:
#   ./run_all.sh -u <mysql_user> -p # prompts for password
#   ./run_all.sh -u root -pYourPassword # password inline (not recommended)
# ===

set -euo pipefail

MYSQL_ARGS=("$@")

run_sql() {
    local file="$1"
    echo "  -> Running $file ..."
    mysql "${MYSQL_ARGS[@]}" < "$file"
    echo " Done."
}

echo ""
echo "============================================================"
echo " Twitter_MySQL_Clone — Database Setup"
echo "============================================================"
echo ""

echo "[1/3] Schema"
run_sql schema/01_setup.sql
run_sql schema/02_users.sql
run_sql schema/03_tweets.sql
run_sql schema/04_social.sql
run_sql schema/05_hashtags.sql
run_sql schema/06_mentions.sql
run_sql schema/07_media.sql
run_sql schema/08_extended.sql
run_sql schema/09_indexes.sql

echo ""
echo "[2/3] Seed data"
run_sql seed/01_seed_users.sql
run_sql seed/02_seed_tweets.sql
run_sql seed/03_seed_follows.sql
run_sql seed/04_seed_hashtags.sql
run_sql seed/05_seed_engagement.sql

echo ""
echo "[3/3] Verifying row counts ..."
mysql "${MYSQL_ARGS[@]}" twitter_clone <<'SQL'
SELECT 'users' AS tbl, COUNT(*) AS rows FROM users
UNION ALL
SELECT 'user_profiles', COUNT(*) FROM user_profiles
UNION ALL
SELECT 'tweets', COUNT(*) FROM tweets
UNION ALL
SELECT 'follows', COUNT(*) FROM follows
UNION ALL
SELECT 'likes', COUNT(*) FROM likes
UNION ALL
SELECT 'retweets', COUNT(*) FROM retweets
UNION ALL
SELECT 'bookmarks', COUNT(*) FROM bookmarks
UNION ALL
SELECT 'hashtags', COUNT(*) FROM hashtags
UNION ALL
SELECT 'tweet_hashtags', COUNT(*) FROM tweet_hashtags
UNION ALL
SELECT 'mentions', COUNT(*) FROM mentions
UNION ALL
SELECT 'tweet_views', COUNT(*) FROM tweet_views;
SQL

echo ""
echo "============================================================"
echo " Setup complete. Database: twitter_clone"
echo " Run analytics: mysql <args> twitter_clone < analytics/<file>.sql"
echo "============================================================"
echo ""
