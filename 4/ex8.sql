use БД_лаб1
go
CREATE table магазины
(
	name_shop nvarchar(20),
	id_shop int primary key
)

CREATE table котики
(
	name_cat nvarchar(20) primary key,
	id_shop int,
)

INSERT INTO магазины(id_shop, name_shop)
	values(1, 'твой питомец'),
		(2, 'мяу'),
		(3, 'золотая рыбка'),
		(4, 'котопес')

INSERT INTO котики(name_cat, id_shop)
	values('пушистик', 1),
		('клауд', 8),
		('анубис', null),
		('такояки', 3);
go
/* проверка full outer join */

select name_cat, котики.id_shop, name_shop, магазины.id_shop
from котики full outer join магазины
on котики.id_shop = магазины.id_shop;

select name_cat, котики.id_shop, name_shop, магазины.id_shop
from магазины full outer join котики
on котики.id_shop = магазины.id_shop;

/* Создать три новых запроса: */

-- содержит данные левой (в операции FULL OUTER JOIN) таблицы 
-- и не содержит дан-ные правой ??
select name_cat, котики.id_shop, name_shop
from котики full outer join магазины
on котики.id_shop = магазины.id_shop
where магазины.name_shop is null;

-- содержит данные правой (в операции FULL OUTER JOIN) таблицы 
-- и не содержит дан-ные левой ??
select name_cat, котики.id_shop, name_shop
from котики full outer join магазины
on котики.id_shop = магазины.id_shop
where котики.name_cat is null

-- результаты левой и правой таблиц
select name_cat, котики.id_shop, name_shop
from котики full outer join магазины
on котики.id_shop = магазины.id_shop
where котики.name_cat is not null and магазины.name_shop is not null;
