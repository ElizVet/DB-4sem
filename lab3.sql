USE master /*8) создание бд с размещением файлов */
go
create database Shim_MyBASE
on primary
(name = N'Shim_MyBASE_mdf', filename = N'D:\4 сем\МОЁ\бд\3\Shim_MyBASE.mdf',
size = 10240Kb, maxsize = UNLIMITED, filegrowth = 1024Kb),
(name = N'Shim_MyBASE_ndf', filename = N'D:\4 сем\МОЁ\бд\3\Shim_MyBASE.ndf',
size = 10240Kb, maxsize = 1Gb, filegrowth = 25%),
filegroup FG1
(name = N'Shim_MyBASE_fg1_1', filename = N'D:\4 сем\МОЁ\бд\3\Shim_MyBASE_fg1_1.ndf',
size = 10240Kb, maxsize = 1Gb, filegrowth = 25%),
(name = N'Shim_MyBASE_fg1_2', filename = N'D:\4 сем\МОЁ\бд\3\Shim_MyBASE_fg1_2.ndf',
size = 10240Kb, maxsize = 1Gb, filegrowth = 25%),
filegroup FG2
(name = N'Shim_MyBASE_fg2_1', filename = N'D:\4 сем\МОЁ\бд\3\Shim_MyBASE_fg2_1.ndf',
size = 10240Kb, maxsize = 1Gb, filegrowth = 25%),
(name = N'Shim_MyBASE_fg2_2', filename = N'D:\4 сем\МОЁ\бд\3\Shim_MyBASE_fg2_2.ndf',
size = 10240Kb, maxsize = 1Gb, filegrowth = 25%)
log on
(name = N'Shim_MyBASE_log', filename = N'D:\4 сем\МОЁ\бд\3\Shim_MyBASE_log.ldf',
size = 10240Kb, maxsize = 2048Gb, filegrowth = 10%)

/*2) создание таблиц */
use Shim_MyBASE
CREATE table КЛИЕНТЫ
(	ID_клиента nvarchar(10) primary key,
	Фамилия nvarchar(20) not null,
	Имя nvarchar(20) not null,
	Отчество nvarchar(20) not null,
	Адрес nvarchar(150) unique not null,
	Телефон nvarchar(40) unique not null,
	Mail nvarchar(150) unique not null
) on FG1;
CREATE table ТОВАРЫ
(	ID_товара nvarchar(10) primary key,
	Наименование_товара nvarchar(100) not null,
	Цена real not null,
	Денежная_единица nvarchar(100) not null,
	Количество int not null
) on FG2;
CREATE table ЗАКАЗЫ
(	ID_заказа nvarchar(10) primary key,
	Дата_продажи date not null,
	id_товара nvarchar(10) foreign key references ТОВАРЫ(ID_товара) not null,
	id_клиента nvarchar(10) foreign key references КЛИЕНТЫ(ID_клиента) not null,
	Количество int not null,
	Скидка nvarchar(3) not null
) on FG1;

/* удаление таблиц */
DROP TABLE dbo.ЗАКАЗЫ;
DROP TABLE dbo.ТОВАРЫ;
DROP TABLE dbo.КЛИЕНТЫ;

/*3) добавление столбца "Дата_поступления" */
ALTER table ТОВАРЫ ADD Дата_поступления date not null;

select *
from ТОВАРЫ

ALTER table ТОВАРЫ DROP column Дата_поступления;

/*4) добавление инф-и в таблицы */
use Shim_MyBASE
INSERT INTO КЛИЕНТЫ(ID_клиента, Имя, Фамилия, Отчество, Адрес, Телефон, Mail)
	values('1', 'Михаил', 'Зинин', 'Николаевич', 'г. Москва, Косиора ул., д. 79', '6(452)549-62-13', 'mixa@mail.ru'),
		('3', 'Гавриил', 'Белоусов', 'Дмитриевич', 'г. Балашиха, Косиора ул., д. 44', '6(452)899-99-88', 'dimril@mail.ru'),
		('2', 'Нил', 'Абрамов', 'Семенович', 'г. Москва, Косиора ул., д. 38', '6(452)077-45-01', 'abram@mail.ru');

INSERT INTO ТОВАРЫ(ID_товара, Наименование_товара, Цена, Денежная_единица, Количество)
				values('1', 'Блокнот "Капитоль"', 300, 'российский рубль', 99),
						('2', 'Ковер "Титан"', 555.102 , 'евро', 603);

INSERT INTO ЗАКАЗЫ(ID_заказа, Дата_продажи, id_товара, id_клиента, Количество, Скидка)
				values('1', '2012-05-01', '2', '2', 13, 'да'),
						('2', '2012-01-03', '2', '2', 25, 'да'),
						('3', '2012-12-12', '1', '2', 300, 'нет'),
						('4', '2014-10-11', '1', '3', 16, 'нет');

/* 5) выборка */
SELECT * FROM КЛИЕНТЫ;

SELECT ID_товара, Наименование_товара FROM ТОВАРЫ;

SELECT count(*) as [Кол-во строк'] FROM КЛИЕНТЫ;

SELECT DISTINCT * FROM ЗАКАЗЫ
WHERE Дата_продажи > '2021-01-01';

SELECT TOP(2) ID_клиента, Фамилия, Телефон FROM КЛИЕНТЫ
order by ID_клиента desc;

select *
from ЗАКАЗЫ

/*6) изменения инф-х строк */
UPDATE ЗАКАЗЫ set Количество = 505 Where ID_заказа = '1';
UPDATE ЗАКАЗЫ set Количество = 223 Where ID_заказа = '2';

SELECT ID_заказа, Количество FROM ЗАКАЗЫ;

/*7) поиск инф-и с предикатами */
SELECT Фамилия, Адрес FROM КЛИЕНТЫ WHERE Фамилия LIKE '%ов';

SELECT ID_товара, Наименование_товара, Цена, Количество
FROM ТОВАРЫ 
WHERE Количество IN (99,600, 44);

SELECT * FROM ТОВАРЫ
WHERE Цена BETWEEN 500 AND 1000 /*OR Количество > 500;*/