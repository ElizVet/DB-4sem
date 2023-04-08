use UNIVER

SELECT a.AUDITORIUM, at.AUDITORIUM_TYPENAME
FROM AUDITORIUM_TYPE [at] inner join AUDITORIUM [a]
on at.AUDITORIUM_TYPE = a.AUDITORIUM_TYPE;

-- 2 �������
SELECT a.AUDITORIUM, at.AUDITORIUM_TYPENAME
FROM AUDITORIUM_TYPE [at] inner join AUDITORIUM [a]
on at.AUDITORIUM_TYPE = a.AUDITORIUM_TYPE 
and at.AUDITORIUM_TYPENAME like '%���������%';

-- 3 �������
SELECT a.AUDITORIUM, at.AUDITORIUM_TYPENAME
FROM AUDITORIUM_TYPE [at], AUDITORIUM [a]
where at.AUDITORIUM_TYPE = a.AUDITORIUM_TYPE;

SELECT a.AUDITORIUM, at.AUDITORIUM_TYPENAME
FROM AUDITORIUM_TYPE [at], AUDITORIUM [a]
where at.AUDITORIUM_TYPE = a.AUDITORIUM_TYPE
and at.AUDITORIUM_TYPENAME like '%���������%';

-- 4 �������
SELECT pul.PULPIT_NAME as �������, f.FACULTY_NAME as ���������,
s.SUBJECT as ����������, st.NAME as [��� ��������], gr.PROFESSION as �������������,
Case
when (pr.NOTE = 6) then '�����'
when(pr.NOTE = 7) then '����'
else '������'
end [������]
FROM STUDENT [st] inner join PROGRESS [pr] on pr.IDSTUDENT = st.IDSTUDENT and pr.NOTE between 6 and 8
join SUBJECT [s] on pr.SUBJECT = s.SUBJECT
join PULPIT [pul] on s.PULPIT = pul.PULPIT
join FACULTY [f] on pul.FACULTY = f.FACULTY
join GROUPS [gr] on st.IDGROUP = gr.IDGROUP
join PROFESSION [prof] on gr.PROFESSION = prof.PROFESSION
ORDER BY f.FACULTY asc, pul.PULPIT asc, st.NAME asc, pr.NOTE desc;

-- 5 �������
SELECT pul.PULPIT_NAME as �������, f.FACULTY_NAME as ���������,
s.SUBJECT as ����������, st.NAME as [��� ��������], gr.PROFESSION as �������������,
Case
when (pr.NOTE = 6) then '�����'
when(pr.NOTE = 7) then '����'
else '������'
end [������]
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

-- 6 �������
select PULPIT.PULPIT_NAME AS �������, ISNULL(TEACHER.TEACHER_NAME,'***') [�������������]
from PULPIT left outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT;

-- 7 �������
select PULPIT.PULPIT_NAME AS �������, TEACHER.TEACHER_NAME [�������������]
from TEACHER left outer join PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT;

select PULPIT.PULPIT_NAME AS �������, ISNULL(TEACHER.TEACHER_NAME,'***') [�������������]
from TEACHER right outer join PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT;

-- 9 �������
select a.AUDITORIUM, a.AUDITORIUM_CAPACITY, at.AUDITORIUM_TYPENAME
from AUDITORIUM_TYPE [at] cross join AUDITORIUM [a];

select a.AUDITORIUM, a.AUDITORIUM_CAPACITY, at.AUDITORIUM_TYPENAME
from AUDITORIUM_TYPE [at] join AUDITORIUM [a] on at.AUDITORIUM_TYPE = a.AUDITORIUM_TYPE;

-- 11 �������
-- ��������� ��������� �� ����� �����-�� ����
select a.AUDITORIUM [������ ���������]
from AUDITORIUM a inner join TIMETABLE tt
on a.AUDITORIUM != tt.AUDITORIUM
where tt.WEEK_DAY = '�����������' and tt.IDPAIR = 1;

-- ��������� ��������� �� ������������ ���� ������
select a.AUDITORIUM [������ ���������], tt.IDPAIR, tt.WEEK_DAY, tt.AUDITORIUM
from TIMETABLE tt inner join AUDITORIUM a
on a.AUDITORIUM != tt.AUDITORIUM and tt.WEEK_DAY = '�����'

-- ������� ���� � ��������������
select tt.IDPAIR [��������� ���� (����)]
from TIMETABLE tt inner join TEACHER t
on tt.TEACHER = t.TEACHER and tt.TEACHER != '���'
where tt.WEEK_DAY = '�����'

-- ������� ���� � �����
select tt.IDPAIR [��������� ���� (����)]
from TIMETABLE tt inner join GROUPS gr
on tt.IDGROUP = gr.IDGROUP and tt.IDGROUP != 12
where tt.WEEK_DAY = '�����'



/* ****************** */
-- ��� myBase
use Shim_MyBASE
go

SELECT z.������, z.����������, k.�������, k.ID_�������
FROM ������ [z] inner join ������� [k]
on z.id_������� = k.ID_�������

SELECT z.����_�������, k.ID_�������
FROM ������ [z] inner join ������� [k]
on z.id_������� = k.ID_������� and z.����_������� like '2014%';


SELECT z.ID_������, t.������������_������
FROM ������ [z], ������ [t]
where z.id_������ = t.ID_������;

SELECT z.����_�������, k.ID_�������
FROM ������ [z], ������� [k]
where z.id_������� = k.ID_������� and z.����_������� like '2014%';

SELECT z.ID_������, t.������������_������, k.��������,
Case
when (t.���������� > 400) then '> 400'
when(t.���������� < 400) then '< 400'
else '400'
end [�����/����]
FROM ������ [z] join ������� [k] on z.id_������� = k.ID_�������
join ������ [t] on t.ID_������ = z.ID_������ and 
ORDER BY z.ID_������ asc, k.�������� desc;


