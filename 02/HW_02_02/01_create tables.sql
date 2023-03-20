SET search_path TO flower_shop_online;

-- создание таблицы с покупателями онлайн магазина
drop table if exists customer_online;
create table customer_online(
    -- идентификатор покупателя
    -- автозаполнение, автоинкремент
    customer_id serial primary key,
    -- почта покупателя, уникальное значение
    -- указывается в текстовом формате, не более 50 символов
    -- обязательное поле
    customer_email varchar(50) unique not null,
    -- имя покупателя, не более 50 символов
    -- не обязательное поле
    customer_name varchar(50)
);

-- создание таблицы с заказами онлайн магазина
drop table if exists order_online;
create table order_online(
    -- идентификатор заказа
    -- автозаполнение, автоинкремент
    order_id serial primary key,
    -- идентификатор покупателя
    -- ссылка на таблицу с покупателями
    -- обязательное поле
    customer_id int references customer_online(customer_id),
    -- идентифактор продукта
    product_id int,
    -- дата заказа
    -- указывается в формате дата, по умолчанию текущая дата
    order_date date default now(),
    -- стоимость заказа
    -- указывается в десятичном формате (10,2)
    -- обязательное поле
    order_price decimal(10,2) not null,
    -- количество заказа
    -- указывается в целочисленном формате
    order_count int not null
)