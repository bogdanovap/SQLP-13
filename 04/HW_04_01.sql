set search_path to public;

-- • идентификатор платежа
-- • почтовая информация о клиенте
-- • информация по фильмам, которые были оплачены
-- • сумма платежей за месяц (если платеж был в январе, то сумма всех платежей за январь и т.д.)
-- • сумма платежей за неделю (если платеж был 22.09.20, то сумма всех платежей с 21.09.20 по
-- 27.09.20 включительно и т.д.)
-- • информация по магазину, в котором была произведена продажа
-- • фамилия и имя продавц

select count(*) from payment; --16049
select sum(amount) from payment; --67416

create materialized view payment_info as
select
    -- идентификатор платежа
    payment_id,
    amount,
    -- информация о покупателя
    -- возможно, это поле не нужно заменять на тектовое, т.к. уже есть ИД пользователя
    c.first_name || ' ' || c.last_name as customer_name,
    -- информация об аренде (ид-р аренды, ид-р инвентаря, ид-р фильма)
    p.rental_id,
    i.inventory_id,
    f.film_id,
    -- информация о дате платеже
    -- с выделением года, месяца, недели (для будущей агрегации)
    payment_date,
    DATE_PART('year', payment_date) as year,
    DATE_PART('month', payment_date) as month,
    DATE_PART('week', payment_date) as week,
    -- идентификатор магазина в котором была продажа
    i.store_id,
    -- имя продавца
    -- возможно, это поле не нужно заменять на тектовое, т.к. уже есть ИД продавца
    s.first_name || ' ' || s.last_name as seller_name
from payment as p
join customer c on p.customer_id = c.customer_id
join rental r on p.rental_id = r.rental_id
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join staff s on s.staff_id = p.staff_id
;

--создадим тригер для обновления этой таблицы при изменении таблицы payment
-- этот тригер будет вызвваться каждый раз при изменении таблицы payment

create function update_payment_info() returns trigger as $$
    begin
        execute 'REFRESH MATERIALIZED VIEW payment_info';
        return null;
    end;
$$ language plpgsql;

create trigger update_payment_info
after insert or update or delete on payment
    execute function update_payment_info();  
