create or replace function sales_between_dates(start_date date, end_date date)
    returns float as $$
    begin

        return (select sum(amount) as total
                from payment
                where payment_date between start_date and end_date);

    end;
$$ language plpgsql;

select sales_between_dates('2005-05-25', '2005-05-28');


