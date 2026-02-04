-- CTEs


with CTE_Example as
(
select gender, avg(salary) as avg_sal
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id
group by gender
)
select avg(avg_sal)
from CTE_Example;

-- better syntax than subquery
select avg(avg_sal)
from
(select gender, avg(salary) as avg_sal
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id
group by gender
) example_subquery; 



-- can use more than one CTE
with CTE_Example as
(
select employee_id,gender,birth_date
from employee_demographics
where birth_date > '1985-01-01'
),
CTE_Example2 as
(
select employee_id, salary
from employee_salary
where salary > 50000
)
select *
from CTE_Example
join CTE_Example2
	on CTE_Example.employee_id = CTE_Example2.employee_id;