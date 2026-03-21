-- There will be commands for getting informations for things desciptied in description
1.select event_date, count(distinct user_id) as dau from events group by event_date order by event_date; --DAU
2.select date_trunc('month', event_date) as month, count(distinct user_id) as mau from events group by date_trunc('month', event_date); --MAU
3.
with MAU as (
	select
		date_trunc('month', event_date) as month,
		count(distinct user_id) as mau
	from events
	group by date_trunc('month', event_date)
),
DAU as (
	select
		event_date,
		count(distinct user_id) as dau
	from events
	group by event_date
)
select d.event_date, d.dau * 1.0 / m.mau AS stickiness from DAU d join MAU m on date_trunc('month', d.event_date) = m.month; --stickiness
-- we are multiplying d.dau to change format from int to float
4.select event_date, sum(revenue) from events group by event_date order by event_date; --revenue per day
5.select sum(e.revenue) * 1.0 / count(u.id) as arpu from users u left join events e on u.id = e.user_id;  --ARPU
6.
with first_user_login as (
	select
		user_id,
		min(event_date) as first_login
	from events
	where event_type = 'login'
	group by user_id
),
first_user_purchase as (
	select
		user_id,
		min(event_date) as first_purchase
	from events
	where event_type = 'purchase'
	group by user_id
)
select count(case when fup.first_purchase >= ful.first_login then 1 end) * 1.0 / count(ful.user_id) as conversion_rate from first_user_login ful left join first_user_purchase fup on fup.user_id = ful.user_id;
-- conversion rate 
7.
with first_login_day as (
	select
		user_id,
		min(event_date) as login_day
	from events
	where event_type = 'login'
	group by user_id
)
select count(distinct case when e.event_date = fld.login_day + 1 then e.user_id end) * 1.0 / count(distinct fld.user_id) as day1_retention from events e join first_login_day fld on fld.user_id = e.user_id;
--day 1 retention

with first_login_day as (
	select
		user_id,
		min(event_date) as login_day
	from events
	where event_type = 'login'
	group by user_id
)
select count(distinct case when e.event_date = fld.login_day + 7 then e.user_id end) * 1.0 / count(distinct fld.user_id) as day7_retention from events e join first_login_day fld on fld.user_id = e.user_id;
--day 7 retention