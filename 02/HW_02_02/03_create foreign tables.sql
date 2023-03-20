-- создаем связь с таблицей на удаленном сервере
-- drop foreign table if exists flower_shop.customer_online cascade;
create foreign table flower_shop.customer_online(
    customer_id serial,
    customer_email varchar(50)  not null,
    customer_name varchar(50)
    )
server  flower_shop_online_server
options (schema_name 'flower_shop_online', table_name 'customer_online');
-- создадим представление для чтения данных
create view flower_shop.customer_online_view as select * from flower_shop.customer_online;
-- проверяем что все работает
select * from customer_online_view;

-- создаем связь с таблицей на удаленном сервере
-- drop foreign table if exists flower_shop.order_online cascade;
create foreign table flower_shop.order_online(
    order_id serial,
    order_date date,
    customer_id int,
    product_id int,
    order_price numeric(10,2),
    order_count int
    )
server  flower_shop_online_server
options (schema_name 'flower_shop_online', table_name 'order_online');
-- создадим представление для чтения данных
create view flower_shop.order_online_view as select * from flower_shop.order_online;
-- проверяем что все работает
select * from order_online_view;


