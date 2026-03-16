CREATE TABLE users (
  id INT,
  country TEXT,
  plan TEXT,
  signup_date DATE
);

CREATE TABLE events (
  event_id INT,
  user_id INT,
  event_type TEXT,
  event_date DATE,
  revenue INT
);