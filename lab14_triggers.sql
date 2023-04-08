-- задание 1
create table TR_AUDIT
(
	ID int identity,	 -- номер
	STMT nvarchar(20) check (STMT in ('INS', 'DEL', 'UPD')), -- DML-оператор
	TRNAME nvarchar(50), -- имя триггера
	CC nvarchar(300)	 -- комментарий
);
go

create trigger tr_teacher_ins on TEACHER after insert 
as
	declare @tch nchar(10) = (select TEACHER from inserted);
	declare @tch_name nvarchar(100) = (select TEACHER_NAME from inserted);
	declare @gender nchar(1) = (select GENDER from inserted);
	declare @pul nchar(20) = (select PULPIT from inserted);

	declare @cc nvarchar(200) = cast(rtrim(@tch) as nvarchar(10)) + '; ' + 
								@tch_name + '; ' +
								cast(@gender as nvarchar(1)) + '; ' +
								cast(@pul as nvarchar(20));

	insert into TR_AUDIT (STMT, TRNAME, CC) values ('INS', 'tr_teacher_ins', @cc);
	return;
go

begin tran;
	insert into TEACHER values ('КВС', 'Кантарович', 'ж', 'ИСиТ');
	select * from TR_AUDIT;
rollback tran;
go


-- задание 2
create trigger tr_teacher_del on TEACHER  after delete 
as
	declare @tch nchar(10) = (select TEACHER from deleted);
	declare @tch_name nvarchar(100) = (select TEACHER_NAME from deleted);
	declare @gender nchar(1) = (select GENDER from deleted);
	declare @pul nchar(20) = (select PULPIT from deleted);
	declare @cc nvarchar(200) = cast(rtrim(@tch) as nvarchar(10)) + '; ' + 
								@tch_name + '; ' +
								cast(@gender as nvarchar(1)) + '; ' +
								cast(@pul as nvarchar(20));
	insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'tr_teacher_del', @cc);
	return;
go

begin tran;
	insert into TEACHER values ('КВС', 'Кантарович', 'ж', 'ИСиТ'); -- добавили чтобы удалить
	delete from TEACHER where TEACHER = 'КВС';
	select * from TR_AUDIT;
rollback tran;
go


-- задание 3
create trigger tr_teacher_upd on TEACHER  after update as
	declare @tch nchar(10) = (select TEACHER from inserted);
	declare @tch_name nvarchar(100) = (select TEACHER_NAME from inserted);
	declare @gender nchar(1) = (select GENDER from inserted);
	declare @pul nchar(20) = (select PULPIT from inserted);
	declare @cc nvarchar(200) = cast(rtrim(@tch) as nvarchar(10)) + '; ' + 
								@tch_name + '; ' +
								cast(@gender as nvarchar(1)) + '; ' +
								cast(@pul as nvarchar(20));
	insert into TR_AUDIT (STMT, TRNAME, CC) values ('UPD', 'tr_teacher_upd', @cc);
	return;
go

begin tran;
	update TEACHER set TEACHER_NAME = 'ИмяУчителя' where TEACHER = 'АКНВЧ';
	select * from TR_AUDIT;
rollback tran;
go


-- задание 4
create trigger tr_teacher on TEACHER  after insert, update, delete as
	declare @ins int = (select count(*) from inserted);
	declare @del int = (select count(*) from deleted);

	declare @tch nchar(10) = (select TEACHER from inserted);
	declare @tch_name nvarchar(100);
	declare @gender nchar(1);
	declare @pul nchar(20);
	declare @cc nvarchar(200);

	if  @ins > 0 begin 
		set @tch = (select TEACHER from inserted);
		set @tch_name = (select TEACHER_NAME from inserted);
		set @gender = (select GENDER from inserted);
		set @pul = (select PULPIT from inserted);
		set @cc = cast(rtrim(@tch) as nvarchar(10)) + '; ' + 
									@tch_name + '; ' +
									cast(@gender as nvarchar(1)) + '; ' +
									cast(@pul as nvarchar(20));
		if @del = 0 begin
			insert into TR_AUDIT (STMT, TRNAME, CC) values ('INS', 'tr_teacher', @cc);
		end;
		else begin
			insert into TR_AUDIT (STMT, TRNAME, CC) values ('UPD', 'tr_teacher', @cc);
		end;
	end;
	else begin
		set @tch = (select TEACHER from deleted);
		set @tch_name = (select TEACHER_NAME from deleted);
		set @gender = (select GENDER from deleted);
		set @pul = (select PULPIT from deleted);
		set @cc = cast(rtrim(@tch) as nvarchar(10)) + '; ' + 
									@tch_name + '; ' +
									cast(@gender as nvarchar(1)) + '; ' +
									cast(@pul as nvarchar(20));
		insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'tr_teacher', @cc);
	end;
	return;
go

begin tran;
	insert into TEACHER values ('КВС', 'Кантарович', 'ж', 'ИСиТ');
	update TEACHER set TEACHER_NAME = 'ИмяУчителя' where TEACHER = 'КВС';
	delete from TEACHER where TEACHER = 'КВС';
	select * from TR_AUDIT;
rollback tran;
go


-- задание 5
-- ограничения целостности и after-триггер
begin tran;
	insert into TEACHER values ('КВС', 'Кантарович', 'ж', 'ИСиТ');
	insert into TEACHER values ('КВС', 'Кантарович', 'жжж', 'ИСиТ');
	select * from TR_AUDIT;
rollback tran;
go


-- задание 6 
-- изменение порядка
create trigger tr_teacher_del1 on TEACHER  after delete as
	print 'DEL 1';
	declare @tch nchar(10) = (select TEACHER from deleted);
	declare @cc nvarchar(200) = cast(rtrim(@tch) as nvarchar(10));
	insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'tr_teacher_del1', @cc);
	return;
go
create trigger tr_teacher_del2 on TEACHER  after delete as
	print 'DEL 2';
	declare @tch nchar(10) = (select TEACHER from deleted);
	declare @cc nvarchar(200) = cast(rtrim(@tch) as nvarchar(10));
	insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'tr_teacher_del2', @cc);
	return;
go
create trigger tr_teacher_del3 on TEACHER  after delete as
	print 'DEL 3';
	declare @tch nchar(10) = (select TEACHER from deleted);
	declare @cc nvarchar(200) = cast(rtrim(@tch) as nvarchar(10));
	insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'tr_teacher_del3', @cc);
	return;
go

begin tran;
	insert into TEACHER values ('КВС', 'Кантарович', 'ж', 'ИСиТ'); -- создали чтобы удалить
	delete from TEACHER where TEACHER = 'КВС';
	select * from TR_AUDIT;
rollback tran;
go

-- порядок выполнения триггеров
select t.name, e.type_desc 
         from sys.triggers  t join  sys.trigger_events e  
              on t.object_id = e.object_id  
         where OBJECT_NAME(t.parent_id) = 'TEACHER' and e.type_desc = 'DELETE';
	
-- изменение порядка выполнения триггеров
exec SP_SETTRIGGERORDER @triggername = 'tr_teacher_del3', 
	                    @order = 'First', @stmttype = 'DELETE';
exec SP_SETTRIGGERORDER @triggername = 'tr_teacher_del2', 
	                    @order = 'Last', @stmttype = 'DELETE';
go

-- удалить предыдущие триггеры
drop trigger tr_teacher_ins;
go
drop trigger tr_teacher_del;
go
drop trigger tr_teacher_upd;
go
drop trigger tr_teacher;
go
drop trigger tr_teacher_del1;
go
drop trigger tr_teacher_del2;
go
drop trigger tr_teacher_del3;
go


-- задание 7
-- after триггер является частью транзакции, которая его вызвала
create trigger tr_teacher_del4 on TEACHER  after delete as
	declare @tch nchar(10) = (select TEACHER from deleted);
	declare @cc nvarchar(200) = cast(rtrim(@tch) as nvarchar(10));

	insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'tr_teacher_del4', @cc);
	raiserror('error', 11, 1);
	rollback;
	return;
go

-- select не выполняется
begin tran;
	insert into TEACHER values ('КВС', 'Кантарович', 'ж', 'ИСиТ');
	delete from TEACHER where TEACHER = 'КВС';
	select * from TR_AUDIT;
commit tran;
go


-- задание 8
-- instead of для запрета на удаление строк
create trigger instead_faculty on FACULTY instead of delete 
	as raiserror(N'Пользователем Liz был наложен запрет', 10, 1);
return;

begin tran;
	insert into TEACHER values ('КВС', 'Кантарович', 'ж', 'ИСиТ');
	select * from TEACHER where TEACHER = 'КВС';
	delete from FACULTY;
rollback tran;

drop trigger tr_teacher_del4;
go
drop trigger instead_faculty;
go
drop table TR_AUDIT;
go


-- задание 9
-- ddl-триггер
create trigger ddl_trigger on database for CREATE_TABLE, DROP_TABLE as
	declare @t1 varchar(50), @t2 varchar(50), @t3 varchar(50);
	set @t1 = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]','varchar(50)');
	set @t2 = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','varchar(50)');
	set @t3 = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]','varchar(50)');
	print 'Тип события: ' + @t1;
	print 'Имя объекта: ' + @t2;
	print 'Тип объекта: ' + @t3;
	raiserror('Запрет',11,1);
	rollback;
	return;
go

begin tran;
	create table SOME_TABLE ( x int );
rollback tran;
go

drop trigger ddl_trigger on database;
go

-- задание 11
create table WEATHER
(
	city varchar(30),
	start_date datetime,
	end_date datetime,
	temperature float
);
go

-- триггер, к-й проверяет ввод и изменение данных
create trigger weather_trigger on WEATHER for insert, update as
	declare @city nvarchar(30) = (select top(1) city from inserted);
	declare @start_date datetime = (select top(1) start_date from inserted);
	declare @end_date datetime = (select top(1) end_date from inserted);

	if (exists 
		(select * from WEATHER where 
			((start_date >= @start_date and end_date <= @end_date)
			or (start_date <= @start_date and end_date >= @end_date))
			and city = @city
		except select * from inserted))
	begin
		raiserror('Данные на это время уже записаны!', 16, 1);
		rollback;
	end;
	return;
go

insert into WEATHER values
	('Минск', '20220318 15:23', '20220318 19:00', 23),
	('Могилев', '20220405 10:00', '20220101 13:00', 8),
	('Гродно', '20220422 00:00', '20220101 09:00', 16);
insert into WEATHER values ('Минск', '20220318 13:00', '20220318 20:00', 0);

select * from WEATHER;
delete from WEATHER;
go

drop trigger weather_trigger;
go
drop table WEATHER;
go