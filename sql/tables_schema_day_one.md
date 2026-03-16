Tabela users
id INT
signup_date DATE
country TEXT
plan TEXT

Tabela events
id INT
user_id INT
event_date DATE
event_type TEXT   -- login / view / purchase
revenue NUMERIC