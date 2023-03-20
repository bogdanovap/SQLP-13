SET search_path TO flower_shop;

create extension if not exists postgres_fdw;

-- drop server if exists flower_shop_online_server cascade;
create server flower_shop_online_server
foreign data wrapper postgres_fdw
options (host '192.168.11.126', port '5432', dbname 'sqlp');

create user mapping for postgres
server flower_shop_online_server
options (user 'postgres', password 'postgres');


select * from pg_extension;
select * from pg_foreign_server;
select * from pg_user_mapping;