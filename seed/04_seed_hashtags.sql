-- ===
-- Purpose: Seed hashtags and their associations to tweets.
--          Hashtags are stored normalized (lowercase). The tweet_hashtags
--          join table records which tweets used which tags.
-- ===

USE twitter_clone;

-- ---
-- hashtags - 32 unique tags
-- ---
INSERT INTO hashtags (hashtag_id, tag, created_at) VALUES
( 1, 'programming',     '2024-01-01 00:00:00'),
( 2, 'rustlang',        '2024-01-01 00:00:00'),
( 3, 'sql',             '2024-01-01 00:00:00'),
( 4, 'databases',       '2024-01-01 00:00:00'),
( 5, 'ai',              '2024-01-01 00:00:00'),
( 6, 'ml',              '2024-01-01 00:00:00'),
( 7, 'machinelearning', '2024-01-01 00:00:00'),
( 8, 'crypto',          '2024-01-01 00:00:00'),
( 9, 'bitcoin',         '2024-01-01 00:00:00'),
(10, 'web3',            '2024-01-01 00:00:00'),
(11, 'nft',             '2024-01-01 00:00:00'),
(12, 'devops',          '2024-01-01 00:00:00'),
(13, 'k8s',             '2024-01-01 00:00:00'),
(14, 'kubernetes',      '2024-01-01 00:00:00'),
(15, 'security',        '2024-01-01 00:00:00'),
(16, 'infosec',         '2024-01-01 00:00:00'),
(17, 'cybersecurity',   '2024-01-01 00:00:00'),
(18, 'dataengineering', '2024-01-01 00:00:00'),
(19, 'opensource',      '2024-01-01 00:00:00'),
(20, 'startup',         '2024-01-01 00:00:00'),
(21, 'entrepreneurship','2024-01-01 00:00:00'),
(22, 'climate',         '2024-01-01 00:00:00'),
(23, 'fitness',         '2024-01-01 00:00:00'),
(24, 'health',          '2024-01-01 00:00:00'),
(25, 'python',          '2024-01-01 00:00:00'),
(26, 'llm',             '2024-01-01 00:00:00'),
(27, 'gitops',          '2024-01-01 00:00:00'),
(28, 'dbt',             '2024-01-01 00:00:00'),
(29, 'sqlite',          '2024-01-01 00:00:00'),
(30, 'mlops',           '2024-01-01 00:00:00'),
(31, 'cloud',           '2024-01-01 00:00:00'),
(32, 'aws',             '2024-01-01 00:00:00');

-- ---
-- tweet_hashtags - associations between tweets and hashtags
-- ---
INSERT INTO tweet_hashtags (tweet_id, hashtag_id, created_at) VALUES

-- Tweet 1: #rustlang #programming
(1,  2, '2024-01-15 09:00:00'), (1,  1, '2024-01-15 09:00:00'),
-- Tweet 5: #sql #databases
(5,  3, '2024-01-20 10:00:00'), (5,  4, '2024-01-20 10:00:00'),
-- Tweet 9: #bitcoin #crypto
(9,  9, '2024-01-08 18:00:00'), (9,  8, '2024-01-08 18:00:00'),
-- Tweet 10: #web3 #nft
(10, 10, '2024-02-20 20:30:00'), (10, 11, '2024-02-20 20:30:00'),
-- Tweet 11: #crypto
(11,  8, '2024-03-10 08:00:00'),
-- Tweet 21: #k8s #devops
(21, 13, '2024-01-10 08:30:00'), (21, 12, '2024-01-10 08:30:00'),
-- Tweet 24: #ai #ml #research (using ml and ai)
(24,  5, '2024-01-18 10:30:00'), (24,  6, '2024-01-18 10:30:00'),
-- Tweet 38: #dbt #dataengineering
(38, 28, '2024-02-28 13:00:00'), (38, 18, '2024-02-28 13:00:00'),
-- Tweet 42: #fitness #health
(42, 23, '2024-01-07 07:00:00'), (42, 24, '2024-01-07 07:00:00'),
-- Tweet 43: (fitness implied, no hashtag)
-- Tweet 46: #retrogaming #snes (not in hashtags, so skip)
-- Tweet 48: #mlops #machinelearning
(48, 30, '2024-01-23 09:00:00'), (48,  7, '2024-01-23 09:00:00'),
-- Tweet 54: #web3 #security
(54, 10, '2024-01-25 17:00:00'), (54, 15, '2024-01-25 17:00:00'),
-- Tweet 55: #ethereum #l2 -> use web3
(55, 10, '2024-03-18 16:00:00'),
-- Tweet 62: #cybersecurity
(62, 17, '2024-01-12 09:00:00'),
-- Tweet 63: #infosec
(63, 16, '2024-03-28 11:00:00'),
-- Tweet 64: #startup #entrepreneurship
(64, 20, '2024-02-08 10:00:00'), (64, 21, '2024-02-08 10:00:00'),
-- Tweet 68: #climate
(68, 22, '2024-01-13 11:00:00'),
-- Tweet 70: #rustlang
(70,  2, '2024-01-19 10:00:00'),
-- Tweet 74: #aws #cloud
(74, 32, '2024-01-24 09:30:00'), (74, 31, '2024-01-24 09:30:00'),
-- Tweet 76: #ai #llm
(76,  5, '2024-02-16 10:00:00'), (76, 26, '2024-02-16 10:00:00'),
-- Tweet 77: #ai
(77,  5, '2024-04-11 11:00:00'),
-- Tweet 85: #postgresql #sql -> use sql
(85,  3, '2024-03-28 02:00:00'),
-- Tweet 90: #sql #databases
(90,  3, '2024-01-17 09:00:00'), (90,  4, '2024-01-17 09:00:00'),
-- Tweet 94: #news #markets -> no matching hashtags, skip
-- Tweet 97: #ai
(97,  5, '2024-01-02 08:00:00'),
-- Tweet 98: #crypto #bitcoin
(98,  8, '2024-01-02 09:00:00'), (98,  9, '2024-01-02 09:00:00'),
-- Tweet 99: #programming
(99,  1, '2024-01-02 10:00:00'),
-- Tweet 104: #security
(104, 15, '2024-01-14 10:00:00'),
-- Tweet 105: (no hashtag)
-- Tweet 106: #k8s #gitops
(106, 13, '2024-01-22 09:00:00'), (106, 27, '2024-01-22 09:00:00'),
-- Tweet 107: #k8s (no hashtag in text but implied)
-- Tweet 114: #opensource #sqlite
(114, 19, '2024-01-26 10:00:00'), (114, 29, '2024-01-26 10:00:00'),
-- Tweet 115: #opensource #programming
(115, 19, '2024-03-04 10:00:00'), (115,  1, '2024-03-04 10:00:00'),
-- Tweet 116: #rustlang
(116,  2, '2024-01-15 10:00:00'),
-- Tweet 149 (quote of 37): #machinelearning
(149,  7, '2024-01-17 14:00:00'),
-- Tweet 153 (quote of 104): #security
(153, 15, '2024-01-20 10:00:00'),
-- Tweet 155 (quote of 49): (no hashtag)
-- Tweet 157 (quote of 71): (no hashtag)
-- Tweet 159 (quote of 107): (no hashtag)
-- Tweet 30: #startup #founder -> #startup
(30, 20, '2024-01-05 09:00:00'),
-- Tweet 6: #python implied
(6,  25, '2024-02-14 13:45:00'),
-- Tweet 161: #programming
(161,  1, '2025-02-10 10:00:00'),
-- Tweet 163: #databases #sql
(163,  4, '2025-01-20 09:30:00'), (163,  3, '2025-01-20 09:30:00'),
-- Tweet 165: #ai
(165,  5, '2025-03-05 10:30:00'),
-- Tweet 167: #dataengineering #dbt
(167, 18, '2025-04-15 10:00:00'), (167, 28, '2025-04-15 10:00:00'),
-- Tweet 169: #ai #llm
(169,  5, '2025-06-01 09:00:00'), (169, 26, '2025-06-01 09:00:00'),
-- Tweet 173: #mlops
(173, 30, '2025-09-15 09:30:00'),
-- Tweet 174: #security #infosec
(174, 15, '2025-10-05 08:00:00'), (174, 16, '2025-10-05 08:00:00'),
-- Tweet 175: #dataengineering
(175, 18, '2025-11-12 13:00:00'),
-- Tweet 176: #devops
(176, 12, '2025-12-01 09:00:00'),
-- Tweet 177: #ai
(177,  5, '2026-01-10 10:30:00'),
-- Tweet 178: #databases #sql
(178,  4, '2026-01-25 11:00:00'), (178,  3, '2026-01-25 11:00:00'),
-- Tweet 180: #programming #python
(180,  1, '2026-02-20 14:00:00'), (180, 25, '2026-02-20 14:00:00'),
-- Tweet 182: #databases
(182,  4, '2026-03-12 10:00:00'),
-- Tweet 183: #ai
(183,  5, '2026-03-20 16:00:00'),
-- Tweet 184: #programming
(184,  1, '2026-03-28 15:00:00'),
-- Tweet 185: #dataengineering
(185, 18, '2026-04-02 11:00:00'),
-- Tweet 186: #ai #llm
(186,  5, '2026-04-07 09:00:00'), (186, 26, '2026-04-07 09:00:00');
