-- 1 ЗАДАНИЕ
-- определить все индексы
exec sp_helpindex 'AUDITORIUM'
exec sp_helpindex 'AUDITORIUM_TYPE'
exec sp_helpindex 'FACULTY'
exec sp_helpindex 'GROUPS'
exec sp_helpindex 'PROFESSION'
exec sp_helpindex 'PROGRESS'
exec sp_helpindex 'PULPIT'
exec sp_helpindex 'STUDENT'
exec sp_helpindex 'SUBJECT'
exec sp_helpindex 'TEACHER'
exec sp_helpindex 'TIMETABLE'

-- создать временную локальную таблицу
create table #OK
(	TIND int,
	TFIELD varchar(1000)
);
SET nocount on; -- не выводить сообщения о вводе строк
DECLARE @i int = 0;
WHILE @i < 1000
begin
	INSERT #OK(TIND, TFIELD)
		values(floor(20000*RAND()), REPLICATE('Remember: The Devil aint a friend to no one',10));
	IF(@i % 100 = 0) print @i; -- вывести сообщение
	SET @i = @i + 1;
end;

-- получить план запроса и определить его стоимость
select * from #OK where TIND between 1500 and 2500 order by TIND

checkpoint; -- фиксация БД
DBCC DROPCLEANBUFFERS; -- очистить буферный кэш

-- создать кластер-й индекс, уменьшающий стоимость SELECT-запроса
CREATE clustered index #OK_CL on #OK(TIND asc)

-- 2 ЗАДАНИЕ
-- создать временную локальную таблицу
create table #OK2
(	TKEY int,
	CC int identity(1,1),
	TF varchar(1000)
);
SET nocount on; -- не выводить сообщения о вводе строк
DECLARE @q int = 0;
WHILE @q < 20000
begin
	INSERT #OK2(TKEY, TF)
		values(floor(30000*RAND()), REPLICATE('But FUN, true',10));
	IF(@q % 5000 = 0) print @q; -- вывести сообщение
	SET @q = @q + 1;
end;

-- получить план запроса и определить его стоимость
SELECT count(*) [кол-во строк] from #OK2

-- Создать некластеризованный НЕУНИКАЛЬНЫЙ составной индекс
CREATE index #OK2_NONCLU on #OK2(TKEY, CC)

SELECT * from #OK2 where TKEY between 1500 and 4500 -- не используется
SELECT * from #OK2 order by TKEY, CC -- не используется

SELECT * from #OK2 where TKEY = 556 and CC > 3

-- 3 ЗАДАНИЕ
-- создать временную локальную таблицу
create table #OK3
(	TKEY int,
	CC int identity(1,1),
	TF varchar(1000)
);
SET nocount on; -- не выводить сообщения о вводе строк
DECLARE @z int = 0;
WHILE @z < 10000
begin
	INSERT #OK3(TKEY, TF)
		values(floor(30000*RAND()), REPLICATE('You could let it all go, you could let it all go',10));
	IF(@z % 1000 = 0) print @z; -- вывести сообщение
	SET @z = @z + 1;
end;

-- запрос
SELECT CC from #OK3 where TKEY > 3000

-- создать некластеризованный индекс покрытия, уменьшающий стоимость SELECT-запроса
CREATE index #OK3_TKEY_X on #OK3(TKEY) INCLUDE (CC)

-- 4 ЗАДАНИЕ
-- создать временную локальную таблицу
create table #OK4
(	TKEY int,
	CC int identity(1,1),
	TF varchar(1000)
);
SET nocount on; -- не выводить сообщения о вводе строк
DECLARE @w int = 0;
WHILE @w < 10000
begin
	INSERT #OK4(TKEY, TF)
		values(floor(30000*RAND()), REPLICATE('Its Called: Freefall',10));
	IF(@w % 1000 = 0) print @w; -- вывести сообщение
	SET @w = @w + 1;
end;

-- запрос
SELECT TKEY from #OK4 where TKEY between 5000 and 9999
SELECT TKEY from #OK4 where TKEY = 7902

-- создать некластеризованный фильтруемый индекс, уменьшающий стоимость SELECT-запроса
CREATE index #OK4_WHERE on #OK4(TKEY) where (TKEY >= 5000 and TKEY < 9999);

-- 5 ЗАДАНИЕ
-- создать временную локальную таблицу
create table #OK5
(	TKEY int,
	CC int identity(1,1),
	TF varchar(1000)
);
SET nocount on; -- не выводить сообщения о вводе строк
DECLARE @у int = 0;
WHILE @у < 20000
begin
	INSERT #OK5(TKEY, TF)
		values(floor(30000*RAND()), REPLICATE('Its Called: Freefall',10));
	IF(@у % 1000 = 0) print @у; -- вывести сообщение
	SET @у = @у + 1;
end;

-- создать некластер-й индекс
CREATE index #OK5_TKEY on #OK5(TKEY)

-- получить инф-ю о степени фрагментации индекса
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),
OBJECT_ID(N'#OK5'), NULL, NULL, NULL) ss
JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id
WHERE name is not null;

-- вставим 20000 строк: (использовать несколько раз)
INSERT top(20000) #OK5(TKEY, TF) select TKEY, TF from #OK5
-- (еще раз получить инф-ю о фрагментации)

-- выполнить процедуру реорганизации
ALTER index #OK5_TKEY on #OK5 reorganize;

-- выполнить процедуру перестройки
ALTER index #OK5_TKEY on #OK5 rebuild with (online = off);

-- 6 ЗАДАНИЕ (fillfactor)
DROP index #OK5_TKEY on #OK5
CREATE index #OK5_TKEY on #OK5(TKEY)
					with (fillfactor = 65);
-- вставим строки: (использовать несколько раз)
INSERT top(50)percent INTO #OK5(TKEY, TF) select TKEY, TF from #OK5

drop table #OK;
drop table #OK2;
drop table #OK3;
drop table #OK4;
drop table #OK5;