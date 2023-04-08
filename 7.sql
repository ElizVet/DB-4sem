-- 1 ЗАДАНИЕ
create view [Преподаватель]
as select t.TEACHER [код],
		  t.TEACHER_NAME [имя преподавателя],
		  t.GENDER [пол],
		  t.PULPIT [код кафедры]
from TEACHER t

select * from [Преподаватель]

-- 2 ЗАДАНИЕ
create view [Количество кафедр]
as select f.FACULTY_NAME [факультет],
		  count(p.FACULTY) [количество кафедр]
from FACULTY f join PULPIT p on p.FACULTY = f.FACULTY
group by f.FACULTY_NAME

select * from [Количество кафедр]


-- 3 ЗАДАНИЕ
drop view Аудитории

create view [Аудитории]
as select a.AUDITORIUM [код],
		  a.AUDITORIUM_TYPE [тип аудитории]
from AUDITORIUM a
where a.AUDITORIUM_TYPE like 'ЛК%'

select * from Аудитории

insert Аудитории values('105-4','ЛК')

-- 4 ЗАДАНИЕ
create view [Лекционные аудитории]
as select a.AUDITORIUM [код],
		  a.AUDITORIUM_TYPE [тип аудитории]
from AUDITORIUM a
where a.AUDITORIUM_TYPE like 'ЛК%' WITH CHECK OPTION

insert [Лекционные аудитории] values('106-1','ЛБ-К') -- не выполняется из-за ЛБ

-- 5 ЗАДАНИЕ
create view [Дисциплины]
as select TOP 10 s.SUBJECT [код],
		  s.SUBJECT_NAME [наименование дисциплины],
		  s.PULPIT [код кафедры]
from SUBJECT s
order by s.PULPIT

select * from SUBJECT
select * from Дисциплины

-- 6 ЗАДАНИЕ
alter view [Количество кафедр] WITH SCHEMABINDING
as select f.FACULTY_NAME [факультет],
		  count(p.FACULTY) [количество кафедр]
from FACULTY f join PULPIT p on p.FACULTY = f.FACULTY
group by f.FACULTY_NAME


-- 8 ЗАДАНИЕ
-- какие пары есть в какие дни недели:
create view [Расписание]
as select WEEK_DAY, [1], [2], [3], [4]
from TIMETABLE
PIVOT ( count(IDPAIR)
		FOR IDPAIR IN ([1], [2], [3], [4])
) AS [Расписание]
group by WEEK_DAY

select * from TIMETABLE




---------------------------------------
---------------для бд kr---------------
---------------------------------------
create view [Покупатели]
as select CUST_NUM [код],
		  COMPANY [компания],
		  CUST_REP [продавец]
from CUSTOMERS

select * from [Покупатели]

--
create view [Менеджеры офисов в городах]
as select s.NAME [сотрудник], 
		  ofi.CITY [город]
from SALESREPS s join OFFICES ofi on ofi.mgr = s.EMPL_NUM

select * from [Менеджеры офисов в городах]

--
create view [Офисы в городах с двумя словами]
as select OFFICE [код], CITY [город], MGR [менеджер]
from OFFICES 
where CITY like '% %'

--
create view [Офисы в городах с двумя словами(2)]
as select OFFICE [код], CITY [город], MGR [менеджер]
from OFFICES 
where CITY like '% %' WITH CHECK OPTION

--
create view [ЗАКАЗЫ]
as select TOP 10 o.PRODUCT [продукт], o.AMOUNT [цена]
from ORDERS o
order by o.PRODUCT