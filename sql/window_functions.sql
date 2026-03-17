1.cumulative revenue
select event_date, revenue, sum(revenue) over (order by event_date) from events where revenue > 0;
2.cumulative revenue per user
select user_id, event_date, revenue, sum(revenue) over(partition by user_id order by event_date) from events;
3.user event count
select user_id, event_type, row_number() over (partition by user_id) from events;
4.previous event of user 
select user_id, event_type, lag(event_type) over (partition by user_id) as previous_action from events
5.time beetwen previous user event
select user_id, event_type, event_date, event_date - lag(event_date) over (partition by user_id order by event_date ASC) as last_action_date from events e;
6.user ranking by revenue
select user_id, revenue, rank() over (order by revenue DESC) from events;
7.user ranking by revenue per country
select user_id, country, revenue, rank() over (partition by country order by revenue DESC) from events e join users u on e.user_id = u.id;
8. avg revenue from last 3 buy events
select revenue, event_date, avg(revenue) over (order by event_date asc rows between 2 preceding and current row) from events where revenue > 0;
9.adding count to user action
select user_id, event_date, event_type, row_number() over (partition by user_id order by event_date asc) from events;
10. user retention
with first_event as (
select user_id, min(event_date) as first_event_date
	from events
	group by user_id
),
helper as (
select
 	e.user_id,
 	e.event_date,
 	f.first_event_date,
 	e.event_date - f.first_event_date AS days_since_signup
from events e
join first_event f
on e.user_id = f.user_id
)
select days_since_signup, count(distinct user_id) from helper group by days_since_signup order by days_since_signup

