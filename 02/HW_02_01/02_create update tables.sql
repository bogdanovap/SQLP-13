SET search_path TO flower_shop;

--информация о товарах
-- drop table if exists products;
create table products(
    -- идентифиактор продкута
    -- заполняется автоматически, автоинкремент
    product_id serial primary key,
    -- название продукта
    -- текстовое поле с названием продукта (не более 50 символов)
    -- обязательное поле при создании продукта
    product_name varchar(50) not null unique,
    -- характеристики продукта
    -- по умолчанию (для новых продуктов) - пустой json
    -- содержит описание продукта в формате json (ключ - название характеристики, значение - значение характеристики)
    product_features json default '{}',
    -- цена закупки
    -- для созданных продуктов - цена покупи - NULL
    -- данное поле заполняется при закупке товара через триггер
    product_last_purchase_price decimal(10, 2) default null,
    -- количество товара на складе
    -- для созданных продуктов - количество товара = 0
    -- данное поле обновляется при закупке товара или продаже через соответствующие триггеры
    product_current_stock integer not null default 0
);


--информация о закупках
-- drop table if exists purchases;
create table purchases(
    -- идентифиактор продкута
    -- заполняется автоматически, автоинкремент
    purchase_id serial primary key,
    -- внешний ключ на таблицу products (product_id)
    -- обязательное поле при создании закупки
    product_id integer not null references products(product_id),
    -- цена закупки за единицу товара
    -- формат поля - decimal(10, 2)
    -- обязательное поле при создании закупки
    purchase_price decimal(10, 2) not null,
    -- количество закупленного товара
    -- целочисленное поле
    -- обязательное поле при создании закупки
    purchase_count integer not null,
    -- дата оплаты
    -- поле в формате date
    -- значение при создании закупки - NULL
    -- заполняется при проведении оплаты
    payment_date date default null
);


--информация о работниках
-- drop table if exists workers;
create table workers(
    -- идентификатор работника
    -- целочисленное поле, заполняется автоматически, автоинкремент
    worker_id serial primary key,
    -- фамилия работника
    -- текстовое поле с фамилией работника (не более 50 символов)
    -- обязательное поле при создании работника
    last_name varchar(50) not null,
    -- имя работника
    -- текстовое поле с именем работника (не более 30 символов)
    -- обязательное поле при создании работника
    first_name varchar(30) not null,
    -- дата рождения работника
    -- поле в формате date
    -- обязательное поле при создании работника
    date_of_birth date not null,
    -- поле с зарплатой работника
    -- формат поля - decimal(10, 2)
    -- обязательное поле при создании работника
    -- возможно, следует вынести в отдельную таблицу с указанием периода действия конкретной зарплаты
    salary decimal(10, 2) not null,
    -- поле с адресом работника
    -- формат поля - json, по умолчанию - пустой json
    -- заполнять в формате (ключ - название поля, значение - значение поля)
    -- например, {city: 'Moscow', street: 'Lenina', house: '1', flat: '1'}
    address json default '{}'
);


--заказы на доставку
-- drop table if exists orders;
create table orders(
    -- идентификатор заказа
    -- целочисленное поле, заполняется автоматически, автоинкремент
    order_id serial primary key,
    -- работник, который оформил заказ
    -- внешний ключ на таблицу workers (worker_id)
    worker_id integer not null references workers(worker_id),
    -- внешний ключ на таблицу products (product_id)
    -- обязательное поле при создании заказа
    product_id integer not null references products(product_id),
    -- количество товара в заказе
    -- целочисленное поле
    -- обязательное поле при создании заказа
    order_count integer not null,
    -- цена продажи за единицу товара
    -- формат поля - decimal(10, 2)
    -- обязательное поле при создании заказа
    order_price decimal(10, 2) not null,
    -- адрес доставки товара
    -- формат поля - json, по умолчанию - пустой json
    -- заполнять в формате (ключ - название поля, значение - значение поля)
    -- например, {city: 'Moscow', street: 'Lenina', house: '1', flat: '1'}
    order_delivery_address text not null,
    -- дата оплаты
    -- поле в формате date
    -- значение при создании заказа - NULL
    -- заполняется при проведении оплаты
    payment_date date default null
);


-- --информация о затратах
-- -- в данном отшонии предполагается объеденить несколько сушностей - налоги, аренда, зарплата
-- -- целесообразно создать отдельные таблицы для каждого типа затрат (expenses_taxes, expenses_rent, expenses_salary)
-- -- расширить атрибуты таблиц для корректного описания платежей, добавить внешние ключили (например, на таблицу workers)
-- -- сводный отчет по затратам (expenses) формировать через представление
-- create table expenses(
--     expense_id serial primary key,
--     expense_type varchar(50) not null,
--     expense_amount decimal(10, 2) not null
-- );