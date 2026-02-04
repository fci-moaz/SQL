-- Triggers and Events
/*
Trigger is a stored procedure executes automatically based on specific event happen
event is a scheduled action executes at specific time
*/


-- Trigger
delimiter $$
create trigger employee_insert
	after insert on employee_salary
    for each row
begin
	insert into employee_demographics (employee_id, first_name, last_name)
    values (new.employee_id, new.first_name, new.last_name);
end $$
delimiter ;

insert into employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
values(15,'Moaz','Ehab','Data Analyst', 80000,6);


select *
from employee_demographics;


-- Events
select * 
from employee_demographics;

delimiter $$
create event delete_retirees
on schedule every 1 minute 
do
begin
	delete
	from employee_demographics
    where age >= 60;
end $$
delimiter ;

show variables like 'event%';  -- to show schedule on or off