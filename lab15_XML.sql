-- задание 1
select PULPIT.FACULTY[факультет], TEACHER.PULPIT[факультет/кафедра], 
TEACHER.TEACHER_NAME[факультет/кафедра/преподаватель]
from TEACHER inner join PULPIT on TEACHER.PULPIT = PULPIT.PULPIT
where TEACHER.PULPIT = 'ИСиТ' for xml raw('препод'), root('Список_преподавателей_кафедры_ИСиТ');

select PULPIT.FACULTY[факультет], TEACHER.PULPIT[факультет/кафедра], 
TEACHER.TEACHER_NAME[факультет/кафедра/преподаватель]
from TEACHER inner join PULPIT on TEACHER.PULPIT = PULPIT.PULPIT
where TEACHER.PULPIT = 'ИСиТ' for xml path('препод'), root('Список_преподавателей_кафедры_ИСиТ');

-- задание 2
-- режим auto для многотабличных запросов
select AUDITORIUM, AUDITORIUM_TYPENAME, AUDITORIUM_CAPACITY
	from AUDITORIUM inner join AUDITORIUM_TYPE on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
	where AUDITORIUM_TYPE.AUDITORIUM_TYPE LIKE '%ЛК%'
	for xml AUTO, root('LECTURE_AUDITORIUMS'), elements;
go

-- задание 3
-- преобразуем XML-данные и добавляем в строки таблицы
begin tran;
	declare @xmlHandle int = 0,
			@xml varchar(2000) = 
				'<?xml version="1.0" encoding="windows-1251" ?>
				<SUBJECTS> 
					<SUBJECT SUBJECT="ТТТ" SUBJECT_NAME="ТТТ" PULPIT="ИСиТ" /> 
					<SUBJECT SUBJECT="ИИТ" SUBJECT_NAME="ИИТ" PULPIT="ТЛ" /> 
					<SUBJECT SUBJECT="РРТ" SUBJECT_NAME="РРТ" PULPIT="ТиП"  />  
				</SUBJECTS>'
	
	exec sp_xml_preparedocument @xmlHandle output, @xml;
	
	select * from openxml(@xmlHandle, '/SUBJECTS/SUBJECT', 0)
		with(SUBJECT char(10), SUBJECT_NAME varchar(100), PULPIT char(20));

	insert into SUBJECT select * from openxml(@xmlHandle, '/SUBJECTS/SUBJECT', 0)
		with(SUBJECT char(10), SUBJECT_NAME varchar(100), PULPIT char(20));

	select * from SUBJECT where SUBJECT LIKE '%Т';
	
	exec sp_xml_removedocument @xmlHandle;

rollback tran;

select * from SUBJECT where SUBJECT LIKE '%Т';
go


-- задание 4
-- серию и номер паспорта, личный номер, дата выдачи и адрес прописки
create table PASSPORTS
(
	id_student int primary key foreign key references STUDENT(IDSTUDENT),
	passport xml
);

insert into PASSPORTS values 
	(1005, 
	N'<паспорт> 
		<личный_номер>2734263486</личный_номер>
		<серийный_номер>MP68298499</серийный_номер>
		<дата_выдачи>18.02.2020</дата_выдачи>
		<адрес>Какой-то адрес 1</адрес>
	</паспорт>'),
	(1006, 
	N'<паспорт> 
		<личный_номер>8747998320</личный_номер>
		<серийный_номер>MP682383289</серийный_номер>
		<дата_выдачи>24.03.2020</дата_выдачи>
		<адрес>Какой-то адрес 2</адрес>
	</паспорт>'),
	(1007, 
	N'<паспорт> 
		<личный_номер>7689349702</личный_номер>
		<серийный_номер>MP923094947</серийный_номер>
		<дата_выдачи>02.04.2020</дата_выдачи>
		<адрес>Какой-то адрес 3</адрес>
	</паспорт>')

update PASSPORTS set passport = 
	N'<паспорт> 
		<личный_номер>7689349702</личный_номер>
		<серийный_номер>MP0000000</серийный_номер>
		<дата_выдачи>02.04.2020</дата_выдачи>
		<адрес>Какой-то адрес 3</адрес>
	</паспорт>'
	where passport.value('(/паспорт/адрес)[1]', 'nvarchar(60)') = N'Какой-то адрес 3';

select id_student [id], 
	   passport.value('(/паспорт/серийный_номер)[1]', 'nvarchar(10)')[серийный номер],
	   passport.query('/паспорт')[паспорт]
	   from PASSPORTS;

drop table PASSPORTS;
go


-- задание 5
create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
           elementFormDefault="qualified"
           xmlns:xs="http://www.w3.org/2001/XMLSchema">
       <xs:element name="студент">  
       <xs:complexType><xs:sequence>
       <xs:element name="паспорт" maxOccurs="1" minOccurs="1">
       <xs:complexType>
       <xs:attribute name="серия" type="xs:string" use="required" />
       <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
       <xs:attribute name="дата"  use="required" >  
       <xs:simpleType>  <xs:restriction base ="xs:string">
   <xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
   </xs:restriction> 	</xs:simpleType>
   </xs:attribute> </xs:complexType> 
   </xs:element>
   <xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
   <xs:element name="адрес" type="xs:string" />
   </xs:sequence></xs:complexType>
   </xs:element>
</xs:schema>';

alter table STUDENT alter column INFO xml(Student);

update STUDENT set INFO =
N'<студент>
	<паспорт серия="MP" номер="37929230" дата="06.06.2020"></паспорт>
	<телефон>54788898</телефон>
	<адрес>sbkdkasbdisab</адрес>
</студент>'
where IDSTUDENT = 1005;

select INFO from STUDENT where IDSTUDENT = 1005;

update STUDENT set INFO =
N'<студент>
	<паспорт серия=33 номер="37929230" дата="06.06.2020"></паспорт>
	<телефон>54788898</телефон>
	<адрес>sbkdkasbdisab</адрес>
</студент>'
where IDSTUDENT = 1006;
go

alter table STUDENT alter column INFO xml;
go
drop xml schema collection Student;
go


-- задание 6
use DailyPlannerDB;

create table XmlTable ( value xml )

insert into XmlTable values
(N'<документ формат="json">
	<раздел номер="1" >Раздел 1</раздел>
	<раздел номер="2" >Раздел 1</раздел>
	<раздел номер="3" >Раздел 1</раздел>
</документ>');

select * from XmlTable;

drop table XmlTable;

go


-- задание 7
select rtrim(FACULTY.FACULTY) as '@код',
	(select COUNT(*) from PULPIT where PULPIT.FACULTY = FACULTY.FACULTY) as 'количество_кафедр',
	(select rtrim(PULPIT.PULPIT) as '@код',
		(select rtrim(TEACHER.TEACHER) as 'преподаватель/@код', TEACHER.TEACHER_NAME as 'преподаватель'
		from TEACHER where TEACHER.PULPIT = PULPIT.PULPIT for xml path(''),type, root('преподаватели'))
	from PULPIT where PULPIT.FACULTY = FACULTY.FACULTY for xml path('кафедра'), type, root('кафедры'))
from FACULTY for xml path('факультет'), type, root('университет');