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
-- we are multyplying d.dau to change format from in to float
4.select event_date, sum(revenue) from events group by event_date order by event_date; --revenue per day
5.select sum(e.revenue) * 1.0 / count(u.id) as arpu from users u left join events e on u.id = e.user_id;  --ARPU