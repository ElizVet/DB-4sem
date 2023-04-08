use UNIVER;

-- 1 ЗАДАНИЕ
-- список кафедр, которые находятся на факультете, обеспечивающем
-- подготовку по специальности с %технология/ии%
select PULPIT.PULPIT_NAME
from PULPIT, FACULTY
where PULPIT.FACULTY = FACULTY.FACULTY
and FACULTY.FACULTY IN (select PROFESSION.FACULTY from PROFESSION where (PROFESSION_NAME like '%технология%' or PROFESSION_NAME like '%технологии'))

-- 2 ЗАДАНИЕ
-- JOIN + подзапрос
select PULPIT.PULPIT_NAME
from PULPIT join FACULTY
on PULPIT.FACULTY = FACULTY.FACULTY
where FACULTY.FACULTY IN (select PROFESSION.FACULTY from PROFESSION where (PROFESSION_NAME like '%технология%' or PROFESSION_NAME like '%технологии'))

-- 3 ЗАДАНИЕ
-- JOIN + JOIN
select PULPIT.PULPIT_NAME
from PULPIT join FACULTY
on PULPIT.FACULTY = FACULTY.FACULTY
join PROFESSION
on FACULTY.FACULTY = PROFESSION.FACULTY
where PROFESSION_NAME like '%технология%' or PROFESSION_NAME like '%технологии'

-- 4 ЗАДАНИЕ
-- список аудиторий самых больших вместимостей 
-- для каждого типа аудитории
select a.AUDITORIUM_TYPE, a.AUDITORIUM_CAPACITY
from AUDITORIUM a
where a.AUDITORIUM_CAPACITY = 
(select top(1) aa.AUDITORIUM_CAPACITY from AUDITORIUM aa
		where aa.AUDITORIUM_TYPE = a.AUDITORIUM_TYPE
			order by aa.AUDITORIUM_CAPACITY desc)

-- 5 ЗАДАНИЕ
-- список наименований факультетов,
-- на к-м нет ни одной кафедры
select f.FACULTY_NAME
from FACULTY f
where not exists (select * from PULPIT p
		where f.FACULTY = p.FACULTY)
-- здесь пусто, пч у каждого из 6 факультетов есть кафедра

-- 6 ЗАДАНИЕ
-- строка средних значений оценок по предметам
select  top 1
(select avg(NOTE) from PROGRESS where PROGRESS.SUBJECT like 'ОАиП') [ОАиП],
(select isnull(avg(NOTE), 0) from PROGRESS where PROGRESS.SUBJECT like 'БД') [БД],
(select avg(NOTE) from PROGRESS where PROGRESS.SUBJECT like 'СУБД') [СУБД]
from PROGRESS

-- 7 ЗАДАНИЕ
-- 
select a.AUDITORIUM_TYPE, a.AUDITORIUM_CAPACITY
from AUDITORIUM a
where a.AUDITORIUM_CAPACITY >=all 
(select aa.AUDITORIUM_CAPACITY from AUDITORIUM aa where aa.AUDITORIUM_TYPE like 'ЛК-К')

-- 8 ЗАДАНИЕ
select a.AUDITORIUM_TYPE, a.AUDITORIUM_CAPACITY
from AUDITORIUM a
where a.AUDITORIUM_CAPACITY >=any 
(select aa.AUDITORIUM_CAPACITY from AUDITORIUM aa where aa.AUDITORIUM_TYPE like 'ЛК-К')

-- студенты с др в один день
select s.NAME, s.BDAY
from STUDENT s
where exists (select ss.BDAY from STUDENT ss where ss.BDAY = s.BDAY and ss.NAME != s.NAME)
order by s.BDAY