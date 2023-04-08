use ��_���1
go
CREATE table ��������
(
	name_shop nvarchar(20),
	id_shop int primary key
)

CREATE table ������
(
	name_cat nvarchar(20) primary key,
	id_shop int,
)

INSERT INTO ��������(id_shop, name_shop)
	values(1, '���� �������'),
		(2, '���'),
		(3, '������� �����'),
		(4, '�������')

INSERT INTO ������(name_cat, id_shop)
	values('��������', 1),
		('�����', 8),
		('������', null),
		('�������', 3);
go
/* �������� full outer join */

select name_cat, ������.id_shop, name_shop, ��������.id_shop
from ������ full outer join ��������
on ������.id_shop = ��������.id_shop;

select name_cat, ������.id_shop, name_shop, ��������.id_shop
from �������� full outer join ������
on ������.id_shop = ��������.id_shop;

/* ������� ��� ����� �������: */

-- �������� ������ ����� (� �������� FULL OUTER JOIN) ������� 
-- � �� �������� ���-��� ������ ??
select name_cat, ������.id_shop, name_shop
from ������ full outer join ��������
on ������.id_shop = ��������.id_shop
where ��������.name_shop is null;

-- �������� ������ ������ (� �������� FULL OUTER JOIN) ������� 
-- � �� �������� ���-��� ����� ??
select name_cat, ������.id_shop, name_shop
from ������ full outer join ��������
on ������.id_shop = ��������.id_shop
where ������.name_cat is null

-- ���������� ����� � ������ ������
select name_cat, ������.id_shop, name_shop
from ������ full outer join ��������
on ������.id_shop = ��������.id_shop
where ������.name_cat is not null and ��������.name_shop is not null;
