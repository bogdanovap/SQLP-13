set search_path to skud;

-- Создание таблицы городов
-- справочник городов
-- название города указывается в поле name (varchar(100))
--drop table if exists cities;
create table cities
(
    id serial primary key,
    name varchar(100) not null
);

-- Создание таблицы адресов
-- справочник адресов
-- город указывается как внешний ключ (city_id)
-- непосрдетственно адрес указывается в поле address в виде текста (varchar(100))
--drop table if exists addresses;
create table addresses
(
    id serial primary key,
    city_id integer not null,
    address varchar(100) not null,
    constraint fk_city_id foreign key (city_id) references cities(id)
);

-- Создание таблицы филиалов
-- название филиала указывается в поле name (varchar(100))
-- адрес филиала указывается как внешний ключ (address_id)
-- город отдельно не указываем, т.к. он указан в адресе
--drop table if exists branches;
create table branches
(
    id serial primary key,
    name varchar(100) not null,
    address_id integer not null,
    constraint fk_address_id foreign key (address_id) references addresses(id)
);

-- Создание таблицы сотрудников
-- ФИО сотрудника указывается в поле name (varchar(100))
-- адрес сотрудника указывается как внешний ключ (address_id)
--drop table if exists employees;
create table employees
(
    id serial primary key,
    name varchar(100) not null,
    address_id integer not null,
    branch_id integer not null,
    salary integer not null,
    constraint fk_address_id foreign key (address_id) references addresses(id),
    constraint fk_branch_id foreign key (branch_id) references branches(id)
);

-- филиал, в котором работает сотрудник
-- в таблице указывается филиал и зарплата сотрудника
--drop table if exists employee_branch;
create table employee_branch
(
    id serial primary key,
    employee_id integer not null,
    branch_id integer not null,
    salary integer not null,
    -- true - актуальность записи (место работы, зарплата)
    is_active boolean not null default true,
    constraint fk_employee_id foreign key (employee_id) references employees(id),
    constraint fk_branch_id foreign key (branch_id) references branches(id)
);

-- Создание таблицы учета рабочего времени
-- в таблице указывается факт прохода сотрудника через турникет
-- необходимо указать сотрудника (employee_id), филиал (branch_id) и тип прохода (вход/выход)
-- тип прохода (вход/выход) указывается в поле in_out (boolean): true - вход, false - выход
--drop table if exists timesheet;
create table timesheet
(
    id serial primary key,
    employee_id integer not null,
    branch_id integer not null,
    datetime timestamp not null default now(),
    in_out boolean not null, -- true - вход, false - выход
    constraint fk_employee_id foreign key (employee_id) references employees(id),
    constraint fk_branch_id foreign key (branch_id) references branches(id)
);

-- создание таблицы начисления заработной платы
-- в таблице указывается только ФАКТ начисления зарплаты
-- сумма зарплаты указана в таблице employee_branch
-- предполагается, что зарплата выплачивается тем филиалом, в котором на момент выплаты работает сотрудник
--drop table if exists salary;
create table salary
(
    id serial primary key,
    employee_id integer not null,
    datetime timestamp not null default now(),
    constraint fk_employee_id foreign key (employee_id) references employees(id)
);