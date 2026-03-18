DROP TABLE IF EXISTS group_votes;
DROP TABLE IF EXISTS group_watch_progress;
DROP TABLE IF EXISTS group_watches;
DROP TABLE IF EXISTS group_members;
DROP TABLE IF EXISTS watch_groups;
DROP TABLE IF EXISTS user_films;
DROP TABLE IF EXISTS films;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  display_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL
);

CREATE TABLE films (
  id SERIAL PRIMARY KEY,
  api_id VARCHAR(20) UNIQUE NOT NULL,
  title VARCHAR(255) NOT NULL,
  year INT,
  director VARCHAR(100),
  runtime VARCHAR(20),
  description VARCHAR(1000),
  poster_url VARCHAR(500),
  genre VARCHAR(200),
  rating NUMERIC(2,1)
);

CREATE TABLE user_films (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  film_id INT NOT NULL REFERENCES films(id) ON DELETE CASCADE,
  status VARCHAR(255) NOT NULL CHECK (status IN ('watchlist', 'watched')),
  rating INT CHECK (rating >= 1 AND rating <= 5),
  watched_at TIMESTAMP,
  UNIQUE (user_id, film_id)
);

CREATE TABLE watch_groups (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  creator_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE group_members (
  id SERIAL PRIMARY KEY,
  group_id INT NOT NULL REFERENCES watch_groups(id) ON DELETE CASCADE,
  user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role VARCHAR(255) NOT NULL CHECK (role IN ('host', 'member')) DEFAULT 'member',
  joined_at TIMESTAMP DEFAULT NOW(),
  UNIQUE (group_id, user_id)
);

CREATE TABLE group_watches (
  id SERIAL PRIMARY KEY,
  group_id INT NOT NULL REFERENCES watch_groups(id) ON DELETE CASCADE,
  film_id INT NOT NULL REFERENCES films(id) ON DELETE CASCADE,
  deadline DATE NOT NULL,
  discussion_prompt VARCHAR(500),
  comment VARCHAR(500),
  status VARCHAR(255) NOT NULL CHECK (status IN ('watching', 'complete')) DEFAULT 'watching'
);

CREATE TABLE group_watch_progress (
  id SERIAL PRIMARY KEY,
  group_watch_id INT NOT NULL REFERENCES group_watches(id) ON DELETE CASCADE,
  user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  status VARCHAR(255) NOT NULL CHECK (status IN ('pending', 'watched')) DEFAULT 'pending',
  watched_at TIMESTAMP,
  UNIQUE (group_watch_id, user_id)
);

CREATE TABLE group_votes (
  id SERIAL PRIMARY KEY,
  group_id INT NOT NULL REFERENCES watch_groups(id) ON DELETE CASCADE,
  film_id INT NOT NULL REFERENCES films(id) ON DELETE CASCADE,
  user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE (group_id, film_id, user_id)
);

CREATE TABLE "films" (
  "id" serial PRIMARY KEY,
  "api_id" integer UNIQUE NOT NULL,
  "title" varchar(255) NOT NULL,
  "year" integer,
  "director" varchar(100),
  "runtime" varchar(20),
  "description" varchar(1000),
  "poster_url" varchar(500),
  "genre" varchar(200),
  "rating" numeric(2,1)
);

CREATE TABLE "user_films" (
  "id" serial PRIMARY KEY,
  "user_id" integer NOT NULL,
  "film_id" integer NOT NULL,
  "status" varchar(255) NOT NULL CHECK (status IN ('watchlist', 'watched')),
  "rating" integer CHECK (rating >= 1 AND rating <= 5),
  "watched_at" timestamp
);

CREATE TABLE "watch_groups" (
  "id" serial PRIMARY KEY,
  "name" varchar(100) NOT NULL,
  "creator_id" integer NOT NULL
);

CREATE TABLE "group_members" (
  "id" serial PRIMARY KEY,
  "group_id" integer NOT NULL,
  "user_id" integer NOT NULL,
  "role" varchar(255) NOT NULL CHECK (role IN ('host', 'member')) DEFAULT 'member',
  "joined_at" timestamp DEFAULT (NOW())
);

CREATE TABLE "group_watches" (
  "id" serial PRIMARY KEY,
  "group_id" integer NOT NULL,
  "film_id" integer NOT NULL,
  "deadline" date NOT NULL,
  "discussion_prompt" varchar(500),
  "comment" varchar(500),
  "status" varchar(255) NOT NULL CHECK (status IN ('watching', 'complete')) DEFAULT 'watching'
);

CREATE TABLE "group_watch_progress" (
  "id" serial PRIMARY KEY,
  "group_watch_id" integer NOT NULL,
  "user_id" integer NOT NULL,
  "status" varchar(255) NOT NULL CHECK (status IN ('pending', 'watched')) DEFAULT 'pending',
  "watched_at" timestamp
);

CREATE TABLE "group_votes" (
  "id" serial PRIMARY KEY,
  "group_id" integer NOT NULL,
  "film_id" integer NOT NULL,
  "user_id" integer NOT NULL,
  "created_at" timestamp DEFAULT (NOW())
);

CREATE UNIQUE INDEX "user_films_index_0" ON "user_films" ("user_id", "film_id");
CREATE UNIQUE INDEX "group_members_index_1" ON "group_members" ("group_id", "user_id");
CREATE UNIQUE INDEX "group_watch_progress_index_2" ON "group_watch_progress" ("group_watch_id", "user_id");
CREATE UNIQUE INDEX "group_votes_index_3" ON "group_votes" ("group_id", "film_id", "user_id");
ALTER TABLE "user_films" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE;
ALTER TABLE "user_films" ADD FOREIGN KEY ("film_id") REFERENCES "films" ("id") ON DELETE CASCADE;
ALTER TABLE "watch_groups" ADD FOREIGN KEY ("creator_id") REFERENCES "users" ("id") ON DELETE CASCADE;
ALTER TABLE "group_members" ADD FOREIGN KEY ("group_id") REFERENCES "watch_groups" ("id") ON DELETE CASCADE;
ALTER TABLE "group_members" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE;
ALTER TABLE "group_watches" ADD FOREIGN KEY ("group_id") REFERENCES "watch_groups" ("id") ON DELETE CASCADE;
ALTER TABLE "group_watches" ADD FOREIGN KEY ("film_id") REFERENCES "films" ("id") ON DELETE CASCADE;
ALTER TABLE "group_watch_progress" ADD FOREIGN KEY ("group_watch_id") REFERENCES "group_watches" ("id") ON DELETE CASCADE;
ALTER TABLE "group_watch_progress" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE;
ALTER TABLE "group_votes" ADD FOREIGN KEY ("group_id") REFERENCES "watch_groups" ("id") ON DELETE CASCADE;
ALTER TABLE "group_votes" ADD FOREIGN KEY ("film_id") REFERENCES "films" ("id") ON DELETE CASCADE;
ALTER TABLE "group_votes" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE;
