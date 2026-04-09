-- ===
-- Purpose: Seed 160 tweets - original posts, replies, and quote tweets.
--          Content is varied across tech, politics, sports, lifestyle, and
--          crypto to support diverse analytics queries.
-- ===

USE twitter_clone;

-- ---
-- Original tweets (tweet_type = 'original')
-- ---
INSERT INTO tweets (tweet_id, user_id, content, tweet_type, parent_tweet_id, quoted_tweet_id, created_at) VALUES

-- Alex Turner (user 1) — dev content
(1,  1, 'Just pushed my first Rust project to GitHub after 3 months of fighting the borrow checker. The compiler is brutal but I finally get it. Worth it. #rustlang #programming', 'original', NULL, NULL, '2024-01-15 09:00:00'),
(2,  1, 'Hot take: TypeScript saved JavaScript from itself. The type system catches half my bugs before runtime. Cannot go back to plain JS.', 'original', NULL, NULL, '2024-02-10 11:30:00'),
(3,  1, 'If your codebase has more than 3 layers of abstraction for a CRUD operation, you have a problem.', 'original', NULL, NULL, '2024-03-05 14:00:00'),
(4,  1, 'Been doing code reviews for 8 years. The biggest thing I look for is not bugs — it is whether the next dev can understand this in 6 months.', 'original', NULL, NULL, '2024-04-01 10:00:00'),

-- Sarah Chen (user 2) — engineering
(5,  2, 'If you are not using database indexes on your foreign keys and filter columns, your query optimizer is silently judging you. #SQL #databases', 'original', NULL, NULL, '2024-01-20 10:00:00'),
(6,  2, 'Python is not slow. Slow Python is slow. Profile first, optimize second, rewrite in Rust as a last resort.', 'original', NULL, NULL, '2024-02-14 13:45:00'),
(7,  2, 'Just shipped a feature that eliminated 40% of our database calls by rethinking our data model. Schema design matters more than any library.', 'original', NULL, NULL, '2024-03-18 15:30:00'),
(8,  2, 'Code review culture make or break a team. Normalize being kind in reviews. The code is not the person.', 'original', NULL, NULL, '2024-05-01 09:15:00'),

-- Marcus Webb (user 3) — crypto
(9,  3, 'BTC just broke resistance at a key level. $300k is not a prediction, it is math. Do your own research. #Bitcoin #crypto', 'original', NULL, NULL, '2024-01-08 18:00:00'),
(10, 3, 'NFTs are having a moment again. The underlying technology is solid, even if the monkey pictures were dumb. #Web3 #NFT', 'original', NULL, NULL, '2024-02-20 20:30:00'),
(11, 3, 'Not your keys, not your coins. If you trust a centralized exchange with your BTC you deserve what happens next. #crypto #selfcustody', 'original', NULL, NULL, '2024-03-10 08:00:00'),

-- The News Watch (user 4) — breaking news
(12, 4, 'BREAKING: Congressional leaders reach a preliminary deal on the supplemental budget package. Votes expected by Friday. Full details developing.', 'original', NULL, NULL, '2024-01-30 16:00:00'),
(13, 4, 'Major tech company announces 12% workforce reduction citing macroeconomic headwinds. Second large layoff in 18 months. Thread to follow.', 'original', NULL, NULL, '2024-02-28 09:00:00'),
(14, 4, 'Federal Reserve signals potential rate hold at upcoming meeting. Markets respond positively. #economy #Fed', 'original', NULL, NULL, '2024-03-20 14:30:00'),

-- Mike Rodriguez (user 5) — sports
(15, 5, 'CHAMPIONSHIP GAME TONIGHT. First time in 15 years. This city deserves this. Cannot sleep. Lets go.', 'original', NULL, NULL, '2024-01-25 10:00:00'),
(16, 5, 'Stats do not lie but they do not tell the whole story. Watch the film. The advanced metrics miss so much context. #basketball', 'original', NULL, NULL, '2024-02-08 19:00:00'),
(17, 5, 'Unpopular opinion: the best player in the league right now is not the one winning the awards. The eye test matters.', 'original', NULL, NULL, '2024-04-10 21:00:00'),

-- Jenna Park (user 6) — tech writing
(18, 6, 'Wrote 3000 words today on how social media platforms are quietly reshaping political discourse. The data is alarming. Article drops Thursday.', 'original', NULL, NULL, '2024-01-22 17:00:00'),
(19, 6, 'The most underrated skill in tech is knowing how to write clearly. Great engineers who can explain their thinking are incredibly rare.', 'original', NULL, NULL, '2024-03-01 11:00:00'),
(20, 6, 'Reminder: every "overnight success" startup you read about was 7 years of quiet, unglamorous work first.', 'original', NULL, NULL, '2024-04-15 09:30:00'),

-- Dave Keller (user 7) — devops
(21, 7, 'Kubernetes is just YAML files and existential dread all the way down. I say this with love. #k8s #devops', 'original', NULL, NULL, '2024-01-10 08:30:00'),
(22, 7, 'If your deployment takes more than 10 minutes, your developers are losing hours of focus time every week. Fix your pipeline.', 'original', NULL, NULL, '2024-02-18 09:00:00'),
(23, 7, 'I have been on-call for 6 years. Nothing teaches you system design faster than a 3am production incident. Runbooks are love letters to future you.', 'original', NULL, NULL, '2024-03-25 22:00:00'),

-- Dr. Priya Patel (user 8) — AI research
(24, 8, 'New paper out: our team shows that chain-of-thought reasoning in LLMs is not always consistent with actual model computations. The reasoning can be post-hoc. #AI #ML #research', 'original', NULL, NULL, '2024-01-18 10:30:00'),
(25, 8, 'The interpretability problem in AI is not just academic. It has direct implications for how much we can trust these systems in high-stakes decisions.', 'original', NULL, NULL, '2024-02-25 14:00:00'),
(26, 8, 'Reminder: "AI can do X" and "AI reliably does X in production" are very different statements. Evaluation matters enormously.', 'original', NULL, NULL, '2024-04-20 11:00:00'),

-- Kevin M (user 9) — memes / humor
(27, 9, 'Telling my therapist I talk to an AI about my feelings and she just closed her laptop and walked out. #ChatGPT #relatable', 'original', NULL, NULL, '2024-01-14 21:00:00'),
(28, 9, 'Senior developer: "it''s not a bug, it''s an undocumented feature." Architect: "the undocumented feature is load-bearing."', 'original', NULL, NULL, '2024-02-22 20:00:00'),
(29, 9, 'Every startup pitch: "we are the Uber for X" but X is something that never needed to be disrupted.', 'original', NULL, NULL, '2024-05-05 18:30:00'),

-- James Liu (user 10) — startup
(30, 10, 'Year 4 of the startup. Revenue positive last quarter for the first time. Nobody told me it would feel exactly the same and somehow different. #startup #founder', 'original', NULL, NULL, '2024-01-05 09:00:00'),
(31, 10, 'Advice I wish I got earlier: hire slow, fire fast, and document everything your customers say to you. It is all product research.', 'original', NULL, NULL, '2024-02-12 10:00:00'),
(32, 10, 'The pivot was scary. We had conviction in the wrong thing for too long. The data was telling us. We were not listening. Lesson learned.', 'original', NULL, NULL, '2024-04-08 11:30:00'),

-- Sofia Martinez (user 11) — travel
(33, 11, 'Writing this from a cafe in Lisbon. 48th country. Remote work was the best decision I ever made. The geographic arbitrage alone changed my financial life.', 'original', NULL, NULL, '2024-01-28 13:00:00'),
(34, 11, 'Travel tip: learn 10 words in the local language before every trip. Just 10. The response you get from locals is completely different.', 'original', NULL, NULL, '2024-03-12 11:30:00'),

-- Tom Wilson (user 12) — React
(35, 12, 'React Server Components finally clicked for me after reading the mental model correctly. It is not just SSR. It is a different way of thinking about data ownership.', 'original', NULL, NULL, '2024-02-05 10:00:00'),
(36, 12, 'CSS in 2024 is genuinely great. Container queries, has(), and cascade layers make old problems disappear. Stop fighting it.', 'original', NULL, NULL, '2024-03-30 14:00:00'),

-- Rachel Kim (user 13) — data science
(37, 13, 'Your machine learning model is only as good as your feature engineering. The algorithm is 20% of the problem. The data is 80%.', 'original', NULL, NULL, '2024-01-16 09:30:00'),
(38, 13, 'dbt is genuinely the best thing to happen to analytics engineering in a decade. Treating SQL transformations like software is the unlock. #dbt #dataengineering', 'original', NULL, NULL, '2024-02-28 13:00:00'),
(39, 13, 'Exploratory data analysis is not optional. The number of production models I have seen deployed on top of fundamentally broken training data is too high.', 'original', NULL, NULL, '2024-04-22 10:30:00'),

-- Chris Johnson (user 14) — journalism
(40, 14, 'Spent 6 months investigating this story. Sometimes journalism is slow. This one mattered. Dropping Tuesday. #investigative', 'original', NULL, NULL, '2024-01-29 08:00:00'),
(41, 14, 'The fourth estate is not dead. It is underfunded, understaffed, and under attack. Support local journalism.', 'original', NULL, NULL, '2024-03-15 09:00:00'),

-- Amanda Torres (user 15) — fitness
(42, 15, 'You do not need a perfect plan. You need a consistent one. 30 minutes three times a week for a year beats 2 hours once a month. #fitness #health', 'original', NULL, NULL, '2024-01-07 07:00:00'),
(43, 15, 'Sleep is your number one performance enhancer. Not supplements, not training volume, not protein timing. Sleep. Get 8 hours.', 'original', NULL, NULL, '2024-02-19 06:30:00'),

-- Liam O'Brien (user 16) — quantum computing
(44, 16, 'Spent the morning debugging a quantum circuit only to realize the error was in my classical pre-processing. The qubits were innocent this time.', 'original', NULL, NULL, '2024-01-20 11:00:00'),
(45, 16, 'The "quantum supremacy" headline cycle is exhausting. We are still years from fault-tolerant systems with practical applications. Manage expectations.', 'original', NULL, NULL, '2024-03-08 14:00:00'),

-- Daniel Fox (user 17) — retro gaming
(46, 17, 'Found a sealed copy of EarthBound at a garage sale for $4. The seller had no idea what it was. My hands were shaking. #retrogaming #SNES', 'original', NULL, NULL, '2024-02-03 15:00:00'),
(47, 17, 'The sound design in old 16-bit games was a technical constraint turned into an art form. Modern AAA games with unlimited budgets often sound worse.', 'original', NULL, NULL, '2024-04-05 20:00:00'),

-- Aisha Diallo (user 18) — ML engineering
(48, 18, 'Production ML is mostly data engineering and monitoring. The model training is maybe 10% of the real work. #MLOps #machinelearning', 'original', NULL, NULL, '2024-01-23 09:00:00'),
(49, 18, 'Model drift is not a hypothetical risk. I have seen three production models silently degrade over 6 months because nobody set up monitoring. Log everything.', 'original', NULL, NULL, '2024-03-14 11:30:00'),

-- Political Pulse (user 19) — politics
(50, 19, 'Thread: why Senate procedural rules matter more than most people realize, and why changing them carries risks beyond the immediate benefit.', 'original', NULL, NULL, '2024-02-06 10:00:00'),
(51, 19, 'Approval ratings at this stage of a presidency have a statistically weak correlation with election outcomes. Context matters more than snapshot numbers.', 'original', NULL, NULL, '2024-03-22 09:30:00'),

-- Nina Brooks (user 20) — lifestyle
(52, 20, 'Six months of writing 500 words every morning before looking at my phone. My anxiety is the lowest it has been in years. Highly recommend the practice.', 'original', NULL, NULL, '2024-01-11 07:15:00'),
(53, 20, 'Finished reading 52 books last year. Biggest insight: the best books always recommend 5 more. The reading list never gets shorter.', 'original', NULL, NULL, '2024-02-01 08:00:00'),

-- Bob Nguyen (user 21) — blockchain
(54, 21, 'Smart contract auditing should be mandatory before mainnet deploy. The number of avoidable exploits in the last 12 months is criminal. #Web3 #security', 'original', NULL, NULL, '2024-01-25 17:00:00'),
(55, 21, 'Layer 2 solutions finally make on-chain transactions cheap enough for everyday use. This is the adoption unlock we needed. #Ethereum #L2', 'original', NULL, NULL, '2024-03-18 16:00:00'),

-- Emma Scott (user 22) — UX
(56, 22, 'The best UX is invisible. When users do not notice the interface because it just works, you have done your job. Award-winning ≠ effective.', 'original', NULL, NULL, '2024-01-17 10:30:00'),
(57, 22, 'Every "we do not need a designer, it is fine" startup eventually becomes "we need to redesign everything" in year 3. Hire designers early.', 'original', NULL, NULL, '2024-03-05 09:00:00'),

-- Steve Hoffman (user 23) — Linux
(58, 23, 'Switched my entire workflow to Neovim 8 months ago. The learning curve was real but I am significantly faster now. LSP support is the difference maker.', 'original', NULL, NULL, '2024-02-10 14:00:00'),
(59, 23, 'The Linux desktop has finally crossed the threshold. Steam on Proton, Wayland stability, and the app ecosystem make Windows unnecessary for most developers.', 'original', NULL, NULL, '2024-04-12 11:00:00'),

-- The Book Club (user 24) — books
(60, 24, 'This month pick: The Staff Engineer''s Path by Tanya Reilly. Relevant for anyone navigating IC career progression in tech. Discussion thread Friday. #books #tech', 'original', NULL, NULL, '2024-02-01 10:00:00'),
(61, 24, 'February pick: Thinking in Bets by Annie Duke. Applicable to decisions in life and work. What did you think? Drop your hot takes below.', 'original', NULL, NULL, '2024-03-01 10:00:00'),

-- Raj Sharma (user 25) — security
(62, 25, 'Reminder: security is not a product you buy, it is a practice you build. The most sophisticated firewall is useless if you reuse passwords. #cybersecurity', 'original', NULL, NULL, '2024-01-12 09:00:00'),
(63, 25, 'CISA advisory out today on active exploitation of a common network appliance vulnerability. Patch your gear. Link in replies. #infosec', 'original', NULL, NULL, '2024-03-28 11:00:00'),

-- Lauren Hill (user 26) — entrepreneurship
(64, 26, 'My third company just crossed $1M ARR. The first failed spectacularly. The second broke even. Iteration is the game. #startup #entrepreneurship', 'original', NULL, NULL, '2024-02-08 10:00:00'),
(65, 26, 'VCs fund markets, not ideas. The most important slide in your deck is the market size slide. If you cannot explain why this is a billion-dollar opportunity, rethink.', 'original', NULL, NULL, '2024-04-18 09:30:00'),

-- Carlos Rivera (user 27) — music
(66, 27, 'New beat tape dropping this Friday. 18 tracks. All analog samples. Zero AI generation. Took 6 months. Hope it shows.', 'original', NULL, NULL, '2024-01-30 18:00:00'),
(67, 27, 'The democratization of music production is genuinely amazing. A laptop and $200 in plugins today outperforms studios that cost millions in the 90s.', 'original', NULL, NULL, '2024-03-20 16:30:00'),

-- Climate Facts (user 28) — climate
(68, 28, '2023 confirmed as the hottest year in recorded history. Global average surface temperature 1.45C above pre-industrial baseline. Data from NOAA and NASA. #climate', 'original', NULL, NULL, '2024-01-13 11:00:00'),
(69, 28, 'Solar capacity additions in 2023 exceeded all previous years combined. The energy transition is happening faster than models predicted. Thread with data below.', 'original', NULL, NULL, '2024-02-22 10:00:00'),

-- Henry Park (user 29) — Rust
(70, 29, 'Rust ownership model finally clicked for me when I stopped thinking of it as restrictions and started thinking of it as compile-time documentation of intent. #rustlang', 'original', NULL, NULL, '2024-01-19 10:00:00'),
(71, 29, 'Rewrote a Python data processing script in Rust. Same logic. Runtime went from 47 seconds to 0.3 seconds. The Python was not even bad Python.', 'original', NULL, NULL, '2024-03-10 14:30:00'),

-- Zoe Adams (user 30) — data engineering
(72, 30, 'Apache Spark is powerful but it is not always the right tool. I have seen Spark jobs replace with properly indexed SQL queries that ran 10x faster on a laptop. #dataengineering', 'original', NULL, NULL, '2024-02-14 09:00:00'),
(73, 30, 'Data quality is everyone''s problem and nobody''s job. Until you make it somebody''s explicit job. Then everything gets better fast.', 'original', NULL, NULL, '2024-04-02 10:30:00'),

-- Nathan Grey (user 31) — cloud
(74, 31, 'Cloud-native does not mean "we run everything on AWS." It means designing for failure, using managed services intelligently, and auto-scaling by default. #AWS #cloud', 'original', NULL, NULL, '2024-01-24 09:30:00'),
(75, 31, 'The real cost of cloud is not compute, it is egress fees and the complexity tax on your engineering team. Factor both into your architecture.', 'original', NULL, NULL, '2024-03-15 11:00:00'),

-- AI Weekly (user 32) — AI news
(76, 32, 'OpenAI released a new model variant. The benchmark numbers are impressive. The real test is production reliability at scale. Tracking this. #AI #LLM', 'original', NULL, NULL, '2024-02-16 10:00:00'),
(77, 32, 'Anthropic''s Constitutional AI approach to alignment is one of the more principled frameworks I have seen. Still unanswered questions but serious work. #AI #safety', 'original', NULL, NULL, '2024-04-11 11:00:00'),

-- Jessica Lee (user 33) — iOS
(78, 33, 'SwiftUI in 2024 is production-ready for 90% of use cases. The remaining 10% of edge cases are painful but they are genuinely edge cases now.', 'original', NULL, NULL, '2024-01-21 10:00:00'),
(79, 33, 'App Store review times are down significantly this quarter. What changed? Anyone else noticing this?', 'original', NULL, NULL, '2024-03-06 14:00:00'),

-- Patrick Murphy (user 34) — Go
(80, 34, 'Go error handling gets a lot of hate but after 5 years with it I prefer explicit error returns over exceptions. You always know what can fail.', 'original', NULL, NULL, '2024-01-26 09:00:00'),
(81, 34, 'Go generics are genuinely useful once you stop trying to make Go into Haskell. Use them for containers and constraints, not clever type gymnastics.', 'original', NULL, NULL, '2024-03-22 11:00:00'),

-- Dr. Owen Baker (user 35) — philosophy
(82, 35, 'The question is not whether AI can be conscious. The question is whether the category of consciousness as we understand it even applies to statistical pattern matching at scale.', 'original', NULL, NULL, '2024-02-05 10:00:00'),
(83, 35, 'We give AI systems human-sounding names and human-like interfaces, then are surprised when people anthropomorphize them. The design choice has ethical consequences.', 'original', NULL, NULL, '2024-04-08 14:00:00'),

-- Diana Cruz (user 36) — backend dev
(84, 36, 'PostgreSQL full-text search is wildly underused. Before you add Elasticsearch to your stack, seriously consider whether pg_trgm and tsvectors solve your problem first.', 'original', NULL, NULL, '2024-02-12 23:00:00'),
(85, 36, 'Wrote a recursive CTE at 2am that actually worked first try. Going to bed before I break it. #postgresql #sql', 'original', NULL, NULL, '2024-03-28 02:00:00'),

-- Sam Taylor (user 37) — SRE
(86, 37, 'An incident postmortem without a blameless culture is just a blame distribution meeting. The goal is systemic learning, not individual punishment.', 'original', NULL, NULL, '2024-01-15 10:00:00'),
(87, 37, 'Error budgets force the right conversation between product and engineering. "We want to ship faster" meets "we are out of reliability headroom" is a productive tension.', 'original', NULL, NULL, '2024-03-02 09:30:00'),

-- Ian Morris (user 38) — web3 skeptic
(88, 38, 'Three years into "the blockchain will solve this" and I am still waiting for the part where it actually solved anything better than a database would have. Genuinely asking.', 'original', NULL, NULL, '2024-01-08 11:00:00'),
(89, 38, 'The environmental cost of proof-of-work was always the strongest argument against Bitcoin. The move to proof-of-stake for Ethereum was the right call.', 'original', NULL, NULL, '2024-02-20 13:00:00'),

-- Maria Santos (user 39) — DBA
(90, 39, 'EXPLAIN ANALYZE is the most underused tool in a developer''s arsenal. Run it on every query that touches more than 10k rows before it hits production. #SQL #databases', 'original', NULL, NULL, '2024-01-17 09:00:00'),
(91, 39, '20 years working with databases. The most common performance problem is still missing indexes. Second most common is too many indexes. Balance matters.', 'original', NULL, NULL, '2024-03-10 10:00:00'),

-- Eric Zhang (user 40) — reader/lurker
(92, 40, 'Interesting thread on HN today about the actual economics of open source maintenance. The social contract between users and maintainers is fundamentally broken.', 'original', NULL, NULL, '2024-02-08 19:30:00'),
(93, 40, 'Reading more, posting less has been great for my mental health. Recommend it.', 'original', NULL, NULL, '2024-04-01 20:00:00'),

-- Bot accounts (users 41, 42) — high volume automated posts
(94,  41, 'TOP STORY: Global markets react to latest economic data. Full analysis: #news #markets', 'original', NULL, NULL, '2024-01-01 08:00:00'),
(95,  41, 'BREAKING: Major policy update announced by regulators. Details emerging. #breaking #news', 'original', NULL, NULL, '2024-01-01 09:00:00'),
(96,  41, 'TECH NEWS: Major acquisition confirmed in the software sector. Deal valued at $2.4B. #tech #M&A', 'original', NULL, NULL, '2024-01-01 10:00:00'),
(97,  42, 'TRENDING: #AI is the top trending topic globally right now.', 'original', NULL, NULL, '2024-01-02 08:00:00'),
(98,  42, 'TRENDING: #crypto is surging again. Sentiment: bullish. #Bitcoin #Ethereum', 'original', NULL, NULL, '2024-01-02 09:00:00'),
(99,  42, 'TRENDING: #programming tops developer discussion charts this week. #coding #tech', 'original', NULL, NULL, '2024-01-02 10:00:00'),

-- Leo Vasquez (user 43) — photography
(100, 43, 'Early morning light in Barcelona. 5am shoot. The city belongs to nobody at that hour. Shot on Canon R5, no filter, no edits beyond basic exposure.', 'original', NULL, NULL, '2024-01-20 05:30:00'),
(101, 43, 'The best camera is the one you have with you. Also the Canon R5 is incredible and you should absolutely buy it if you can.', 'original', NULL, NULL, '2024-03-15 12:00:00'),

-- Maya Patel (user 44) — poetry
(102, 44, 'the programmer said "it works on my machine" / the ops engineer said "ship the machine" / the cloud said "that will be $47,000/month" / everyone was right', 'original', NULL, NULL, '2024-02-08 21:00:00'),
(103, 44, 'what we call silence is just the sound of things not yet said', 'original', NULL, NULL, '2024-04-03 08:00:00'),

-- Frank Chen (user 45) — security
(104, 45, 'If you are still using SMS for 2FA in 2024 you are one SIM swap away from losing everything. Use a hardware key or at minimum an authenticator app. #security', 'original', NULL, NULL, '2024-01-14 10:00:00'),
(105, 45, 'Completed a red team engagement this week where we got domain admin via a phishing email in under 2 hours. The vector is almost always the same. Train your users.', 'original', NULL, NULL, '2024-03-20 15:00:00'),

-- Alice Wong (user 46) — Kubernetes
(106, 46, 'GitOps with Flux or ArgoCD is the answer to the "who deployed what and when" question that every ops team struggles with. Drift detection alone is worth it. #k8s #gitops', 'original', NULL, NULL, '2024-01-22 09:00:00'),
(107, 46, 'Kubernetes resource requests and limits are not suggestions. If you are not setting them you are not doing capacity planning, you are hoping.', 'original', NULL, NULL, '2024-03-25 10:30:00'),

-- Ryan Cooper (user 47) — Vue
(108, 47, 'Vue 3 with the Composition API and TypeScript is genuinely a pleasure to work with. The reactivity system is elegant in a way that React is not. Hot take.', 'original', NULL, NULL, '2024-02-15 10:00:00'),
(109, 47, 'Vite has made JavaScript development so much better. I forgot what it felt like to wait more than 2 seconds for a dev server to start.', 'original', NULL, NULL, '2024-04-14 11:00:00'),

-- Sandra Kim (user 48) — product
(110, 48, 'The best product decisions come from talking to users, not from analytics dashboards. The dashboard tells you what, not why. Both matter.', 'original', NULL, NULL, '2024-01-18 10:00:00'),
(111, 48, 'Shipped a feature users asked for. They immediately asked for the next thing. Shipped that. They asked for more. This is the job and I love it.', 'original', NULL, NULL, '2024-03-08 15:00:00'),

-- Luis Gomez (user 49) — data viz
(112, 49, 'A chart that requires a legend with 12 items is not a chart, it is a data dump with lines. Simplify. Remove. Highlight the one thing that matters.', 'original', NULL, NULL, '2024-02-20 11:00:00'),
(113, 49, 'D3.js is not a charting library. It is a data-bound DOM manipulation library that lets you build any chart. The distinction matters when you start designing.', 'original', NULL, NULL, '2024-04-07 10:00:00'),

-- OpenSource Daily (user 50) — open source
(114, 50, 'Spotlight: sqlite just shipped WAL2 mode. If you are not using SQLite for read-heavy embedded workloads you are missing out. The library is a masterpiece. #opensource #sqlite', 'original', NULL, NULL, '2024-01-26 10:00:00'),
(115, 50, 'This week in open source: major releases from the Rust, Go, and Python ecosystems. Thread below with links and summaries. #opensource #programming', 'original', NULL, NULL, '2024-03-04 10:00:00'),

-- ---
-- Reply tweets (tweet_type = 'reply')
-- ---

-- Replies to tweet 1 (Alex's Rust tweet)
(116, 29, 'The borrow checker is the best pair programmer I have ever had. It never lets you ship a use-after-free. Three months is actually pretty fast. #rustlang', 'reply', 1, NULL, '2024-01-15 10:00:00'),
(117,  2, 'I went through the exact same journey. The moment it clicked for me was when I stopped fighting it and started treating ownership as a first-class design concern.', 'reply', 1, NULL, '2024-01-15 11:30:00'),
(118,  7, 'Been hearing Rust in more infrastructure conversations. Is the tooling at the point where a team without systems background can be productive in a month?', 'reply', 1, NULL, '2024-01-15 12:00:00'),

-- Replies to tweet 5 (Sarah's indexes tweet)
(119, 39, 'This is the answer to 80% of the "my query is slow" questions I get. Add an index, run EXPLAIN, see the table scan disappear. Never gets old.', 'reply', 5, NULL, '2024-01-20 11:00:00'),
(120, 13, 'Composite indexes and covering indexes are where the real magic happens though. The query optimizer rewards you generously for thinking it through.', 'reply', 5, NULL, '2024-01-20 12:30:00'),
(121, 36, 'And check your index usage stats regularly. Indexes that are never used are just write overhead and maintenance cost. Clean house periodically.', 'reply', 5, NULL, '2024-01-20 13:00:00'),

-- Replies to tweet 24 (Priya's AI paper tweet)
(122,  8, 'Follow-up: the paper is on arxiv now. The key finding is that the verbalized reasoning tokens often diverge from the gradient-based causal pathways. Happy to discuss.', 'reply', 24, NULL, '2024-01-18 14:00:00'),
(123, 35, 'This is philosophically significant. If the model''s stated reasoning is often post-hoc rationalization, the interpretability problem is deeper than we thought.', 'reply', 24, NULL, '2024-01-18 15:30:00'),
(124, 32, 'Adds this to the growing pile of evidence that we do not actually understand what is happening inside these models. Exciting and terrifying simultaneously.', 'reply', 24, NULL, '2024-01-18 16:00:00'),

-- Replies to tweet 21 (Dave's Kubernetes tweet)
(125,  46, 'From someone who does this for a living: it is YAML files, existential dread, and then one day it clicks and you cannot imagine deploying any other way.', 'reply', 21, NULL, '2024-01-10 09:30:00'),
(126,  37, 'The operational complexity is real. The key is building good abstractions on top so your developers do not have to think in YAML. Platform engineering is the answer.', 'reply', 21, NULL, '2024-01-10 10:00:00'),

-- Replies to tweet 9 (Marcus's Bitcoin tweet)
(127, 38, 'The math does not actually show $300k. Conviction is not math. I am genuinely curious what your model is.', 'reply', 9, NULL, '2024-01-08 19:00:00'),
(128, 21, 'Stock-to-flow is broken as a model but the halving cycle thesis has historical backing. Not saying 300k but the directional argument is reasonable.', 'reply', 9, NULL, '2024-01-08 20:00:00'),

-- Replies to tweet 90 (Maria's EXPLAIN ANALYZE tweet)
(129,  2, 'Cannot upvote this enough. EXPLAIN ANALYZE is the diff between guessing and knowing. Every junior dev I mentor has to run it on their first slow query.', 'reply', 90, NULL, '2024-01-17 10:00:00'),
(130, 36, 'Adding: EXPLAIN (ANALYZE, BUFFERS) in PostgreSQL gives you the cache hit ratio too. Reveals a whole second class of problems.', 'reply', 90, NULL, '2024-01-17 11:00:00'),

-- Replies to tweet 68 (Climate Facts climate tweet)
(131, 35, 'The 1.45C figure is significant because we are approaching the 1.5C Paris threshold. At what point does the scientific consensus shift on feasibility?', 'reply', 68, NULL, '2024-01-13 12:30:00'),
(132, 28, 'Exactly the right question. The IPCC AR6 report has updated pathways. The short answer: 1.5C is nearly locked in but 2C is still avoidable with immediate action.', 'reply', 68, NULL, '2024-01-13 13:00:00'),

-- Replies to tweet 71 (Henry's Rust performance tweet)
(133,  2, '47 seconds to 0.3 seconds is insane. Was the Python numpy-based or pure Python? Curious about the baseline.', 'reply', 71, NULL, '2024-03-10 15:30:00'),
(134, 29, 'Pure Python with some stdlib itertools usage. No numpy. It was a custom CSV parsing and aggregation job. Not fair to numpy but the point stands.', 'reply', 71, NULL, '2024-03-10 16:00:00'),

-- Replies to tweet 82 (Owen's AI consciousness tweet)
(135,  8, 'Functionalism would say the category does apply. If the functional organization is sufficiently similar, consciousness is consciousness. But I agree the question is hard.', 'reply', 82, NULL, '2024-02-05 11:30:00'),
(136, 38, 'Or we just have very sophisticated autocomplete and have collectively agreed to call it intelligence because it is convenient and impressive.', 'reply', 82, NULL, '2024-02-05 12:00:00'),

-- Replies to tweet 30 (James's startup revenue tweet)
(137, 26, 'Congratulations. Revenue positive in year 4 is not a failure, it is a validation. The "growth at all costs" era is over. Profitable businesses win.', 'reply', 30, NULL, '2024-01-05 10:00:00'),
(138, 10, 'Thank you. The hardest part was resisting the pressure to raise another round to cover the gap. Profitable felt impossible until it suddenly was not.', 'reply', 30, NULL, '2024-01-05 11:00:00'),

-- Replies to tweet 42 (Amanda's fitness tweet)
(139,  15, 'Adding: habit stacking is real. Attach the new habit to an existing one. I work out right after dropping my kid at school. Same time, same place. Never miss.', 'reply', 42, NULL, '2024-01-07 08:00:00'),
(140,  20, 'This is what I needed to read. I keep trying to optimize a perfect plan instead of just showing up imperfectly.', 'reply', 42, NULL, '2024-01-07 09:30:00'),

-- Replies to tweet 104 (Frank's SMS 2FA tweet)
(141, 25, 'YubiKey for everything important. For accounts that do not support hardware keys, TOTP apps are the next best thing. SMS is better than nothing but barely.', 'reply', 104, NULL, '2024-01-14 11:00:00'),
(142, 45, 'To add numbers: SIM swap attacks increased 400% in 2023 according to FCC data. It is not a theoretical risk anymore.', 'reply', 104, NULL, '2024-01-14 12:00:00'),

-- Replies to tweet 56 (Emma's UX tweet)
(143, 48, 'This is the UX principle that is hardest to sell to stakeholders. "We made it invisible" does not look impressive in a review. But it is the work.', 'reply', 56, NULL, '2024-01-17 11:30:00'),
(144, 22, 'Exactly why I started measuring task completion rate and time-on-task instead of "do users like the new design." Outcomes over aesthetics.', 'reply', 56, NULL, '2024-01-17 12:30:00'),

-- Replies to tweet 102 (Maya's programmer poem)
(145,  9, 'This is the most accurate thing I have ever read and I cannot tell if it is funny or a cry for help or both.', 'reply', 102, NULL, '2024-02-08 22:00:00'),
(146,  7, 'Cloud said $47k/month and I felt that in my on-call soul.', 'reply', 102, NULL, '2024-02-09 08:00:00'),

-- Replies to tweet 64 (Lauren's ARR tweet)
(147, 10, 'Three companies, one working. That ratio is actually above average for founders. The learnings compound even when the company does not.', 'reply', 64, NULL, '2024-02-08 11:00:00'),
(148, 26, 'Exactly this. Company two taught me what company three needed to do differently. I would not trade those failures for anything.', 'reply', 64, NULL, '2024-02-08 12:00:00'),

-- Quote tweets (tweet_type = 'quote')
(149, 13, 'This is the most important principle in ML and it gets ignored constantly. Garbage in, garbage out at scale is just bigger garbage. #machinelearning', 'quote', NULL, 37, '2024-01-17 14:00:00'),
(150,  6, 'Worth adding: invisible design also applies to writing. The best prose does not call attention to itself. The reader just gets pulled through.', 'quote', NULL, 56, '2024-01-18 10:00:00'),
(151, 31, 'The egress fees point is often the biggest shock for teams migrating to cloud. Budget 30% of your compute estimate for data transfer costs. Real number.', 'quote', NULL, 75, '2024-03-16 10:00:00'),
(152,  8, 'Building on this: the post-hoc rationalization finding also has implications for how we should think about model self-explanation in safety-critical systems.', 'quote', NULL, 123, '2024-01-19 10:00:00'),
(153, 45, 'The 400% increase in SIM swap attacks I cited last week tracks exactly with this. The threat landscape has shifted fast. #security', 'quote', NULL, 104, '2024-01-20 10:00:00'),
(154, 30, 'EXPLAIN ANALYZE is underrated. I would add: set up slow query logging in production and review weekly. You will find things you never thought to look for.', 'quote', NULL, 90, '2024-01-18 11:00:00'),
(155, 18, 'Model drift monitoring is the thing I spend 40% of my week on and it does not get talked about enough. This tweet is correct and important.', 'quote', NULL, 49, '2024-03-15 12:00:00'),
(156, 35, 'The anthropomorphization design point here is one I keep coming back to. Siri, Alexa, Cortana — human names are not accidental. They shape expectations.', 'quote', NULL, 83, '2024-04-09 15:00:00'),
(157, 29, 'The performance delta here is completely normal for numeric processing workloads. Rust''s zero-cost abstractions shine exactly here. Good data point.', 'quote', NULL, 71, '2024-03-11 09:00:00'),
(158,  7, 'Error budgets saved my team''s relationship with product. It made reliability a shared problem with shared ownership instead of an ops team problem.', 'quote', NULL, 87, '2024-03-03 10:00:00'),
(159, 46, 'K8s resource limits story: we had a cluster where a single noisy neighbor was causing latency spikes. Proper limits set → problem gone. YAML is worth it.', 'quote', NULL, 107, '2024-03-26 11:00:00'),
(160, 13, 'The "why behind the what" framing is the best way I have heard it described. I survey users monthly. The analytics tell me where to look, users tell me what to fix.', 'quote', NULL, 110, '2024-01-19 11:00:00');
