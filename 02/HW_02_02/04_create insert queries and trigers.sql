-- создаем правило для добавления данных в таблицу онлайн покупателей
drop rule if exists insert_to_customer_online on customer_online_view;
create rule insert_to_customer_online as on insert to customer_online_view
    do instead insert into customer_online (customer_email, customer_name)
               values (new.customer_email, new.customer_name);
-- добавляем строчку во внешнюю таблицу
insert into customer_online_view (customer_email, customer_name)
values ('ivan@ivanov.ru', 'Ivan Ivanov');
-- проверяем что данные записались во внешнюю таблицу
select * from customer_online_view;


-- создаем правило  для обновления таблицы онлайн заказов
drop rule if exists insert_to_orders_online on order_online_view;
create rule insert_to_orders_online as on insert to order_online_view
    do instead insert into order_online (order_date, customer_id, product_id, order_price, order_count)
               values (new.order_date, new.customer_id, new.product_id, new.order_price, new.order_count);


-- создание тригера для обновления остатка товара на складе
drop function if exists order_online_update_product_stock();
create function order_online_update_product_stock() returns trigger as $$
    begin
        if (TG_OP = 'INSERT') then
            update products set product_current_stock = product_current_stock - new.order_count where product_id = new.product_id;
        elsif (TG_OP = 'UPDATE') then
            update products set product_current_stock = product_current_stock + old.order_count - new.order_count where product_id = new.product_id;
        elsif (TG_OP = 'DELETE') then
            update products set product_current_stock = product_current_stock + old.order_count where product_id = old.product_id;
        end if;
        return null;
    end;
$$ language plpgsql;
drop trigger if exists order_online_update_product_stock_trigger on order_online;
create trigger order_online_update_product_stock_trigger
    after insert or update or delete on order_online
    for each row execute procedure order_online_update_product_stock();

insert into order_online_view (order_date, customer_id, product_id, order_price, order_count)
values ('2020-01-02', 1, 1, 50, 10);

select * from order_online_view;

select * from products where product_id = 1;