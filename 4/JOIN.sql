use UNIVER

SELECT a.AUDITORIUM, at.AUDITORIUM_TYPENAME
FROM AUDITORIUM_TYPE [at] inner join AUDITORIUM [a]
on at.AUDITORIUM_TYPE = a.AUDITORIUM_TYPE;

-- 2 ЗАДАНИЕ
SELECT a.AUDITORIUM, at.AUDITORIUM_TYPENAME
FROM AUDITORIUM_TYPE [at] inner join AUDITORIUM [a]
on at.AUDITORIUM_TYPE = a.AUDITORIUM_TYPE 
and at.AUDITORIUM_TYPENAME like '%компьютер%';

-- 3 ЗАДАНИЕ
SELECT a.AUDITORIUM, at.AUDITORIUM_TYPENAME
FROM AUDITORIUM_TYPE [at], AUDITORIUM [a]
where at.AUDITORIUM_TYPE = a.AUDITORIUM_TYPE;

SELECT a.AUDITORIUM, at.AUDITORIUM_TYPENAME
FROM AUDITORIUM_TYPE [at], AUDITORIUM [a]
where at.AUDITORIUM_TYPE = a.AUDITORIUM_TYPE
and at.AUDITORIUM_TYPENAME like '%компьютер%';

-- 4 ЗАДАНИЕ
SELECT pul.PULPIT_NAME as Кафедра, f.FACULTY_NAME as Факультет,
s.SUBJECT as Дисциплина, st.NAME as [Имя студента], gr.PROFESSION as Специальность,
Case
when (pr.NOTE = 6) then 'шесть'
when(pr.NOTE = 7) then 'семь'
else 'восемь'
end [Оценка]
FROM STUDENT [st] inner join PROGRESS [pr] on pr.IDSTUDENT = st.IDSTUDENT and pr.NOTE between 6 and 8
join SUBJECT [s] on pr.SUBJECT = s.SUBJECT
join PULPIT [pul] on s.PULPIT = pul.PULPIT
join FACULTY [f] on pul.FACULTY = f.FACULTY
join GROUPS [gr] on st.IDGROUP = gr.IDGROUP
join PROFESSION [prof] on gr.PROFESSION = prof.PROFESSION
ORDER BY f.FACULTY asc, pul.PULPIT asc, st.NAME asc, pr.NOTE desc;

-- 5 ЗАДАНИЕ
SELECT pul.PULPIT_NAME as Кафедра, f.FACULTY_NAME as Факультет,
s.SUBJECT as Дисциплина, st.NAME as [Имя студента], gr.PROFESSION as Специальность,
Case
when (pr.NOTE = 6) then 'шесть'
when(pr.NOTE = 7) then 'семь'
else 'восемь'
end [Оценка]
FROM STUDENT [st] inner join PROGRESS [pr] on pr.IDSTUDENT = st.IDSTUDENT and pr.NOTE between 6 and 8
join SUBJECT [s] on pr.SUBJECT = s.SUBJECT
join PULPIT [pul] on s.PULPIT = pul.PULPIT
join FACULTY [f] on pul.FACULTY = f.FACULTY
join GROUPS [gr] on st.IDGROUP = gr.IDGROUP
join PROFESSION [prof] on gr.PROFESSION = prof.PROFESSION
ORDER BY 
(case
	when(pr.NOTE = 8) then 2
	when(pr.NOTE = 7) then 1
	else 3
	end
)

-- 6 ЗАДАНИЕ
select PULPIT.PULPIT_NAME AS Кафедра, ISNULL(TEACHER.TEACHER_NAME,'***') [Преподаватель]
from PULPIT left outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT;

-- 7 ЗАДАНИЕ
select PULPIT.PULPIT_NAME AS Кафедра, TEACHER.TEACHER_NAME [Преподаватель]
from TEACHER left outer join PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT;

select PULPIT.PULPIT_NAME AS Кафедра, ISNULL(TEACHER.TEACHER_NAME,'***') [Преподаватель]
from TEACHER right outer join PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT;

-- 9 ЗАДАНИЕ
select a.AUDITORIUM, a.AUDITORIUM_CAPACITY, at.AUDITORIUM_TYPENAME
from AUDITORIUM_TYPE [at] cross join AUDITORIUM [a];

select a.AUDITORIUM, a.AUDITORIUM_CAPACITY, at.AUDITORIUM_TYPENAME
from AUDITORIUM_TYPE [at] join AUDITORIUM [a] on at.AUDITORIUM_TYPE = a.AUDITORIUM_TYPE;

-- 11 ЗАДАНИЕ
-- свободные аудитории во время такой-то пары
select a.AUDITORIUM [пустые аудитории]
from AUDITORIUM a inner join TIMETABLE tt
on a.AUDITORIUM != tt.AUDITORIUM
where tt.WEEK_DAY = 'Понедельник' and tt.IDPAIR = 1;

-- свободные аудитории на определенный день недели
select a.AUDITORIUM [пустые аудитории], tt.IDPAIR, tt.WEEK_DAY, tt.AUDITORIUM
from TIMETABLE tt inner join AUDITORIUM a
on a.AUDITORIUM != tt.AUDITORIUM and tt.WEEK_DAY = 'Среда'

-- наличие окон у преподавателей
select tt.IDPAIR [свободные пары (окна)]
from TIMETABLE tt inner join TEACHER t
on tt.TEACHER = t.TEACHER and tt.TEACHER != 'БРГ'
where tt.WEEK_DAY = 'Среда'

-- наличие окон у групп
select tt.IDPAIR [свободные пары (окна)]
from TIMETABLE tt inner join GROUPS gr
on tt.IDGROUP = gr.IDGROUP and tt.IDGROUP != 12
where tt.WEEK_DAY = 'Среда'



/* ****************** */
-- для myBase
use Shim_MyBASE
go

SELECT z.Скидка, z.Количество, k.Фамилия, k.ID_клиента
FROM ЗАКАЗЫ [z] inner join КЛИЕНТЫ [k]
on z.id_клиента = k.ID_клиента

SELECT z.Дата_продажи, k.ID_клиента
FROM ЗАКАЗЫ [z] inner join КЛИЕНТЫ [k]
on z.id_клиента = k.ID_клиента and z.Дата_продажи like '2014%';


SELECT z.ID_заказа, t.Наименование_товара
FROM ЗАКАЗЫ [z], ТОВАРЫ [t]
where z.id_товара = t.ID_товара;

SELECT z.Дата_продажи, k.ID_клиента
FROM ЗАКАЗЫ [z], КЛИЕНТЫ [k]
where z.id_клиента = k.ID_клиента and z.Дата_продажи like '2014%';

SELECT z.ID_заказа, t.Наименование_товара, k.Отчество,
Case
when (t.Количество > 400) then '> 400'
when(t.Количество < 400) then '< 400'
else '400'
end [Много/мало]
FROM ЗАКАЗЫ [z] join КЛИЕНТЫ [k] on z.id_клиента = k.ID_клиента
join ТОВАРЫ [t] on t.ID_товара = z.ID_заказа and 
ORDER BY z.ID_заказа asc, k.Отчество desc;


