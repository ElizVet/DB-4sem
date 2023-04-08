-- задание 1
-- количество студентов на факультете, код которого задается параметром типа VARCHAR(20) с именем @faculty.
create function count_students (@faculty nvarchar(20)) 
	returns int as
	begin
		declare @result int = 
			(select count(IDSTUDENT) from STUDENT
				join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
				join FACULTY on FACULTY.FACULTY = GROUPS.FACULTY
				where FACULTY.FACULTY = @faculty);
		return @result;
	end;
go

declare @c int = dbo.count_students('ИТ');
print cast(@c as nvarchar(3));
go

-- ALTER с тем, чтобы функция принимала второй параметр 
-- @prof типа VARCHAR(20), обозначающий специальность студентов
alter function count_students 
	(@faculty nvarchar(20) = null, @prof nvarchar(20) = null)
	returns int as
	begin
		declare @result int = 
			(select count(IDSTUDENT) from STUDENT
				join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
				join FACULTY on FACULTY.FACULTY = GROUPS.FACULTY
				where FACULTY.FACULTY = @faculty and GROUPS.PROFESSION = @prof);
		return @result;
	end;
go

select dbo.count_students ('ИТ', '1-40 01 02');
go


-- задание 2
-- скалярную функцию с именем FSUBJECTS, принимающую 
-- параметр @p типа VARCHAR(20), значение которого задает код кафедры 
create function fsubjects (@pulpit nvarchar(20)) 
	returns nvarchar(300) as
	begin
		declare @result nvarchar(300) = 'Дисциплины: ';
		declare subjects_cursor cursor local static for
			select SUBJECT from SUBJECT where PULPIT = @pulpit;
		open subjects_cursor;
			declare @subj nvarchar(20);
			fetch subjects_cursor into @subj;
			while @@fetch_status = 0
				begin
					set @result = @result + rtrim(@subj) + ', ';
					fetch subjects_cursor into @subj;
				end;
		close subjects_cursor;
		deallocate subjects_cursor;
		return left(@result, len(@result) - 1);
	end;
go

select PULPIT, dbo.fsubjects(PULPIT) from PULPIT;
go


-- задание 3
-- табличную функцию FFACPUL
create function ffacpul (@fac char(10) = null, @pul char(20) = null)
returns @tabl table (faculty char(10), pulpit char(20)) as
begin
	if @fac is null and @pul is null
	begin
		insert into @tabl select FACULTY.FACULTY, PULPIT.PULPIT from FACULTY 
			left outer join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY;
	end;
	else if @fac is not null and @pul is null
	begin
		insert into @tabl select FACULTY.FACULTY, PULPIT.PULPIT from FACULTY 
			left outer join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY
			where PULPIT.FACULTY = @fac;
	end;
	else if @fac is null and @pul is not null
	begin
		insert into @tabl select FACULTY.FACULTY, PULPIT.PULPIT from FACULTY 
			left outer join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY
			where PULPIT = @pul;
	end;
	else
	begin
		insert into @tabl select FACULTY.FACULTY, PULPIT.PULPIT from FACULTY 
			left outer join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY
			where PULPIT = @pul and PULPIT.FACULTY = @fac;
	end;
	return;
end;
go

select * from ffacpul(null, null);
select * from ffacpul('ИТ', null);
select * from ffacpul(null, 'ИСиТ');
select * from ffacpul('ИТ', 'ИСиТ');
go


-- задание 4
-- скалярной функции FCTEACHER
create function fteacher (@pul char(20)) returns int as
begin
	return (select count(*) from TEACHER where PULPIT = isnull(@pul, PULPIT)); 
end;
go

select dbo.fteacher('ИСиТ');
go


-- задание 6
-- количество кафедр, количество групп, количество студентов и 
-- количество специальностей вычислялось отдельными скалярными функциями
create function StudentCount(@faculty varchar(50)) returns int
as
begin
	 declare @studentCount int  = 0
	 set @studentCount = 
		(select count(*)
		from STUDENT inner join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
					 inner join FACULTY on GROUPS.FACULTY = FACULTY.FACULTY
		where FACULTY.FACULTY = @faculty)
	return @studentCount
end
go

go
create function PulpitCount(@faculty varchar(50)) returns int
as
begin
	 declare @pulpitCount int = 0
	 set @pulpitCount = 
		(select count(*)
		from PULPIT
		where PULPIT.FACULTY = @faculty)
	return @pulpitCount
end
go

create function ProfessionCount(@faculty varchar(50)) returns int
as
begin
	 declare @professionCount int = 0
	 set @professionCount = 
		(select count(*)
		from PROFESSION
		where PROFESSION.FACULTY = @faculty)
	return @professionCount
end
go

create function GroupCount(@faculty varchar(50)) returns int
as
begin
	 declare @groupCount int = 0
	 set @groupCount = 
		(select count(*)
		from GROUPS
		where GROUPS.FACULTY = @faculty)
	return @groupCount
end
go

create function FacultyReport(@studentCount int) 
returns @result table 
(
	faculty varchar(50),
	pulpitCount int, 
	groupCount int, 
	professionCount int
)
as
begin
	declare FacultyCursor cursor local for
		select FACULTY from FACULTY where dbo.StudentCount(FACULTY) > @studentCount
	declare @faculty varchar(50)
	open FacultyCursor
		fetch FacultyCursor into @faculty
		while @@FETCH_STATUS = 0
		begin
			insert into @result values
				(@faculty, dbo.PulpitCount(@faculty), dbo.GroupCount(@faculty), dbo.ProfessionCount(@faculty))
			fetch FacultyCursor into @faculty
		end
	close FacultyCursor
	return
end
go

select * from dbo.FacultyReport(20)
go

drop function StudentCount;
go
drop function PulpitCount;
go
drop function ProfessionCount;
go
drop function GroupCount;
go
drop function FacultyReport;
go


-- задание 7
-- SELECT-запрос курсора в новой 
-- процедуре должен использовать функции FSUBJECTS, FFACPUL и FCTEACHER
create procedure print_reportx
	@f nvarchar(10) = null,
	@p nvarchar(10) = null
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
						--select @teach_num = count(*) from TEACHER where PULPIT = @pul;
						print '        Количество преподавателей: ' + cast(dbo.fteacher(@pul) as nvarchar(max));
						-- Предметы
						set @subj_str = '        Дисциплины: ';
						select @subj_num = count(*) from SUBJECT where PULPIT = @pul;
						if (@subj_num = 0) begin
							set @subj_str += 'нет.'
						end;
						else begin
							set @subj_str = dbo.fsubjects(@pul);
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
				print '        Количество преподавателей: ' + cast(dbo.fteacher(@pul) as nvarchar(max));
				-- Предметы
				set @subj_str = '        Дисциплины: ';
				select @subj_num = count(*) from SUBJECT where PULPIT = @pul;
				if (@subj_num = 0) begin
					set @subj_str += 'нет.'
				end;
				else begin
					set @subj_str = dbo.fsubjects(@pul);
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
		set @faculty = cast((select top(1) FACULTY from PULPIT where PULPIT = @p) as nvarchar(10));
		if (@faculty is null)
		begin
			raiserror('Ошибка в параметрах', 11, 1);
		end;
		print 'Факультет: ' + @f;
		declare PulpitCur cursor local static for select PULPIT from PULPIT where FACULTY = @faculty;
		open PulpitCur;
			fetch PulpitCur into @pul;
			while @@FETCH_STATUS = 0 begin
				set @pul_count = @pul_count + 1;
				print '    Кафедра: ' + rtrim(@pul);
				-- Преподаватели
				select @teach_num = count(*) from TEACHER where PULPIT = @pul;
				print '        Количество преподавателей: ' + cast(dbo.fteacher(@pul) as nvarchar(max));
				-- Предметы
				set @subj_str = '        Дисциплины: ';
				select @subj_num = count(*) from SUBJECT where PULPIT = @pul;
				if (@subj_num = 0) begin
					set @subj_str += 'нет.'
				end;
				else begin
					set @subj_str = dbo.fsubjects(@pul);
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
		print '        Количество преподавателей: ' + cast(dbo.fteacher(@pul) as nvarchar(max));
		-- Предметы
		set @subj_str = '        Дисциплины: ';
		select @subj_num = count(*) from SUBJECT where PULPIT = @p;
		if (@subj_num = 0) begin
			set @subj_str += 'нет.'
		end;
		else begin
			set @subj_str = dbo.fsubjects(@p);
		end;
		print @subj_str;
		return @pul_count;
	end;
end;
go

declare @res int;
exec @res = print_reportx;
print '===================================== ' + cast(@res as nvarchar(max));
go

declare @res int;
exec @res = print_reportx @f = 'ИЭФ';
print '===================================== ' + cast(@res as nvarchar(max));
go

declare @res int;
exec @res = print_reportx @p = 'ИСиТ';
print '===================================== ' + cast(@res as nvarchar(max));
go

declare @res int;
exec @res = print_reportx @f = 'ИТ', @p = 'ИСиТ';
print '===================================== ' + cast(@res as nvarchar(max));
go





drop function count_students;
go
drop function fsubjects;
go
drop function ffacpul;
go
drop function fteacher;
go
drop procedure print_reportx;
go