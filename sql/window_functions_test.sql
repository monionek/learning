1. Running total of revenue per day (cumulative daily revenue)
with daily as (
  select event_date, sum(revenue) as daily_rev
  from events
  group by event_date
)
select
  event_date,
  daily_rev,
  sum(daily_rev) over (order by event_date)
from daily;
2. Running total of revenue per user (cumulative user revenue over time)
select user_id, event_date, revenue, sum(revenue) over (partition by user_id order by event_date asc) from events;
3. Sequential numbering of user events (event order per user)
select user_id, event_date, event_type, row_number() over (partition by user_id order by event_date asc) from events;
4. Previous event type for each user event (using LAG)
select user_id, event_date, event_type, lag(event_type) over (partition by user_id order by event_date asc) as previous_event from events;
5. Time difference between consecutive user events
select user_id, event_date, event_date - lag(event_date) over (partition by user_id order by event_date asc) as days_from_previous_event from events;
6. Ranking users by total revenue (global ranking)
with helper as (
	select
		user_id,
		sum(revenue) as total_revenue
	from events
	group by user_id
)
select user_id, total_revenue, dense_rank() over (order by total_revenue desc) as rank from helper;
7. Ranking users by revenue within each country
with helper as (
	select
		id,
		country,
		sum(revenue) as total_revenue
	from users u join events e on u.id=e.user_id 
	group by id, country
)
select id, country, total_revenue, rank() over (partition by country order by total_revenue desc) from helper;
8. Rolling sum of revenue over last 7 events (moving window)
select event_date, revenue, sum(revenue) over (order by event_date asc rows between 6 preceding and current row) from events;
9. First purchase date per user
select user_id, min(event_date) as first_purchase_date from events where event_type = 'purchase' group by user_id, event_type order by user_id;
10. Time to conversion (days from first login to first purchase)
with first_login AS (
  select 
    user_id,
    MIN(event_date) AS first_login_date
  from events
  where event_type = 'login'
  group by user_id
),
first_purchase AS (
  select 
    user_id,
    MIN(event_date) AS first_purchase_date
  from events
  where event_type = 'purchase'
  group by user_id
)
select
  l.user_id,
  l.first_login_date,
  p.first_purchase_date,
  p.first_purchase_date - l.first_login_date as days_to_purchase
from first_login l
left join first_purchase p 
  on l.user_id = p.user_id;