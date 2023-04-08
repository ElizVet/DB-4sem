-- 1 ЗАДАНИЕ
-- сформировать список дисциплин на кафедре ИСИТ
DECLARE Subj CURSOR for SELECT SUBJECT.SUBJECT from SUBJECT where SUBJECT.PULPIT = 'ИСиТ'; -- объявление курсора
DECLARE @sb char(20), @s char(300) = '';
	OPEN Subj; -- открыли курсор
	FETCH Subj into @sb; -- положили в sb строку соотв-ю запросу
	print 'Дисциплины на кафедре';
	while @@FETCH_STATUS = 0 -- феч_статус проверяет феч на успешность: нуль - если успешно
		begin
			set @s = rtrim(@sb) + ', ' + @s; -- в s записываем значения строк из таблицы через запятую
			FETCH Subj into @sb; -- задаем sb брать след-ю строку
		end;
	print @s; -- выводим результат
CLOSE Subj; -- курсор закрывается

-- 2 ЗАДАНИЕ
-- отличие глобального и локального курсоров
DECLARE Aud CURSOR LOCAL for SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_CAPACITY from AUDITORIUM;
DECLARE @aud char(20), @cap int;
	OPEN Aud;
	FETCH Aud into @aud, @cap;
	print '1.' + @aud + cast(@cap as varchar(10));
	go
DECLARE @aud char(20), @cap int;
	FETCH Aud into @aud, @cap;
	print '2.' + @aud + cast(@cap as varchar(10));
	go


DECLARE Audit CURSOR GLOBAL for SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_CAPACITY from AUDITORIUM;
DECLARE @aud char(20), @cap int;
	OPEN Audit;
	FETCH Audit into @aud, @cap;
	print '1.' + @aud + cast(@cap as varchar(10));
	go
DECLARE @aud char(20), @cap int;
	FETCH Audit into @aud, @cap;
	print '2.' + @aud + cast(@cap as varchar(10));
	close Audit;
	deallocate Audit;
	go

-- 3 ЗАДАНИЕ
-- отличие статических и динамических курсоров
DECLARE AuditoriumType CURSOR local static -- здесь мы ложим таблицу в курсор
	for SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPE, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME from AUDITORIUM_TYPE;
DECLARE @aud_type char(20), @aud_name varchar(50);
OPEN AuditoriumType;
	print 'Кол-во строк: ' + cast(@@CURSOR_ROWS as varchar(5));
	delete AUDITORIUM_TYPE where AUDITORIUM_TYPE = 'СК';				-- здесь вы изменяем таблицу, но не курсор
	--insert AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
	--		values('СК', 'Секретная комната')
	fetch AuditoriumType into @aud_type, @aud_name;						
	while @@FETCH_STATUS = 0											-- здесь мы выводим неизмененный курсор
		begin
			print @aud_type + ' ' + @aud_name;
			fetch AuditoriumType into @aud_type, @aud_name;
		end;
close AuditoriumType;

DECLARE AuditoriumType2 CURSOR local dynamic for SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPE, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME from AUDITORIUM_TYPE;
DECLARE @aud_type2 char(20), @aud_name2 varchar(50);
OPEN AuditoriumType2;
	print 'Кол-во строк: ' + cast(@@CURSOR_ROWS as varchar(5));
	--delete AUDITORIUM_TYPE where AUDITORIUM_TYPE = 'СК';
	insert AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
			values('СК', 'Секретная комната')
	fetch AuditoriumType2 into @aud_type2, @aud_name2;				-- выводится измененный курсор
	while @@FETCH_STATUS = 0
		begin
			print @aud_type2 + ' ' + @aud_name2;
			fetch AuditoriumType2 into @aud_type2, @aud_name2;
		end;
close AuditoriumType2;

-- 4 ЗАДАНИЕ
-- SCROLL + ключевые слова в FETCH
DECLARE @sb char(50);
DECLARE ZkSubj CURSOR LOCAL SCROLL for SELECT SUBJECT.SUBJECT_NAME from SUBJECT; 
	OPEN ZkSubj; 
	FETCH FIRST from ZkSubj into @sb; 
	print 'first: ' + @sb;
	FETCH NEXT from ZkSubj into @sb; 
	print 'next: ' + @sb;
	FETCH PRIOR from ZkSubj into @sb;
	print 'prior: ' + @sb;
	FETCH ABSOLUTE -3 from ZkSubj into @sb; 
	print 'absolute -3: ' + @sb;
	FETCH ABSOLUTE 3 from ZkSubj into @sb; 
	print 'absolute 3: ' + @sb;
	FETCH RELATIVE 5 from ZkSubj into @sb; 
	print 'relative 5: ' + @sb;
	FETCH RELATIVE -5 from ZkSubj into @sb; 
	print 'relative -5: ' + @sb;
CLOSE ZkSubj; -- курсор закрывается

-- 5 ЗАДАНИЕ
-- FOR UPDATE + CURRENT OF
DECLARE @fa_name char(50);
DECLARE Facul CURSOR LOCAL SCROLL for SELECT FACULTY.FACULTY_NAME from FACULTY FOR UPDATE;
OPEN Facul;

	fetch LAST from Facul into @fa_name;
	print @fa_name;
	UPDATE FACULTY set FACULTY_NAME = 'Химическаятехнологияитехника' where CURRENT OF Facul;
	--UPDATE FACULTY set FACULTY_NAME = 'Химическая технология и техника' where CURRENT OF Facul;

	fetch ABSOLUTE -2 from Facul into @fa_name;
	print @fa_name;
	--DELETE SUBJECT where CURRENT OF Facul;

close Facul;

-- 6 ЗАДАНИЕ

-- удаление всех строк, где оценка < 4
declare FF CURSOR LOCAL DYNAMIC
FOR SELECT pr.NOTE, st.NAME, gr.IDGROUP
FROM PROGRESS pr join STUDENT st on pr.IDSTUDENT = st.IDSTUDENT
				join GROUPS gr on gr.IDGROUP = st.IDGROUP
WHERE pr.NOTE < 4 FOR UPDATE;

declare @note int, @st_name nvarchar(100), @id_gr int;

OPEN FF;
	fetch FF into @note, @st_name, @id_gr;
	while @@FETCH_STATUS = 0
	begin
		DELETE PROGRESS where CURRENT OF FF;
		fetch FF into @note, @st_name, @id_gr;
	end;
close FF;


-- оценка + 1
declare NN CURSOR LOCAL DYNAMIC
FOR SELECT pr.NOTE, st.NAME
FROM PROGRESS pr join STUDENT st on pr.IDSTUDENT = st.IDSTUDENT
WHERE st.IDSTUDENT = 1016 FOR UPDATE;

declare @note2 int, @st_name2 nvarchar(100);

OPEN NN;
	fetch NN into @note2, @st_name2;
	UPDATE PROGRESS set NOTE = NOTE + 1 where CURRENT OF NN;
close NN;

-- 8 ЗАДАНИЕ
declare F CURSOR LOCAL STATIC FOR SELECT f.FACULTY FROM FACULTY f;

declare @faculty char(10), @pulpit char(20), @subject char(10), @tea_count int = 0, @str char(300);

OPEN F;
	fetch from F into @faculty;
	WHILE @@FETCH_STATUS = 0
	begin
		print 'Факультет: ' + @faculty;

		declare P CURSOR LOCAL STATIC FOR SELECT p.PULPIT FROM PULPIT p WHERE p.FACULTY = @faculty;
		OPEN P;
			fetch from P into @pulpit;
			WHILE @@FETCH_STATUS = 0
			begin
				print '		Кафедра: ' + @pulpit;
				declare T CURSOR LOCAL STATIC FOR SELECT count(*) FROM TEACHER t WHERE t.PULPIT = @pulpit;
				OPEN T;
					print '			Кол-во преподавателей: ' + cast(@tea_count as char(5));
					fetch from T into @tea_count;
				CLOSE T;
				deallocate T;

				declare S CURSOR LOCAL STATIC FOR SELECT s.SUBJECT FROM SUBJECT s WHERE s.PULPIT = @pulpit;
				OPEN S;
					set @str = '';
					FETCH S into @subject;
					while @@FETCH_STATUS = 0
					begin
						set @str = rtrim(@subject) + ', ' + @str;
						FETCH S into @subject;
					end;
					 
					if(@str != '')
					begin
						set @str = substring(@str, 1, len(@str)-1) + '.';
					end;
					if(@str = '')
						set @str = 'нет.'
					print '			Дисциплины на кафедре: ' + @str;
				CLOSE S;
				deallocate S;

				fetch from P into @pulpit;
			end;
		CLOSE P;
		deallocate P;

		fetch from F into @faculty;
	end;
CLOSE F;
deallocate F;



------------------------------------
------------------------------------
--declare DF CURSOR LOCAL STATIC
--FOR SELECT f.FACULTY, p.PULPIT, s.SUBJECT, count(t.TEACHER)
--FROM FACULTY f left join PULPIT p on f.FACULTY = p.FACULTY
--			   left join TEACHER t on t.PULPIT = p.PULPIT
--			   left join SUBJECT s on s.PULPIT = p.PULPIT
--GROUP BY f.FACULTY, p.PULPIT, s.SUBJECT;

--declare @faculty char(10), @pulpit char(20), @subject char(10), @tea_count int = 0, @str char(300) = '';
--declare @f char(10) = '', @p char(20) = '', @tc int = -1;

--OPEN DF; -- открыли курсор
--	FETCH DF into @faculty, @pulpit, @subject, @tea_count;
--	while @@FETCH_STATUS = 0
--		begin
--			if(@f != @faculty) -- сравниваем текущее значение с предыдущим
--			begin
--				print 'Факультет: ' + @faculty;
--			end;

--			if(@p != @pulpit)
--			begin
--				print '		Кафедра: ' + @pulpit;
--			end;

--			if(@tc != @tea_count)
--			begin
--				print '			Кол-во преподавателей: ' + cast(@tea_count as char(5));
--			end;

--			begin
--				while @p != @pulpit
--				begin
--					set @str = rtrim(@subject) + ', ' + @str;
--				end;
--				if(@str = '')
--				begin
--					set @str = 'нет';
--				end;
--				print '			Дисциплины: ' + @str + '.';
--			end

--			set @f = @faculty; -- обновляем значение, чтобы текущее значение сделать прерыдущим
--			set @tc = @tea_count;
--			set @p = @pulpit;
--			FETCH DF into @faculty, @pulpit, @subject, @tea_count;
--		end;
--CLOSE DF;
----- короче не получилось