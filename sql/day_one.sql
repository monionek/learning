-- count how many users there are
select count(*) from users;
-- How many users per country
select country, count(*) from users group by country; 
-- 3. how many events per type
select event_type, count(*) from events group by event_type; 
-- 4. total revenue
select sum(revenue) from events;
-- 5. revenue per plan
select plan, sum(revenue) from users join events on users.id = events.user_id group by plan;
-- 6. DAU (Daily active users):
select count(DISTINCT user_id) as users, event_date from events Where( event_type = 'login' ) group by event_date;
-- 7. Revenue per day sorted desc
select event_date, Sum(revenue) as rev from events group by event_date order by event_date DESC;
-- 8. average revenue per user
select user_id, avg(revenue) as averageRev from events group by user_id order by averagerev DESC;
-- 9. number of users that have bought at least once
select count(distinct case when event_type = 'purchase' then e.user_id end) as numberofusers from events e;
-- 10. percentage of users that have bought at least once
select count(distinct case when event_type = 'purchase' then e.user_id end) * 100 / count(distinct u.id) as percentageofuser from users u left join events e on u.id = e.user_id;
-- 11. Top 3 users by revenue
select user_id, sum(revenue) as rev from events where( event_type = 'purchase') group by user_id order by rev desc limit 3;
-- 12. Revenue per country
select country, sum(revenue) as rev from users u left join events e on e.user_id = u.id group by  country;
-- 13. first event of every user
select distinct on (user_id) user_id, event_date from events order by user_id, event_date

    
