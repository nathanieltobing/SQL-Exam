--1--
select p.player_name, [Team Region] = rt.region_name,[Player Region] = r.region_name
from player p join region r on p.region_id = r.region_id
join team_detail td on td.player_id = p.player_id 
join team t on td.team_id = t.team_id
join region rt on rt.region_id = t.region_id
where rt.region_name like '% %'

--2--
select m.match_schedule,t.team_name,md.team_score
from [match] m join match_detail md on m.match_id = md.match_id
join team t on t.team_id = md.team_id
where datediff (day, m.match_schedule,'2021-10-20') = 8 and md.team_score = 2 

--3--
select t.team_name, count(md.match_id) as [total_play], sum(md.team_score) as total_score
from team t join match_detail md on t.team_id = md.team_id,
(
	select t.team_id, count(md.match_id) as [total_play], sum(md.team_score) as total_score
	from team t join match_detail md on t.team_id = md.team_id
	group by t.team_id
	having count(md.match_id) = 2 and sum(md.team_score) between 0 and 3
) as s
where t.team_id = s.team_id
group by team_name

--4--
select player_name,position_name
from player p join team_detail td on p.player_id = td.player_id
join position pos on pos.position_id = td.position_id,
(
	select  sum(md.team_score) as total_score, t.team_id as tID
	from team t join match_detail md on t.team_id = md.team_id
	group by t.team_id
	having sum(md.team_score) between 4 and 5
) as s
where td.team_id = s.tID and pos.position_name in ('Carry','Support 4','Support 5')

--5--
select *
from (
	select top 1 r.region_name, count(t.team_id) as [Total Team]
	from region r join team t on r.region_id = t.region_id
	group by r.region_name
	order by [Total Team] DESC
) as a1
union 
select *
from (
	select top 1 r.region_name, count(t.team_id) as [Total Team]
	from region r join team t on r.region_id = t.region_id
	group by r.region_name
	order by [Total Team] ASC
) as a2

--6--
go
select s.tNM as team_name,s.mTS as team_score,t.team_name as Opponent,md.team_score as [Opponent Score],
case
	when s.mTS >= 2 then 'WIN'
	else 'LOSE'
end as Result
from match_detail md join team t on md.team_id = t.team_id,
(
	select md.match_id as mID,t.team_name as tNM,md.team_score as mTS
	from match_detail md join team t on md.team_id = t.team_id
	where t.team_id in ('TM003')
) as s
where  md.match_id = s.mID and t.team_name not in('Team Spirit')

go

--7--
create view [Player Who Played the Most] as
select  p.player_name
from player p,
(
	select top 20 p.player_name as pPN, count(md.match_id) as [Total Match]
	from player p join team_detail td on p.player_id = td.player_id join
	team t on t.team_id = td.team_id join match_detail md on t.team_id = md.team_id
	group by p.player_name
	having count(md.match_id) > 0
	order by [Total Match] DESC	
) as s
where p.player_name in (s.pPN)

--8--
select p.player_name , td.joined_date, t.team_name
from player p join team_detail td on p.player_id = td.player_id join
team t on td.team_id = t.team_id


--9--
select player_name,position_name,team_name,joined_date
from player p join team_detail td on p.player_id = td.player_id join
team t on td.team_id = t.team_id join position pos on td.position_id = pos.position_id
where year(joined_date) = 2021 and month(joined_date) < 10

go

--10--
select  r.region_name,count(p.player_id) as [Total Player]
from region r join player p on r.region_id = p.region_id,
(
	select top 1 region_name as sRN,count(p.player_id) as Total
	from region r join player p on r.region_id = p.region_id
	group by r.region_name
	order by Total desc
) as s
where r.region_name = s.sRN
group by r.region_name








