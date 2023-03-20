set search_path to skud;

-- поскольку БД сформирована для СКУД, то основной поток транзакций - это вход/выход сотрудников
-- поэтому основные транзакции - это вход/выход сотрудников

-- вход сотрудника
insert into timesheet (employee_id, branch_id, in_out)
VALUES (1, 1, 1);

-- выход сотрудника
insert into timesheet (employee_id, branch_id, in_out)
VALUES (1, 1, 0);

-- отчет о сотрудниках в офисе
-- для отчета возьмем информаицю о последнем входе сотрудника
-- привяжем к нему информацию о филиале и сотруднике
-- время транзации - будем считить временем входа сотрудника в офис
select
    b.name as branch_name,
    e.name as employee_name,
    t.datetime as enter_time
from (select distinct on (employee_id) employee_id, datetime, branch_id, in_out
      from timesheet
      order by datetime desc) as t
join branches b on t.branch_id = b.id
join employees e on t.employee_id = e.id
where in_out = 1;

