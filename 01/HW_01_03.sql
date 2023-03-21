
--Создайте таблицу not_active_customer со столбцами id, customer_id и not_active_date (дата создания записи)
create table not_active_customer
(
    id serial primary key,
    customer_id integer unique references customer,
    not_active_date date
);

--Функция customer_de_activate, для заполнения not_active_customer при вызове тригера
create function customer_de_activate() returns trigger
    language plpgsql
as
$$
    begin
        if (OLD.active = 1 and NEW.active = 0) then
            insert into not_active_customer (customer_id, not_active_date)
            values (NEW.customer_id, CURRENT_DATE)
            on conflict (customer_id) do nothing;
        end if;
      return null;
    end;
$$;

--триггер который будет вызывать функцию для добавления записи в not_active_customer
CREATE TRIGGER customer_de_activate_trigger
    AFTER UPDATE ON public.customer
    FOR EACH ROW EXECUTE FUNCTION customer_de_activate();



--проверка
--определение функции для тригера
select pg_get_functiondef('customer_de_activate'::regproc);
--список тригеров
SELECT  event_object_table AS table_name ,trigger_name
FROM information_schema.triggers;
--определение нашего тригера
select pg_get_triggerdef(oid)
from pg_trigger
where tgname = 'customer_de_activate_trigger';