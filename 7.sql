-- 1 �������
create view [�������������]
as select t.TEACHER [���],
		  t.TEACHER_NAME [��� �������������],
		  t.GENDER [���],
		  t.PULPIT [��� �������]
from TEACHER t

select * from [�������������]

-- 2 �������
create view [���������� ������]
as select f.FACULTY_NAME [���������],
		  count(p.FACULTY) [���������� ������]
from FACULTY f join PULPIT p on p.FACULTY = f.FACULTY
group by f.FACULTY_NAME

select * from [���������� ������]


-- 3 �������
drop view ���������

create view [���������]
as select a.AUDITORIUM [���],
		  a.AUDITORIUM_TYPE [��� ���������]
from AUDITORIUM a
where a.AUDITORIUM_TYPE like '��%'

select * from ���������

insert ��������� values('105-4','��')

-- 4 �������
create view [���������� ���������]
as select a.AUDITORIUM [���],
		  a.AUDITORIUM_TYPE [��� ���������]
from AUDITORIUM a
where a.AUDITORIUM_TYPE like '��%' WITH CHECK OPTION

insert [���������� ���������] values('106-1','��-�') -- �� ����������� ��-�� ��

-- 5 �������
create view [����������]
as select TOP 10 s.SUBJECT [���],
		  s.SUBJECT_NAME [������������ ����������],
		  s.PULPIT [��� �������]
from SUBJECT s
order by s.PULPIT

select * from SUBJECT
select * from ����������

-- 6 �������
alter view [���������� ������] WITH SCHEMABINDING
as select f.FACULTY_NAME [���������],
		  count(p.FACULTY) [���������� ������]
from FACULTY f join PULPIT p on p.FACULTY = f.FACULTY
group by f.FACULTY_NAME


-- 8 �������
-- ����� ���� ���� � ����� ��� ������:
create view [����������]
as select WEEK_DAY, [1], [2], [3], [4]
from TIMETABLE
PIVOT ( count(IDPAIR)
		FOR IDPAIR IN ([1], [2], [3], [4])
) AS [����������]
group by WEEK_DAY

select * from TIMETABLE




---------------------------------------
---------------��� �� kr---------------
---------------------------------------
create view [����������]
as select CUST_NUM [���],
		  COMPANY [��������],
		  CUST_REP [��������]
from CUSTOMERS

select * from [����������]

--
create view [��������� ������ � �������]
as select s.NAME [���������], 
		  ofi.CITY [�����]
from SALESREPS s join OFFICES ofi on ofi.mgr = s.EMPL_NUM

select * from [��������� ������ � �������]

--
create view [����� � ������� � ����� �������]
as select OFFICE [���], CITY [�����], MGR [��������]
from OFFICES 
where CITY like '% %'

--
create view [����� � ������� � ����� �������(2)]
as select OFFICE [���], CITY [�����], MGR [��������]
from OFFICES 
where CITY like '% %' WITH CHECK OPTION

--
create view [������]
as select TOP 10 o.PRODUCT [�������], o.AMOUNT [����]
from ORDERS o
order by o.PRODUCT