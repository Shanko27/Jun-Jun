-- 1. +Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.

SELECT*
From client
where  length(FirstName) <5;

-- 2. +Вибрати львівські відділення банку.+

SELECT*
From department
where  DepartmentCity = 'Lviv';

-- 3. +Вибрати клієнтів з вищою освітою та посортувати по прізвищу.

Select *
From client
Where Education = 'high'
order by LastName;

-- 4. +Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.

Select*
From application
order by idApplication DESC  limit 5;

-- 5. +Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.

Select*
From client
Where LastName like '%ov' or '%ova';

-- 6. +Вивести клієнтів банку, які обслуговуються київськими відділеннями.

Select*
From client
where  City = 'Kyiv';

-- 7. +Вивести імена клієнтів та їхні номера телефону, погрупувавши їх за іменами.

SELECT FirstName
from client
group by FirstName;

-- 8. +Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.

SELECT *
from application
Where Sum > 5000;

-- 9. +Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
SELECT count(idClient)
from client
where  City = 'Lviv';

-- 10. Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.

SELECT FirstName, LastName, max(sum)
from client
left join application  app on app.Client_idClient = client.idClient
group by FirstName, LastName;

-- 11. Визначити кількість заявок на крдеит для кожного клієнта.

SELECT FirstName, LastName, count(sum)
from client
left join application  app on app.Client_idClient = client.idClient
group by FirstName, LastName;

-- 12. Визначити найбільший та найменший кредити.

SELECT FirstName, LastName, max(sum) as max,  min(sum) as min
from client
left join application  app on app.Client_idClient = client.idClient
group by FirstName, LastName;

-- 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.

SELECT Education, count(sum)
from client
left join application  app on app.Client_idClient = client.idClient
where  Education = 'high'
group by Education;

-- 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.

SELECT FirstName, LastName, avg(sum) as avg
from client
left join application  app on app.Client_idClient = client.idClient

group by FirstName, LastName
order by avg desc limit 1;

-- 15. Вивести відділення, яке видало в кредити найбільше грошей

SELECT City, sum(sum) as s
from application
left join client c on application.Client_idClient = c.idClient
group by City
order by s desc limit 1;

-- 16. Вивести відділення, яке видало найбільший кредит.

SELECT City, count(sum) as s
from application
left join client c on application.Client_idClient = c.idClient
group by City
order by s desc limit 1;

-- 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.



update client
left join application  app on app.Client_idClient = client.idClient
set sum = 6000
Where Education = 'high';

-- 18. Усіх клієнтів київських відділень пересилити до Києва.

update client
left join department d on client.Department_idDepartment = d.idDepartment
set City = 'Kyiv'
Where DepartmentCity = 'Kyiv';

-- 19. Видалити усі кредити, які є повернені.

delete from application where CreditState = 'Returned';

-- 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.

delete application
    from application
left join client c on c.idClient = application.Client_idClient
 where LastName like '_[euioa]%';

-- Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000

SELECT CountOfWorkers, sum(sum) as s
from application
left join client c on application.Client_idClient = c.idClient
left join department d on c.Department_idDepartment = d.idDepartment
where DepartmentCity = 'Lviv'
group by CountOfWorkers
having s > 5000;

-- Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000

SELECT FirstName, LastName, sum
from application
left join client c on application.Client_idClient = c.idClient
where CreditState = 'Returned' and Sum > 5000;

-- /* Знайти максимальний неповернений кредит.*/

SELECT  sum
from application
where CreditState = 'Not Returned'
order by Sum desc limit 1;

-- /*Знайти клієнта, сума кредиту якого найменша*/

SELECT FirstName, LastName, sum
from application
left join client c on application.Client_idClient = c.idClient
order by Sum limit 1;

-- /*Знайти кредити, сума яких більша за середнє значення усіх кредитів*/


SELECT idApplication from application

select FirstName, LastName, sum
from application
left join client c on application.Client_idClient = c.idClient
where sum > (SELECT avg(sum) from application);



-- /*Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів*/

select FirstName, LastName
from client
left join application a on client.idClient = a.Client_idClient
where City = (SELECT City from application
    left join client c on application.Client_idClient = c.idClient
    order by Sum desc limit 1  );

#місто чувака який набрав найбільше кредитів

select FirstName, LastName, City, Sum(Sum) as s
from client
left join application a on client.idClient = a.Client_idClient
group by FirstName, LastName, City
order by s desc limit 1;













