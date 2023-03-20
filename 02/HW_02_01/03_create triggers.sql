-- создание тригера для обновления остатка товара на складе
drop trigger if exists purchase_update_product_stock_trigger on purchases;
create function purchase_update_product_stock() returns trigger as $$
begin
    if (TG_OP = 'INSERT') then
        update products set product_current_stock = product_current_stock + new.purchase_count where product_id = new.product_id;
    elsif (TG_OP = 'UPDATE') then
        update products set product_current_stock = product_current_stock - old.purchase_count + new.purchase_count where product_id = new.product_id;
    elsif (TG_OP = 'DELETE') then
        update products set product_current_stock = product_current_stock - old.purchase_count where product_id = old.product_id;
    end if;
    return null;
end;
$$ language plpgsql;
create trigger purchase_update_product_stock_trigger
    after insert or update or delete on purchases
    for each row execute procedure purchase_update_product_stock();


-- создание тригера для обновления цены закупки товара
-- данный тригер автоматически обновляет цену закупки товара при создании или обновлении данных по закпукам
-- всегда берет цену последней закупки товара
drop trigger if exists purchase_update_product_last_purchase_price_trigger on purchases;
create function purchase_update_product_last_purchase_price() returns trigger as $$
declare
    last_purchase_price decimal(10, 2);
begin
    execute 'select purchase_price from purchases where product_id = ' || new.product_id || ' order by purchase_id desc limit 1' into last_purchase_price;
    update products set product_last_purchase_price = last_purchase_price where product_id = new.product_id;
    return null;
end;
$$ language plpgsql;
create trigger purchase_update_product_last_purchase_price_trigger
    after insert or update or delete on purchases
    for each row execute procedure purchase_update_product_last_purchase_price();


-- создание тригера для обновления остатка товара на складе
drop trigger if exists order_update_product_stock_trigger on orders;
create function order_update_product_stock() returns trigger as $$
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
create trigger order_update_product_stock_trigger
    after insert or update or delete on orders
    for each row execute procedure order_update_product_stock();