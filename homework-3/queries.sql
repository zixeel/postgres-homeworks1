-- Напишите запросы, которые выводят следующую информацию:
-- 1. Название компании заказчика (company_name из табл. customers) и ФИО сотрудника,
--работающего над заказом этой компании (см таблицу employees),
-- когда и заказчик и сотрудник зарегистрированы в городе London,
--а доставку заказа ведет компания United Package (company_name в табл shippers)
SELECT c.company_name, CONCAT(e.first_name, ' ', e.last_name) AS full_name
FROM customers c
INNER JOIN orders o USING(customer_id)
INNER JOIN employees e ON o.employee_id = e.employee_id
WHERE c.city = 'London'
AND e.city = 'London'
AND o.ship_via = 2

-- 2. Наименование продукта, количество товара (product_name и units_in_stock в табл products),
-- имя поставщика и его телефон (contact_name и phone в табл suppliers) для таких продуктов,
-- которые не сняты с продажи (поле discontinued) и которых меньше 25 и которые в категориях Dairy Products и Condiments.
-- Отсортировать результат по возрастанию количества оставшегося товара.
SELECT p.product_name, p.units_in_stock, s.contact_name, s.phone
FROM products p
INNER JOIN suppliers s USING(supplier_id)
WHERE discontinued <> 1 AND units_in_stock < 25 AND category_id IN (4, 2)
ORDER BY units_in_stock


-- 3. Список компаний заказчиков (company_name из табл customers), не сделавших ни одного заказа
SELECT c.company_name
FROM customers c
WHERE NOT EXISTS(
SELECT 1 FROM orders o
WHERE c.customer_id=o.customer_id
)

-- 4. уникальные названия продуктов, которых заказано ровно 10 единиц (количество заказанных единиц см в колонке quantity табл order_details)
-- Этот запрос написать именно с использованием подзапроса.
SELECT DISTINCT p.product_name
FROM products p
WHERE EXISTS
(SELECT 1 FROM order_details o
WHERE p.product_id = o.product_id AND o.quantity = 10)