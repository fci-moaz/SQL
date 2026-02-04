-- Temporary Table
/*
it a table we create temporary in sql tab and can use it in author tabs 
but if we close the sql program can't use it in author tabs
*/

create temporary table temp_table
(first_name varchar(50),
last_name varchar(50)
);


select * 
from temp_table;


-- to insert data in this table
insert into temp_table
values('Moaz','Ehab');


select * 
from temp_table;


-- Example how to use
create temporary table salary_over_50k
select *
from employee_salary
where salary > 50000;

select *
from salary_over_50k;