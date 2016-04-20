CREATE DATABASE pawstagram;

CREATE TABLE users (
  id SERIAL4 PRIMARY KEY,
  email VARCHAR(50) NOT NULL,
  password_digest VARCHAR(400) NOT NULL,
  username VARCHAR(50) NOT NULL,
  firstname VARCHAR(50) NOT NULL,
  lastname VARCHAR(50) NOT NULL
);

CREATE TABLE photos (
  id SERIAL4 PRIMARY KEY,
  user_id INTEGER,
  img_url VARCHAR(800)
);

CREATE TABLE comments (
  id SERIAL4 PRIMARY KEY,
  body VARCHAR (300) NOT NULL,
  photo_id INTEGER,
  user_id INTEGER
);

CREATE TABLE likes (
  id SERIAL4 PRIMARY KEY,
  user_id INTEGER,
  photo_id INTEGER
);
