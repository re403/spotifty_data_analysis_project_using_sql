create database window_function;

use window_function;

CREATE TABLE marks (
 student_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    branch VARCHAR(255),
    marks INTEGER
);

INSERT INTO marks (name,branch,marks)VALUES 
('Nitish','EEE',82),
('Rishabh','EEE',91),
('Anukant','EEE',69),
('Rupesh','EEE',55),
('Shubham','CSE',78),
('Ved','CSE',43),
('Deepak','CSE',98),
('Arpan','CSE',95),
('Vinay','ECE',95),
('Ankit','ECE',88),
('Anand','ECE',81),
('Rohit','ECE',95),
('Prashant','MECH',75),
('Amit','MECH',69),
('Sunny','MECH',39),
('Gautam','MECH',51);

select * from marks;

-- using groupby

select branch,avg(marks) from marks group by branch;

select *,avg(marks) over(partition by branch) from marks;

select  avg(marks) over() from marks;

select *, avg(marks) over() from marks;


select *,min(marks) over(),max(marks) over() from marks;

select *,min(marks) over(partition by branch),max(marks) over(partition by branch) 
from marks order by student_id;

-- Find the students who have marks higher than the avg marks of their respective branch.
select * from (
select *, avg(marks) over(partition by branch) as "Average_marks_branch" from marks) as t
where t.marks > t.Average_marks_branch;

select *,rank() over(order by marks desc) from marks;

select *,rank() over(partition by branch order  by marks desc) from marks;

select *,rank() over(partition by branch order  by marks desc),
dense_rank() over(partition by branch order by marks desc)
 from marks;
 
 select *,row_number() over() from marks;
 
 select *,concat(branch,"_",row_number() over(partition by branch)) from marks;
 
 select *,row_number() over(partition by branch order by student_id asc) from marks;
 
 select *,row_number() over(order by student_id asc) from marks;
 
 select * from orders;
 
 -- find top 2 most paying customer of each month.
 
 select * ,month(date),sum(amount) from orders group by month(date),user_id order by sum(amount) desc;
 select * from (
 select user_id,month(date) as month_name,sum(amount), dense_rank() over(partition by user_id,month(date)) as "Total_Amount" 
 from orders) as t order by month_name;
 
 
select * from (
select user_id,monthname(date),sum(amount),rank() over(partition by 
monthname(date) order by sum(amount) desc) as "rank_of_persn"
from orders group by user_id,monthname(date) order by monthname(date)) as t
where t.rank_of_persn <3;

select *, last_value(marks) over(order by marks desc) from marks;
select *, first_value(name) over(partition by branch order by marks desc) from marks;
 
select *, last_value(marks) over(partition by branch order by marks desc
 rows between unbounded preceding and unbounded following) from marks;
 
 select *, nth_value(marks,2) over(partition by branch order by marks desc
 rows between unbounded preceding and unbounded following) from marks;
 
 -- find the topper of the each branch..
 
select * from (
select *,first_value(name) over(partition by branch order by marks desc) as "topper_name",
first_value(marks) over(partition by branch order by marks desc) as  "topper_marks"
 from marks) as t 
 where t.name = t.topper_name and t.marks = t.topper_marks;

 -- find the low scorer of the each branch.. 
select * from (
select *,last_value(name) over(partition by branch order by marks desc
 rows between unbounded preceding and unbounded following) as "topper_name",
last_value(marks) over(partition by branch order by marks desc 
rows between unbounded preceding and unbounded following) as  "topper_marks"
 from marks) as t 
 where t.name = t.topper_name and t.marks = t.topper_marks;
 
SELECT * FROM (
    SELECT *, 
        LAST_VALUE(name) OVER w AS "topper_name",
        LAST_VALUE(marks) OVER w AS "topper_marks"
    FROM marks
    WINDOW w AS (
        PARTITION BY branch 
        ORDER BY marks DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
) AS t
WHERE t.name = t.topper_name AND t.marks = t.topper_marks;

select * from marks;

select *,
lag(marks) over(order by student_id) ,
lead(marks) over(order by student_id) 
from marks;

select *,
lag(marks) over(partition by branch order by student_id) ,
lead(marks) over(partition by branch order by student_id) 
from marks;

select * from orders;

SELECT 
    monthname(date) AS month,
    SUM(amount) AS total_amount,
    (SUM(amount) - LAG(SUM(amount)) OVER(ORDER BY MONTH(date)))/ 
    LAG(SUM(amount)) OVER(ORDER BY MONTH(date))*100
FROM orders
GROUP BY MONTH(date), monthname(date)
ORDER BY MONTH(date);


