SET search_path TO flower_shop;

--информация о товарах
-- оставить только те поля, которые опиывают товар (название и характеристики товара)
-- возможно, стоит добавить поле с последней ценой закупки товара
-- возможно, создать поле - остаток товара на складе - в котором обновляется количество товара
-- (для упрощения, считаем что у нас только один склад и все закупки сразу попадают на него)
-- вероятно, целесообразно создать таблицу с розничной ценой товара и периодом действия цены
create table products(
product_id serial primary key,
product_name varchar(50) not null unique,
-- скорее всего, товары могут именть множество разных характеристик
-- поэтому целесообразно использовать поле json с характеристиками товара
product_color varchar(30) not null,
-- вероятно, amount - это цена за единицу товара
-- поэтому лучше переименовать в product_price
product_amount decimal(10, 2) not null,
-- вероятно, count - это количество товара на складе
product_count integer not null
);

--информация о работниках
-- поле age не корректное, необходимо заменить на дату рождения
-- целесообразно заменить поле salary на таблицу с зп
create table workers(
worker_id serial primary key,
last_name varchar(50) not null,
first_name varchar(30) not null,
-- заменить на дату рождения
age integer not null,
-- зп может меняться, поэтому целесообразно создать таблицу с зп
salary decimal(10, 2) not null,
address text not null
);

--информация о затратах
-- в данном отшонии предполагается объеденить несколько сушностей - налоги, аренда, зарплата
-- целесообразно создать отдельные таблицы для каждого типа затрат (expenses_taxes, expenses_rent, expenses_salary)
-- расширить атрибуты таблиц для корректного описания платежей, добавить внешние ключили (например, на таблицу workers)
-- сводный отчет по затратам (expenses) формировать через представление
create table expenses(
expense_id serial primary key,
expense_type varchar(50) not null,
expense_amount decimal(10, 2) not null
);

--информация о закупках
-- заменить purchase_amount на purchase_price
-- удалить дублиующиеся поля (purchase_name, purchase_color)
-- добавить внешний ключ на таблицу products (product_id)
-- добавить тригеры, которые будут обновлять количество товара на складе и цены закупки (последнюю)
create table purchases(
purchase_id serial primary key,
payment_date timestamp,
--поля название и цвет товара не нужны, так как они уже есть в таблице products
purchase_name varchar(50) not null unique,
purchase_color varchar(30) not null,
--вероятно, amount - это цена закукпи за единицу товара,
--поэтому лучше переименовать в purchase_price
purchase_amount decimal(10, 2) not null,
--вероятно, count - это количество закупленного товара
purchase_count integer not null
);

--заказы на доставку
-- заменить order_product на внешний ключ на таблицу products (product_id)
-- добавить поля, описывающие заказ (в т.ч. количество, цена, дата заказа)
-- переименовать поле order_address в order_delivery_address
-- целесообразно, добавить поле отвественного за заказ (внешний ключ на таблицу workers)
-- добавить триггер на уменьшение количества товара на складе при оформлении заказа
create table orders(
order_id serial primary key,
-- заменить на внеший ключ на таблицу products (product_id)
order_product json not null, --{product_id: count}
-- не очевиден смысл поля, лучше переименовть в order_delivery_address
order_address text not null
);

--информация о платежах
-- для упрощения будем считать, что платежи производятся только за заказы, включают один платеж в полном объеме
-- исходя из этого, данная таблица добавляет только одно смысловое поле (дата платежа)
-- следовательно, целесообрано добавить дату платежа в таблицу orders, а таблицу payments удалить
create table payments(
payment_id serial primary key,
payment_amount decimal(10, 2) not null,
payment_date timestamp default now()
);
