use UNIVER;

-- 1 �������
-- ������ ������, ������� ��������� �� ����������, ��������������
-- ���������� �� ������������� � %����������/��%
select PULPIT.PULPIT_NAME
from PULPIT, FACULTY
where PULPIT.FACULTY = FACULTY.FACULTY
and FACULTY.FACULTY IN (select PROFESSION.FACULTY from PROFESSION where (PROFESSION_NAME like '%����������%' or PROFESSION_NAME like '%����������'))

-- 2 �������
-- JOIN + ���������
select PULPIT.PULPIT_NAME
from PULPIT join FACULTY
on PULPIT.FACULTY = FACULTY.FACULTY
where FACULTY.FACULTY IN (select PROFESSION.FACULTY from PROFESSION where (PROFESSION_NAME like '%����������%' or PROFESSION_NAME like '%����������'))

-- 3 �������
-- JOIN + JOIN
select PULPIT.PULPIT_NAME
from PULPIT join FACULTY
on PULPIT.FACULTY = FACULTY.FACULTY
join PROFESSION
on FACULTY.FACULTY = PROFESSION.FACULTY
where PROFESSION_NAME like '%����������%' or PROFESSION_NAME like '%����������'

-- 4 �������
-- ������ ��������� ����� ������� ������������ 
-- ��� ������� ���� ���������
select a.AUDITORIUM_TYPE, a.AUDITORIUM_CAPACITY
from AUDITORIUM a
where a.AUDITORIUM_CAPACITY = 
(select top(1) aa.AUDITORIUM_CAPACITY from AUDITORIUM aa
		where aa.AUDITORIUM_TYPE = a.AUDITORIUM_TYPE
			order by aa.AUDITORIUM_CAPACITY desc)

-- 5 �������
-- ������ ������������ �����������,
-- �� �-� ��� �� ����� �������
select f.FACULTY_NAME
from FACULTY f
where not exists (select * from PULPIT p
		where f.FACULTY = p.FACULTY)
-- ����� �����, �� � ������� �� 6 ����������� ���� �������

-- 6 �������
-- ������ ������� �������� ������ �� ���������
select  top 1
(select avg(NOTE) from PROGRESS where PROGRESS.SUBJECT like '����') [����],
(select isnull(avg(NOTE), 0) from PROGRESS where PROGRESS.SUBJECT like '��') [��],
(select avg(NOTE) from PROGRESS where PROGRESS.SUBJECT like '����') [����]
from PROGRESS

-- 7 �������
-- 
select a.AUDITORIUM_TYPE, a.AUDITORIUM_CAPACITY
from AUDITORIUM a
where a.AUDITORIUM_CAPACITY >=all 
(select aa.AUDITORIUM_CAPACITY from AUDITORIUM aa where aa.AUDITORIUM_TYPE like '��-�')

-- 8 �������
select a.AUDITORIUM_TYPE, a.AUDITORIUM_CAPACITY
from AUDITORIUM a
where a.AUDITORIUM_CAPACITY >=any 
(select aa.AUDITORIUM_CAPACITY from AUDITORIUM aa where aa.AUDITORIUM_TYPE like '��-�')

-- �������� � �� � ���� ����
select s.NAME, s.BDAY
from STUDENT s
where exists (select ss.BDAY from STUDENT ss where ss.BDAY = s.BDAY and ss.NAME != s.NAME)
order by s.BDAY