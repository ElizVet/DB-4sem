-- 1 ЗАДАНИЕ
-- объявление переменных
DECLARE @a char(5) = 'hello',
		@b varchar(3) = 'wow',
		@c datetime,
		@d time, -- не инициализирована
		@e int,
		@f smallint,
		@h tinyint,
		@q numeric(12,5);

set @c = '12.03.2002';
set @e = (select count(*) from AUDITORIUM_TYPE);

select @f = 5;
select @h = max(idgroup) from GROUPS;
select @q = count(*) from PULPIT;

-- вывод
select @e e, @f f, @h h, @q q;

print 'a= ' + cast(@a as varchar(10));
print 'b= ' + cast(@b as varchar(10));
print 'c= ' + cast(@c as varchar(10));
print 'd= ' + cast(@d as varchar(10)); -- не инициализирована

-- 2 ЗАДАНИЕ
DECLARE @capacity int = (select sum(AUDITORIUM.AUDITORIUM_CAPACITY) from AUDITORIUM), --общая вместимость аудиторий
		@count_aud int,					--количество аудиторий
		@avg_capacity numeric(8,3),		--средняя вместимость аудиторий
		@count_aud_tiny_capacity int,	--количество аудиторий, вместимость которых меньше средней
		@percent numeric(8,3)			--процент таких аудиторий

IF @capacity > 200
begin
	SELECT	@count_aud = count(*) from AUDITORIUM;
	SELECT	@avg_capacity = avg(AUDITORIUM.AUDITORIUM_CAPACITY) from AUDITORIUM;
	SET @count_aud_tiny_capacity = (SELECT	count(*) from AUDITORIUM where AUDITORIUM_CAPACITY < @avg_capacity);
	SELECT	@percent = @count_aud_tiny_capacity * 100 / @count_aud;

	SELECT	@count_aud [Кол-во аудиторий], 
			@avg_capacity [Средняя вместимость],
			@count_aud_tiny_capacity [Кол-во аудиторий с вместимостью ниже средней],
			@percent [Процент аудиторий с вместимостью ниже средней];
end
ELSE IF @count_aud < 200 print 'Общая вместимость ниже 200'
ELSE print 'Общая вместимость равна 200'

-- 3 ЗАДАНИЕ
-- глобальные переменные
select	@@ROWCOUNT		'число обработанных строк',
		@@VERSION		'версия SQL Server',
		@@SPID			'системный идентификатор процесса, назначенный сервером текущему подключению',
		@@ERROR			'код последней ошибки',
		@@SERVERNAME	'имя сервера',
		@@TRANCOUNT		'уровень вложенности транзакции',
		@@FETCH_STATUS	'проверка результата считывания строк результирующего набора',
		@@NESTLEVEL		'уровень вложенности текущей процедуры';

-- 4 ЗАДАНИЕ
DECLARE @t int = 1, @x float, @z float;
SET @x = TAN(@t * @t + 1)
IF (@t > @x)
SET @z = power(sin(@t), 2)
else IF (@t < @x) SET @z = 4*(@t + @x)
else set @z = 1 - exp(@x - 2);
print @z

-- преобразование полного ФИО студента в сокращенное
DECLARE @name varchar(30) = (select top 1 STUDENT.NAME from STUDENT)

SET @name = SUBSTRING(@name, 0, CHARINDEX(' ', @name)+1)
+SUBSTRING(@name, CHARINDEX(' ', @name)+1, 1) +'.'
+SUBSTRING(@name, CHARINDEX(' ', @name)+1, 1) +'.'
print @name

-- поиск студентов, у которых день рождения в следующем месяце, и определение их возраста
declare @month int = 6;
select NAME, 2014 - year(BDAY) [Возраст] from STUDENT
where month(BDAY) = @month

-- поиск дня недели, в который студенты некоторой группы сдавали экзамен по СУБД
select distinct datepart(weekday, PDATE) [День недели]
from PROGRESS 
where SUBJECT = 'ОАиП';

-- 5 ЗАДАНИЕ
declare @o int = (select count(*) from PROGRESS where NOTE < 4);
if @o = 0 begin
	print 'Нет отрицательных оценок'
end
else begin
	print 'Количество отрицательных оценок = ' + cast(@o as varchar)
end;

-- 6 ЗАДАНИЕ
select SUBJECT.SUBJECT_NAME, STUDENT.NAME,
	case
		when PROGRESS.NOTE = 6 then 'Шесть'
		when PROGRESS.NOTE = 7 then 'Семь'
		when PROGRESS.NOTE > 7 then 'Хорошая успеваемость'
		else 'Плохая успеваемость'
	end Оценка
	from STUDENT 
		inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		inner join SUBJECT on PROGRESS.SUBJECT = SUBJECT.SUBJECT
		inner join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
		inner join FACULTY on GROUPS.FACULTY = FACULTY.FACULTY
	where GROUPS.FACULTY = 'ИТ'
	order by PROGRESS.NOTE desc;

-- 7 ЗАДАНИЕ
CREATE TABLE #Sev_ex (ID int, STRING varchar(100), KKEY int);
DECLARE @i int = 0, @p int;
WHILE @i < 10
	begin
		INSERT #Sev_ex(ID, STRING, KKEY) values (@i, 'Hello World!', rand());
		print @i;
		SET @i = @i + 1;
	end;

-- 8 ЗАДАНИЕ
DECLARE @xx int = 5
print @xx + 1
RETURN
print @xx + 2

-- 9 ЗАДАНИЕ
create table #ST
(
	IDSTUD int check(IDSTUD > 0),
	SUBJ nchar(10),
	NOTE int
);
set nocount on;
declare @i int = 0;
while @i < 10
	begin
		insert into #ST (IDSTUD, SUBJ, NOTE) values (rand()*200, 'строка', rand()*100);
		set @i = @i + 1;
	end;
select * from #ST;
go

begin try
	update #ST set IDSTUD = -4;
end try
begin catch
	print error_number();
	print error_message();
	print error_line();
	print error_procedure();
	print error_severity();
	print error_state();
end catch;