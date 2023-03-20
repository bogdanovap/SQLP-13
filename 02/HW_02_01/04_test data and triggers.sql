-- созданим несколько продуктов и работника
insert into products(product_name, product_features)
values ('Товар 1', '{"color": "красный", "size": "маленький"}'),
       ('Товар 2', '{"color": "зеленый", "size": "большой"}'),
       ('Товар 3', '{"color": "голубой", "size": "средний"}');
select * from products order by product_id;

insert into workers(last_name, first_name, date_of_birth, salary, address)
values ('Иванов', 'Иван', '1990-01-01', 10000, '{"city": "Moscow", "street": "Lenina", "house": "1", "flat": "1"}');
select * from workers order by worker_id;

-- сделаем одну закупку для проверки тригера
insert into purchases(payment_date, product_id, purchase_count, purchase_price)
values ('2020-01-01', 1, 30, 25);
select * from purchases order by purchase_id;
-- проверяем что остаток обновился
select * from products where product_id = 1;

-- сделаем один заказ для проверки тригера
insert into orders(worker_id, product_id, order_count, order_price, order_delivery_address)
values (1, 1, 15, 50, '{"city": "Moscow", "street": "Lenina", "house": "1", "flat": "1"}');
select * from orders order by order_id;
-- проверяем что остаток обновился
select * from products where product_id = 1;