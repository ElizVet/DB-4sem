-- 1 задание

select max(AUDITORIUM.AUDITORIUM_CAPACITY) [Максимальная вместимость],
min(AUDITORIUM.AUDITORIUM_CAPACITY) [Минимальная вместимость],
AVG(AUDITORIUM.AUDITORIUM_CAPACITY) [Средняя вместимость],
sum(AUDITORIUM.AUDITORIUM_CAPACITY) [Суммарная вместимость],
count(*) [Кол-во аудиторий]
from AUDITORIUM

-- 2 задание
select at.AUDITORIUM_TYPE, -- нельзя вывести, если он не в group by
max(a.AUDITORIUM_CAPACITY) [Максимальная вместимость],
min(a.AUDITORIUM_CAPACITY) [Минимальная вместимость],
AVG(a.AUDITORIUM_CAPACITY) [Средняя вместимость],
sum(a.AUDITORIUM_CAPACITY) [Суммарная вместимость],
count(*) [Кол-во аудиторий]
from AUDITORIUM [a] join AUDITORIUM_TYPE [at]
on a.AUDITORIUM_TYPE = at.AUDITORIUM_TYPE
group by at.AUDITORIUM_TYPE

-- 3 задание

select *
from
(select case
	when PROGRESS.NOTE in (4, 5) then '4-5'
	when PROGRESS.NOTE in (6, 7) then '6-7'
	when PROGRESS.NOTE in (8, 9) then '8-9'
	when PROGRESS.NOTE = 10 then '10'
	else 'note < 4'
end [Оценки],
count(*) [Количество]
from PROGRESS
group by case
	when PROGRESS.NOTE in (4, 5) then '4-5'
	when PROGRESS.NOTE in (6, 7) then '6-7'
	when PROGRESS.NOTE in (8, 9) then '8-9'
	when PROGRESS.NOTE = 10 then '10'
	else 'note < 4'
end) as T
order by case [Оценки]
	when '4-5' then 4
	when '6-7' then 3
	when '8-9' then 2
	when '10' then 1
	else 5
end

-- 4 задание

select f.FACULTY [факультет], 
g.PROFESSION [специальность], 
g.YEAR_FIRST [первый год],
round(avg(cast(p.NOTE as float(4))), 2) [средняя оценка]
from FACULTY f join GROUPS g on f.FACULTY = g.FACULTY
join STUDENT s on s.IDGROUP = g.IDGROUP
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by f.FACULTY, g.PROFESSION, g.YEAR_FIRST
order by round(avg(cast(p.NOTE as float(4))), 2) desc

select f.FACULTY [факультет], 
g.PROFESSION [специальность], 
2014 - g.YEAR_FIRST [курс],
round(avg(cast(p.NOTE as float(4))), 2) [средняя оценка]
from FACULTY f join GROUPS g on f.FACULTY = g.FACULTY
join STUDENT s on s.IDGROUP = g.IDGROUP
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
where p.SUBJECT in ('БД', 'ОАиП')
group by f.FACULTY, g.PROFESSION, 2014 - g.YEAR_FIRST
order by round(avg(cast(p.NOTE as float(4))), 2) desc

-- 5 задание

select f.FACULTY [факультет], 
g.PROFESSION [специальность], 
p.SUBJECT [дисциплина],
avg(p.NOTE) [средняя оценка]
from FACULTY f join GROUPS g on f.FACULTY = g.FACULTY and f.FACULTY = 'ИТ'
join STUDENT s on s.IDGROUP = g.IDGROUP
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by f.FACULTY, g.PROFESSION, p.SUBJECT

-- rollup
select f.FACULTY [факультет], 
g.PROFESSION [специальность], 
p.SUBJECT [дисциплина],
avg(p.NOTE) [средняя оценка]
from FACULTY f join GROUPS g on f.FACULTY = g.FACULTY and f.FACULTY = 'ИТ'
join STUDENT s on s.IDGROUP = g.IDGROUP
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by rollup (f.FACULTY, g.PROFESSION, p.SUBJECT) -- (p.SUBJECT, g.PROFESSION, f.FACULTY)

-- 6 задание

-- cube
select f.FACULTY [факультет], 
g.PROFESSION [специальность], 
p.SUBJECT [дисциплина],
avg(p.NOTE) [средняя оценка]
from FACULTY f join GROUPS g on f.FACULTY = g.FACULTY and f.FACULTY = 'ИТ'
join STUDENT s on s.IDGROUP = g.IDGROUP
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by cube (f.FACULTY, g.PROFESSION, p.SUBJECT)

-- 7 задание

-- UNOIN
select g.PROFESSION [специальность],
p.SUBJECT [дисциплина],
avg(p.NOTE) [средняя оценка]
from GROUPS g join STUDENT s on s.IDGROUP = g.IDGROUP and g.FACULTY = 'ИТ'
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
UNION
select g.PROFESSION [специальность],
p.SUBJECT [дисциплина],
avg(p.NOTE) [средняя оценка]
from GROUPS g join STUDENT s on s.IDGROUP = g.IDGROUP
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by g.PROFESSION, p.SUBJECT

-- UNION ALL
select g.PROFESSION [специальность],
p.SUBJECT [дисциплина],
avg(p.NOTE) [средняя оценка]
from GROUPS g join STUDENT s on s.IDGROUP = g.IDGROUP and g.FACULTY = 'ИТ'
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
UNION ALL
select g.PROFESSION [специальность],
p.SUBJECT [дисциплина],
avg(p.NOTE) [средняя оценка]
from GROUPS g join STUDENT s on s.IDGROUP = g.IDGROUP 
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by g.PROFESSION, p.SUBJECT

-- 8 задание

-- INTERSECT
select g.PROFESSION [специальность],
p.SUBJECT [дисциплина],
avg(p.NOTE) [средняя оценка]
from GROUPS g join STUDENT s on s.IDGROUP = g.IDGROUP and g.FACULTY = 'ИТ'
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
INTERSECT
select g.PROFESSION [специальность],
	p.SUBJECT [дисциплина],
	avg(p.NOTE) [средняя оценка]
from GROUPS g join STUDENT s on s.IDGROUP = g.IDGROUP and g.FACULTY = 'ХТиТ' 
	join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by g.PROFESSION, p.SUBJECT

-- 9 задание

-- EXCEPT
select g.PROFESSION [специальность],
p.SUBJECT [дисциплина],
avg(p.NOTE) [средняя оценка]
from GROUPS g join STUDENT s on s.IDGROUP = g.IDGROUP and g.FACULTY = 'ИТ'
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
EXCEPT
select g.PROFESSION [специальность],
p.SUBJECT [дисциплина],
avg(p.NOTE) [средняя оценка]
from GROUPS g join STUDENT s on s.IDGROUP = g.IDGROUP and g.FACULTY = 'ХТиТ'
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by g.PROFESSION, p.SUBJECT

-- 10 задание

select p1.SUBJECT [Дисциплина], p1.NOTE,
(select count(*) from PROGRESS p2 
			where p1.NOTE = p2.NOTE and p1.SUBJECT = p2.SUBJECT) [Количество]
from PROGRESS p1
group by p1.NOTE, p1.SUBJECT
having p1.NOTE in(8, 9)

-- 12 задание
select  f.FACULTY [факультет], 
g.IDGROUP [номер группы], 
count(*) [кол-во]
FROM FACULTY f join GROUPS g ON f.FACULTY = g.FACULTY
join STUDENT on STUDENT.IDGROUP = g.IDGROUP
group by rollup (f.FACULTY, g.IDGROUP)

select  a.AUDITORIUM_TYPE [тип аудитории],
	a.AUDITORIUM_CAPACITY [вместимость],
	a.AUDITORIUM_NAME [номер аудитории], 
count(*) [количество]
FROM AUDITORIUM a
group by rollup (a.AUDITORIUM_TYPE, a.AUDITORIUM_CAPACITY, a.AUDITORIUM_NAME)