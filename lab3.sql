USE master /*8) �������� �� � ����������� ������ */
go
create database Shim_MyBASE
on primary
(name = N'Shim_MyBASE_mdf', filename = N'D:\4 ���\�Ψ\��\3\Shim_MyBASE.mdf',
size = 10240Kb, maxsize = UNLIMITED, filegrowth = 1024Kb),
(name = N'Shim_MyBASE_ndf', filename = N'D:\4 ���\�Ψ\��\3\Shim_MyBASE.ndf',
size = 10240Kb, maxsize = 1Gb, filegrowth = 25%),
filegroup FG1
(name = N'Shim_MyBASE_fg1_1', filename = N'D:\4 ���\�Ψ\��\3\Shim_MyBASE_fg1_1.ndf',
size = 10240Kb, maxsize = 1Gb, filegrowth = 25%),
(name = N'Shim_MyBASE_fg1_2', filename = N'D:\4 ���\�Ψ\��\3\Shim_MyBASE_fg1_2.ndf',
size = 10240Kb, maxsize = 1Gb, filegrowth = 25%),
filegroup FG2
(name = N'Shim_MyBASE_fg2_1', filename = N'D:\4 ���\�Ψ\��\3\Shim_MyBASE_fg2_1.ndf',
size = 10240Kb, maxsize = 1Gb, filegrowth = 25%),
(name = N'Shim_MyBASE_fg2_2', filename = N'D:\4 ���\�Ψ\��\3\Shim_MyBASE_fg2_2.ndf',
size = 10240Kb, maxsize = 1Gb, filegrowth = 25%)
log on
(name = N'Shim_MyBASE_log', filename = N'D:\4 ���\�Ψ\��\3\Shim_MyBASE_log.ldf',
size = 10240Kb, maxsize = 2048Gb, filegrowth = 10%)

/*2) �������� ������ */
use Shim_MyBASE
CREATE table �������
(	ID_������� nvarchar(10) primary key,
	������� nvarchar(20) not null,
	��� nvarchar(20) not null,
	�������� nvarchar(20) not null,
	����� nvarchar(150) unique not null,
	������� nvarchar(40) unique not null,
	Mail nvarchar(150) unique not null
) on FG1;
CREATE table ������
(	ID_������ nvarchar(10) primary key,
	������������_������ nvarchar(100) not null,
	���� real not null,
	��������_������� nvarchar(100) not null,
	���������� int not null
) on FG2;
CREATE table ������
(	ID_������ nvarchar(10) primary key,
	����_������� date not null,
	id_������ nvarchar(10) foreign key references ������(ID_������) not null,
	id_������� nvarchar(10) foreign key references �������(ID_�������) not null,
	���������� int not null,
	������ nvarchar(3) not null
) on FG1;

/* �������� ������ */
DROP TABLE dbo.������;
DROP TABLE dbo.������;
DROP TABLE dbo.�������;

/*3) ���������� ������� "����_�����������" */
ALTER table ������ ADD ����_����������� date not null;

select *
from ������

ALTER table ������ DROP column ����_�����������;

/*4) ���������� ���-� � ������� */
use Shim_MyBASE
INSERT INTO �������(ID_�������, ���, �������, ��������, �����, �������, Mail)
	values('1', '������', '�����', '����������', '�. ������, ������� ��., �. 79', '6(452)549-62-13', 'mixa@mail.ru'),
		('3', '�������', '��������', '����������', '�. ��������, ������� ��., �. 44', '6(452)899-99-88', 'dimril@mail.ru'),
		('2', '���', '�������', '���������', '�. ������, ������� ��., �. 38', '6(452)077-45-01', 'abram@mail.ru');

INSERT INTO ������(ID_������, ������������_������, ����, ��������_�������, ����������)
				values('1', '������� "��������"', 300, '���������� �����', 99),
						('2', '����� "�����"', 555.102 , '����', 603);

INSERT INTO ������(ID_������, ����_�������, id_������, id_�������, ����������, ������)
				values('1', '2012-05-01', '2', '2', 13, '��'),
						('2', '2012-01-03', '2', '2', 25, '��'),
						('3', '2012-12-12', '1', '2', 300, '���'),
						('4', '2014-10-11', '1', '3', 16, '���');

/* 5) ������� */
SELECT * FROM �������;

SELECT ID_������, ������������_������ FROM ������;

SELECT count(*) as [���-�� �����'] FROM �������;

SELECT DISTINCT * FROM ������
WHERE ����_������� > '2021-01-01';

SELECT TOP(2) ID_�������, �������, ������� FROM �������
order by ID_������� desc;

select *
from ������

/*6) ��������� ���-� ����� */
UPDATE ������ set ���������� = 505 Where ID_������ = '1';
UPDATE ������ set ���������� = 223 Where ID_������ = '2';

SELECT ID_������, ���������� FROM ������;

/*7) ����� ���-� � ����������� */
SELECT �������, ����� FROM ������� WHERE ������� LIKE '%��';

SELECT ID_������, ������������_������, ����, ����������
FROM ������ 
WHERE ���������� IN (99,600, 44);

SELECT * FROM ������
WHERE ���� BETWEEN 500 AND 1000 /*OR ���������� > 500;*/