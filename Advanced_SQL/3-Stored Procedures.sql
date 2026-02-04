-- Stored Procedures
-- it stored data in schemas 

create procedure large_salaries()
select *
from employee_salary
where salary >= 50000;

call large_salaries()  -- to call the table that we created



-- to create procedure has more than one function

delimiter $$ 	-- to change ; delimiter to help us make more than one function
create procedure large_salaries2()
begin
	select *
	from employee_salary
	where salary >= 50000;
	select *
	from employee_salary
	where employee_id > 3;
end $$
delimiter ;

call large_salaries2();


-- to choose specific data for the table will create
delimiter $$
create procedure large_salaries3(p_employee_id int)
begin
	select *
	from employee_salary
	where employee_id = p_employee_id;
end $$
delimiter ;

call large_salaries3(5);