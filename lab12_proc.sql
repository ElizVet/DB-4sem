-- задание 1
-- хранимую процедуру без параметров с именем PSUB-JECT
-- Процедура формирует результирующий набор на ос-нове таблицы SUBJECT
create procedure psubject as
begin
	select * from SUBJECT;
	declare @c int = (select count(*) from SUBJECT);
	return @c;
end;
go
declare @r int;
exec @r = psubject;
print cast(@r as nvarchar(3));
go

-- задание 2
-- Найти процедуру PSUBJECT, сгенерировать код изменения.
-- она принимала два параметра с именами @p и @c. 
-- Параметр @p является входным, имеет тип VAR-CHAR(20) и значение 
-- по умолчанию NULL. 
-- Параметр @с является выходным, имеет тип INT.

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[psubject] @p nvarchar(20) = null, @c int output 
as
begin
	select * from SUBJECT where SUBJECT = @p;
	set @c = @@ROWCOUNT;
	declare @k int = (select count(*) from SUBJECT); 
	return @k;
end;
go

declare @count int, @result int;
exec @result = psubject 'БД', @c = @count output;
print @result;
print @count;
go

-- задание 3
-- не содержала выходного параметра
ALTER procedure [dbo].[psubject] @p nvarchar(20) = null as
begin
	select * from SUBJECT where SUBJECT = @p;
	select * from SUBJECT where SUBJECT = 'ООП';
end;
go

create table #SUBJECT
(
	SUBJECT nchar(10) primary key not null,
	SUBJECT_NAME nvarchar(100),
	PULPIT nchar(20)
);
go

insert into #SUBJECT exec psubject 'БД';
go

select * from #SUBJECT;
go

drop table #SUBJECT;
drop procedure psubject;
go

-- задание 4
-- четыре входных параметра
-- применять механизм TRY/CATCH для обработки ошибок.
create procedure pauditorium_insert
	@au nchar(20),
	@name nvarchar(50),
	@cap int = 0,
	@type nchar(10)
as
begin
	begin try
		insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE)
			values (@au, @name, @cap, @type);
		return 1;
	end try
	begin catch
		print 'номер ошибки: ' + cast(error_number() as varchar(6));
		print 'сообщение: ' + error_message();
		print 'уровень серьёзности: ' + cast(error_severity() as varchar(6));
		print 'имя процедуры: ' + error_procedure();
		return -1;
	end catch;
end;
go
begin tran;
	exec pauditorium_insert '333-3', '888-8', 77, 'ЛК';
	exec pauditorium_insert '333-3', '888-8', 77, 'ЛЛЛЛЛЛ';
	select * from AUDITORIUM where AUDITORIUM = '333-3';
rollback tran;
go

drop procedure pauditorium_insert;
go

-- задание 5
-- отчет со списком дисциплин на конкретной кафедре
create procedure subject_report @p char(20) as
begin
	if (@p not in (select PULPIT from PULPIT))
		begin
			raiserror('Ошибка в параметрах', 11, 1);
			return 0;
		end;
	declare @pulpitName nvarchar(50) = @p;
	declare @i int = 0;
	declare @subjectName nvarchar(15), @subjectLine nvarchar(150) = '', @subjectPulpit nvarchar(50);
	declare subjects cursor local static for
		SELECT SUBJECT.SUBJECT, SUBJECT.PULPIT from SUBJECT
		open subjects;
			fetch from subjects into @subjectName, @subjectPulpit;
			if (@subjectPulpit = @pulpitName)
				set @subjectLine = trim(@subjectName) + ', ' + @subjectLine;
			while @@FETCH_STATUS = 0
				begin
					fetch from subjects into @subjectName, @subjectPulpit;
					if (@subjectPulpit = @pulpitName)
					begin
						set @subjectline = trim(@subjectName) + ', ' + @subjectline;
						set @i = @i + 1;
					end
				end
		close subjects;
		if len(@subjectline) > 0
			set @subjectline = left(@subjectline, len(@subjectline)-1);
		else
			set @subjectline = 'нет';
		print char(9) + char(9) + 'Дисциплины: ' + @subjectline;
	return @i;
end;
go

declare @count int
exec @count = subject_report @p = 'ИСиТ';
print @count;
go
-- ошибка:
declare @count int;
exec @count = subject_report @p = 'qwerty';
go
drop procedure subject_report;
go

-- задание 7
create procedure pauditorium_insert_type
	@a_ char(20), 
	@n_ varchar(50), 
	@c_ int = 0, 
	@t_ char(10), 
	@tn_ varchar(50) 
as
begin
	declare @err nvarchar(50) = 'Ошибка: '
	declare @res int
	begin tran
		begin try
			insert into AUDITORIUM_TYPE values (@t_, @tn_)
			exec @res = pauditorium_insert @a_, @n_, @c_, @t_
				if (@res = -1)
					begin
						commit tran
						return -1
					end
				commit tran
		end try
		begin catch
			set @err = @err + error_message()
			return -1
		end catch
	return 1
end
go
-- НЕ ставить уровень изоляции в процедуры!
set transaction isolation level serializable
begin tran
	declare @result int
	exec @result = pauditorium_insert_type '208-1', '208-1', 15, 'AU2', 'AUDITORIUM TYPE 2' 
	print @result
	if @result = 1
		begin
			select * from AUDITORIUM
			select * from AUDITORIUM_TYPE
		end
rollback tran
go
drop procedure pauditorium_insert_type;
go

-- задание 8
create procedure print_report
	@f nchar(10) = null,
	@p nchar(10) = null
as
begin
	declare @faculty char(10);
	declare @pul char(20);
	declare @teach_num int = 0;
	declare @subj char(10);
	declare @subj_str nvarchar(max);
	declare @subj_num int;
	declare @pul_count int = 0;
	if (@f is null) and (@p is null)
	begin
		-- Факультеты
		declare FacultyCur cursor local static for select FACULTY from FACULTY;
		open FacultyCur;
			fetch FacultyCur into @faculty;
			while @@FETCH_STATUS = 0 begin
				print 'Факультет: ' + rtrim(@faculty);
				-- Кафедры
				declare PulpitCur cursor local static for select PULPIT from PULPIT where FACULTY = @faculty;
				open PulpitCur;
					fetch PulpitCur into @pul;
					while @@FETCH_STATUS = 0 begin
						set @pul_count = @pul_count + 1;
						print '    Кафедра: ' + rtrim(@pul);
						-- Преподаватели
						select @teach_num = count(*) from TEACHER where PULPIT = @pul;
						print '        Количество преподавателей: ' + cast(@teach_num as nvarchar(max));
						-- Предметы
						set @subj_str = '        Дисциплины: ';
						select @subj_num = count(*) from SUBJECT where PULPIT = @pul;
						if (@subj_num = 0) begin
							set @subj_str += 'нет.'
						end;
						else begin
							declare SubjCur cursor local static for select SUBJECT from SUBJECT where PULPIT = @pul;
							open SubjCur;
							fetch SubjCur into @subj;
								while @@FETCH_STATUS = 0 begin
									set @subj_str += rtrim(@subj) + ', ';
									fetch SubjCur into @subj;
								end;
							close SubjCur;
							deallocate SubjCur;
						end;
						print @subj_str;
						fetch PulpitCur into @pul;
					end;
				close PulpitCur;
				deallocate PulpitCur;
				fetch FacultyCur into @faculty;
			end;
		close FacultyCur;
		deallocate FacultyCur;
		return @pul_count;
	end;
	else if (@f is not null) and (@p is null)
	begin
		-- Для заданного факультета
		print 'Факультет: ' + rtrim(@f);
		declare PulpitCur cursor local static for select PULPIT from PULPIT where FACULTY = @f;
		open PulpitCur;
			fetch PulpitCur into @pul;
			while @@FETCH_STATUS = 0 begin
				set @pul_count = @pul_count + 1;
				print '    Кафедра: ' + rtrim(@pul);
				-- Преподаватели
				select @teach_num = count(*) from TEACHER where PULPIT = @pul;
				print '        Количество преподавателей: ' + cast(@teach_num as nvarchar(max));
				-- Предметы
				set @subj_str = '        Дисциплины: ';
				select @subj_num = count(*) from SUBJECT where PULPIT = @pul;
				if (@subj_num = 0) begin
					set @subj_str += 'нет.'
				end;
				else begin
					declare SubjCur cursor local static for select SUBJECT from SUBJECT where PULPIT = @pul;
					open SubjCur;
					fetch SubjCur into @subj;
						while @@FETCH_STATUS = 0 begin
							set @subj_str += rtrim(@subj) + ', ';
							fetch SubjCur into @subj;
						end;
					close SubjCur;
					deallocate SubjCur;
				end;
				print @subj_str;
				fetch PulpitCur into @pul;
			end;
		close PulpitCur;
		deallocate PulpitCur;
		return @pul_count;
	end;
	else if (@f is null) and (@p is not null)
	begin
		-- для заданной кафедры
		set @faculty = (select top(1) FACULTY from PULPIT where PULPIT = @p);
		if (@faculty is null)
		begin
			raiserror('Ошибка в параметрах', 11, 1);
		end;
				print 'Факультет: ' + rtrim(@f);
		declare PulpitCur cursor local static for select PULPIT from PULPIT where FACULTY = @faculty;
		open PulpitCur;
			fetch PulpitCur into @pul;
			while @@FETCH_STATUS = 0 begin
				set @pul_count = @pul_count + 1;
				print '    Кафедра: ' + rtrim(@pul);
				-- Преподаватели
				select @teach_num = count(*) from TEACHER where PULPIT = @pul;
				print '        Количество преподавателей: ' + cast(@teach_num as nvarchar(max));
				-- Предметы
				set @subj_str = '        Дисциплины: ';
				select @subj_num = count(*) from SUBJECT where PULPIT = @pul;
				if (@subj_num = 0) begin
					set @subj_str += 'нет.'
				end;
				else begin
					declare SubjCur cursor local static for select SUBJECT from SUBJECT where PULPIT = @pul;
					open SubjCur;
					fetch SubjCur into @subj;
						while @@FETCH_STATUS = 0 begin
							set @subj_str += rtrim(@subj) + ', ';
							fetch SubjCur into @subj;
						end;
					close SubjCur;
					deallocate SubjCur;
				end;
				print @subj_str;
				fetch PulpitCur into @pul;
			end;
		close PulpitCur;
		deallocate PulpitCur;
		return @pul_count;
	end;
	else
	begin
	-- Для конкретной кафедры конкретного факультета
		print 'Факультет: ' + rtrim(@f);
		set @pul_count = @pul_count + 1;
		print '    Кафедра: ' + rtrim(@p);
		-- Преподаватели
		select @teach_num = count(*) from TEACHER where PULPIT = @p;
		print '        Количество преподавателей: ' + cast(@teach_num as nvarchar(max));
		-- Предметы
		set @subj_str = '        Дисциплины: ';
		select @subj_num = count(*) from SUBJECT where PULPIT = @p;
		if (@subj_num = 0) begin
			set @subj_str += 'нет.'
		end;
		else begin
			declare SubjCur cursor local static for select SUBJECT from SUBJECT where PULPIT = @p;
			open SubjCur;
			fetch SubjCur into @subj;
				while @@FETCH_STATUS = 0 begin
					set @subj_str += rtrim(@subj) + ', ';
					fetch SubjCur into @subj;
				end;
			close SubjCur;
			deallocate SubjCur;
		end;
		print @subj_str;
		return @pul_count;
	end;
end;
go

declare @res int;
exec @res = print_report;
print '===================================== ' + cast(@res as nvarchar(max));
go

declare @res int;
exec @res = print_report @f = 'ИЭФ';
print '===================================== ' + cast(@res as nvarchar(max));
go

declare @res int;
exec @res = print_report @p = 'ИСиТ';
print '===================================== ' + cast(@res as nvarchar(max));
go

declare @res int;
exec @res = print_report @f = 'ИТ', @p = 'ИСиТ';
print '===================================== ' + cast(@res as nvarchar(max));
go

drop procedure print_report;
go