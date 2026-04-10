# 🐦 Twitter Database Clone

A relational MySQL database modeled after Twitter's core data architecture. Includes a full schema, realistic seed data spanning 2020–2026, and analytics queries covering user behavior, tweet engagement, hashtag trends, and bot detection.

## 🚀 Setup

**Full setup (schema + seed data):**
```bash
./run_all.sh -u <mysql_user> -p
```

**Manual execution order — files must run in this sequence:**
```bash
# Schema
mysql -u root -p < schema/01_setup.sql
mysql -u root -p < schema/02_users.sql
mysql -u root -p < schema/03_tweets.sql
mysql -u root -p < schema/04_social.sql
mysql -u root -p < schema/05_hashtags.sql
mysql -u root -p < schema/06_mentions.sql
mysql -u root -p < schema/07_media.sql
mysql -u root -p < schema/08_extended.sql
mysql -u root -p < schema/09_indexes.sql

# Seed data (run after all schema files)
mysql -u root -p < seed/01_seed_users.sql
mysql -u root -p < seed/02_seed_tweets.sql
mysql -u root -p < seed/03_seed_follows.sql
mysql -u root -p < seed/04_seed_hashtags.sql
mysql -u root -p < seed/05_seed_engagement.sql
```

**Running analytics queries:**
```bash
mysql -u root -p twitter_clone < analytics/<file>.sql
```

**Requirement:** MySQL 8.0+ (analytics use window functions and recursive CTEs).

## 🗄️ Schema Design

**Content model:** All tweet content (original posts, replies, quote tweets) lives in a single `tweets` table. `tweet_type` ENUM discriminates between them. `parent_tweet_id` is a self-referencing foreign key (FK) for replies; `quoted_tweet_id` references the quoted tweet.

**Social graph:** `follows` is a directed edge table: `follower_id -> following_id`. All interaction tables (`likes`, `retweets`, `bookmarks`, `mentions`) use composite UNIQUE keys to enforce integrity at the DB layer.

**Hashtag normalization:** `hashtags` stores each tag once. `tweet_hashtags` is the join table. Co-occurrence queries use a self-join on `tweet_hashtags`.

**Profile separation:** `user_profiles` extends `users` 1-to-1, keeping the `users` table lean (identity/credentials/flags only).

## 📊 Analytics

| File | Coverage |
|---|---|
| `01_user_analytics.sql` | Registration trends, prolific tweeters, follower/following rankings, 30-day activity |
| `02_tweet_analytics.sql` | Most liked/retweeted tweets, reply thread depth, quote tweet patterns |
| `03_engagement_analytics.sql` | Per-user engagement totals, like/retweet rates, mention frequency |
| `04_hashtag_analytics.sql` | Top hashtags, co-occurrence pairs, hashtag growth over time |
| `05_advanced_analytics.sql` | Bot detection, viral content, recursive thread traversal |


## 🗂️ Project Structure

```
twitter-database-clone/
├── schema/
│   ├── 01_setup.sql           # Creates the database
│   ├── 02_users.sql           # users, user_profiles
│   ├── 03_tweets.sql          # tweets (originals, replies, quotes)
│   ├── 04_social.sql          # follows, likes, retweets, bookmarks
│   ├── 05_hashtags.sql        # hashtags, tweet_hashtags
│   ├── 06_mentions.sql        # mentions
│   ├── 07_media.sql           # media attachments
│   ├── 08_extended.sql        # extended metadata
│   └── 09_indexes.sql         # performance indexes
├── seed/
│   ├── 01_seed_users.sql      # 54 users + profiles
│   ├── 02_seed_tweets.sql     # 186 tweets
│   ├── 03_seed_follows.sql    # follow relationships
│   ├── 04_seed_hashtags.sql   # hashtags + tweet associations
│   └── 05_seed_engagement.sql # likes, retweets, bookmarks, mentions
├── analytics/
│   ├── 01_user_analytics.sql
│   ├── 02_tweet_analytics.sql
│   ├── 03_engagement_analytics.sql
│   ├── 04_hashtag_analytics.sql
│   └── 05_advanced_analytics.sql
└── run_all.sh                 # Full setup script
```
