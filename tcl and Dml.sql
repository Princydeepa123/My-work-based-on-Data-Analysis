use 3to5;
create table techP(id int, Name varchar(20),Gender varchar(20));
desc techP;
insert into techP values(1,"Joel","Male");
start transaction;
insert into techP values(2,"Carol","Female");
select * from techP;
savepoint a1;
update techP set name="Fredrick Joel" where id=1;
set sql_safe_updates=0;
select * from techP;
savepoint a2;
delete from techP where id=1;
select * from techP;
rollback to a2;
select * from techP;
rollback to a1;
select * from techP;
rollback;
select * from techP;
commit;


drop table techP;
