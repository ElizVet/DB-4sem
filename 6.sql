-- 1 �������

select max(AUDITORIUM.AUDITORIUM_CAPACITY) [������������ �����������],
min(AUDITORIUM.AUDITORIUM_CAPACITY) [����������� �����������],
AVG(AUDITORIUM.AUDITORIUM_CAPACITY) [������� �����������],
sum(AUDITORIUM.AUDITORIUM_CAPACITY) [��������� �����������],
count(*) [���-�� ���������]
from AUDITORIUM

-- 2 �������
select at.AUDITORIUM_TYPE, -- ������ �������, ���� �� �� � group by
max(a.AUDITORIUM_CAPACITY) [������������ �����������],
min(a.AUDITORIUM_CAPACITY) [����������� �����������],
AVG(a.AUDITORIUM_CAPACITY) [������� �����������],
sum(a.AUDITORIUM_CAPACITY) [��������� �����������],
count(*) [���-�� ���������]
from AUDITORIUM [a] join AUDITORIUM_TYPE [at]
on a.AUDITORIUM_TYPE = at.AUDITORIUM_TYPE
group by at.AUDITORIUM_TYPE

-- 3 �������

select *
from
(select case
	when PROGRESS.NOTE in (4, 5) then '4-5'
	when PROGRESS.NOTE in (6, 7) then '6-7'
	when PROGRESS.NOTE in (8, 9) then '8-9'
	when PROGRESS.NOTE = 10 then '10'
	else 'note < 4'
end [������],
count(*) [����������]
from PROGRESS
group by case
	when PROGRESS.NOTE in (4, 5) then '4-5'
	when PROGRESS.NOTE in (6, 7) then '6-7'
	when PROGRESS.NOTE in (8, 9) then '8-9'
	when PROGRESS.NOTE = 10 then '10'
	else 'note < 4'
end) as T
order by case [������]
	when '4-5' then 4
	when '6-7' then 3
	when '8-9' then 2
	when '10' then 1
	else 5
end

-- 4 �������

select f.FACULTY [���������], 
g.PROFESSION [�������������], 
g.YEAR_FIRST [������ ���],
round(avg(cast(p.NOTE as float(4))), 2) [������� ������]
from FACULTY f join GROUPS g on f.FACULTY = g.FACULTY
join STUDENT s on s.IDGROUP = g.IDGROUP
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by f.FACULTY, g.PROFESSION, g.YEAR_FIRST
order by round(avg(cast(p.NOTE as float(4))), 2) desc

select f.FACULTY [���������], 
g.PROFESSION [�������������], 
2014 - g.YEAR_FIRST [����],
round(avg(cast(p.NOTE as float(4))), 2) [������� ������]
from FACULTY f join GROUPS g on f.FACULTY = g.FACULTY
join STUDENT s on s.IDGROUP = g.IDGROUP
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
where p.SUBJECT in ('��', '����')
group by f.FACULTY, g.PROFESSION, 2014 - g.YEAR_FIRST
order by round(avg(cast(p.NOTE as float(4))), 2) desc

-- 5 �������

select f.FACULTY [���������], 
g.PROFESSION [�������������], 
p.SUBJECT [����������],
avg(p.NOTE) [������� ������]
from FACULTY f join GROUPS g on f.FACULTY = g.FACULTY and f.FACULTY = '��'
join STUDENT s on s.IDGROUP = g.IDGROUP
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by f.FACULTY, g.PROFESSION, p.SUBJECT

-- rollup
select f.FACULTY [���������], 
g.PROFESSION [�������������], 
p.SUBJECT [����������],
avg(p.NOTE) [������� ������]
from FACULTY f join GROUPS g on f.FACULTY = g.FACULTY and f.FACULTY = '��'
join STUDENT s on s.IDGROUP = g.IDGROUP
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by rollup (f.FACULTY, g.PROFESSION, p.SUBJECT) -- (p.SUBJECT, g.PROFESSION, f.FACULTY)

-- 6 �������

-- cube
select f.FACULTY [���������], 
g.PROFESSION [�������������], 
p.SUBJECT [����������],
avg(p.NOTE) [������� ������]
from FACULTY f join GROUPS g on f.FACULTY = g.FACULTY and f.FACULTY = '��'
join STUDENT s on s.IDGROUP = g.IDGROUP
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by cube (f.FACULTY, g.PROFESSION, p.SUBJECT)

-- 7 �������

-- UNOIN
select g.PROFESSION [�������������],
p.SUBJECT [����������],
avg(p.NOTE) [������� ������]
from GROUPS g join STUDENT s on s.IDGROUP = g.IDGROUP and g.FACULTY = '��'
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
UNION
select g.PROFESSION [�������������],
p.SUBJECT [����������],
avg(p.NOTE) [������� ������]
from GROUPS g join STUDENT s on s.IDGROUP = g.IDGROUP
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by g.PROFESSION, p.SUBJECT

-- UNION ALL
select g.PROFESSION [�������������],
p.SUBJECT [����������],
avg(p.NOTE) [������� ������]
from GROUPS g join STUDENT s on s.IDGROUP = g.IDGROUP and g.FACULTY = '��'
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
UNION ALL
select g.PROFESSION [�������������],
p.SUBJECT [����������],
avg(p.NOTE) [������� ������]
from GROUPS g join STUDENT s on s.IDGROUP = g.IDGROUP 
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by g.PROFESSION, p.SUBJECT

-- 8 �������

-- INTERSECT
select g.PROFESSION [�������������],
p.SUBJECT [����������],
avg(p.NOTE) [������� ������]
from GROUPS g join STUDENT s on s.IDGROUP = g.IDGROUP and g.FACULTY = '��'
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
INTERSECT
select g.PROFESSION [�������������],
	p.SUBJECT [����������],
	avg(p.NOTE) [������� ������]
from GROUPS g join STUDENT s on s.IDGROUP = g.IDGROUP and g.FACULTY = '����' 
	join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by g.PROFESSION, p.SUBJECT

-- 9 �������

-- EXCEPT
select g.PROFESSION [�������������],
p.SUBJECT [����������],
avg(p.NOTE) [������� ������]
from GROUPS g join STUDENT s on s.IDGROUP = g.IDGROUP and g.FACULTY = '��'
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
EXCEPT
select g.PROFESSION [�������������],
p.SUBJECT [����������],
avg(p.NOTE) [������� ������]
from GROUPS g join STUDENT s on s.IDGROUP = g.IDGROUP and g.FACULTY = '����'
join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by g.PROFESSION, p.SUBJECT

-- 10 �������

select p1.SUBJECT [����������], p1.NOTE,
(select count(*) from PROGRESS p2 
			where p1.NOTE = p2.NOTE and p1.SUBJECT = p2.SUBJECT) [����������]
from PROGRESS p1
group by p1.NOTE, p1.SUBJECT
having p1.NOTE in(8, 9)

-- 12 �������
select  f.FACULTY [���������], 
g.IDGROUP [����� ������], 
count(*) [���-��]
FROM FACULTY f join GROUPS g ON f.FACULTY = g.FACULTY
join STUDENT on STUDENT.IDGROUP = g.IDGROUP
group by rollup (f.FACULTY, g.IDGROUP)

select  a.AUDITORIUM_TYPE [��� ���������],
	a.AUDITORIUM_CAPACITY [�����������],
	a.AUDITORIUM_NAME [����� ���������], 
count(*) [����������]
FROM AUDITORIUM a
group by rollup (a.AUDITORIUM_TYPE, a.AUDITORIUM_CAPACITY, a.AUDITORIUM_NAME)