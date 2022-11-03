CREATE DATABASE ORG;
SHOW DATABASES;
USE ORG;

CREATE TABLE Worker(
    WORKER_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	FIRST_NAME CHAR(25),
	LAST_NAME CHAR(25),
	SALARY INT(15),
	JOINING_DATE DATETIME,
	DEPARTMENT CHAR(25)
);
INSERT INTO Worker  
     (WORKER_ID, FIRST_NAME, LAST_NAME, SALARY, JOINING_DATE, DEPARTMENT) VALUES
		(001, 'Monika', 'Arora', 100000, '14-02-20 09.00.00', 'HR'),
		(002, 'Niharika', 'Verma', 80000, '14-06-11 09.00.00', 'Admin'),
		(003, 'Vishal', 'Singhal', 300000, '14-02-20 09.00.00', 'HR'),
		(004, 'Amitabh', 'Singh', 500000, '14-02-20 09.00.00', 'Admin'),
        (005, 'Vivek', 'Bhati', 500000, '14-06-11 09.00.00', 'Admin'),
		(006, 'Vipul', 'Diwan', 200000, '14-06-11 09.00.00', 'Account'),
		(007, 'Satish', 'Kumar', 75000, '14-01-20 09.00.00', 'Account'),
		(008, 'Geetika', 'Chauhan', 90000, '14-04-11 09.00.00', 'Admin');
        
CREATE TABLE Bonus(
	WORKER_REF_ID INT,
	BONUS_AMOUNT INT(10),
	BONUS_DATE DATETIME,
	FOREIGN KEY (WORKER_REF_ID)
	REFERENCES Worker(WORKER_ID)
	ON DELETE CascADE
);
INSERT INTO Bonus
    ( WORKER_REF_ID, BONUS_AMOUNT, BONUS_DATE) VALUES
    (001, 5000,'16-02-20'),
    (002, 3000,'16-6-11'),
    (003,4000,'16-02-20'),
    (001, 4500, '16-02-20'),
	(002, 3500, '16-06-11');
CREATE TABLE Title (
		WORKER_REF_ID INT,
	    WORKER_TITLE CHAR(25),
		AFFECTED_from DATETIME,
		FOREIGN KEY (WORKER_REF_ID)
		REFERENCES Worker(WORKER_ID)
        ON DELETE CascADE
);
INSERT INTO Title 
	(WORKER_REF_ID, WORKER_TITLE, AFFECTED_from) VALUES
	(001, 'Manager', '2016-02-20 00:00:00'),
	(002, 'Executive', '2016-06-11 00:00:00'),
	(008, 'Executive', '2016-06-11 00:00:00'),
	(005, 'Manager', '2016-06-11 00:00:00'),
	(004, 'Asst. Manager', '2016-06-11 00:00:00'),
	(007, 'Executive', '2016-06-11 00:00:00'),
	(006, 'Lead', '2016-06-11 00:00:00'),
	(003, 'Lead', '2016-06-11 00:00:00');
    
-- fetch “FIRST_NAME” from Worker table using the alias name as <WORKER_NAME>
select FIRST_NAME AS WORKER_NAME from Worker;

-- fetch “FIRST_NAME” from Worker table in upper case
select upper(FIRST_NAME) from Worker;

-- fetch unique values of DEPARTMENT from Worker table
select distinct DEPARTMENT from Worker;  

-- FIRST_NAME and LAST_NAME from Worker table into a single column COMPLETE_NAME
select concat(FIRST_NAME,' ',LAST_NAME) AS COMPLETE_NAME from Worker;

-- print all Worker details from the Worker table order  by FIRST_NAME ascending
select * from Worker order  by FIRST_NAME asc;

-- print all Worker details from the Worker table order  by FIRST_NAME ascending and DEPARTMENT descending
select * from Worker order  by FIRST_NAME asc, DEPARTMENT desc;

-- print details for Workers with the first name as “Vipul” and “Satish” from Worker table
select * from Worker where FIRST_NAME in('Vipul', 'Satish');

-- print details of workers excluding first names, “Vipul” and “Satish” from Worker table
select * from Worker where FIRST_NAME not in ('vipul', 'Satish');

-- print details of Workers with DEPARTMENT name as “Admin”
select * from Worker where DEPARTMENT like 'Admin%';

-- the Workers whose FIRST_NAME contains ‘a’
select * from Worker where FIRST_NAME like '%a%';

-- the Workers whose FIRST_NAME ends with ‘a’
select * from Worker where FIRST_NAME like '%a';

-- the Workers whose FIRST_NAME ends with ‘h’ and contains six alphabets
select * from Worker where FIRST_NAME like '______h';

-- the Workers whose SALARY lies between 100000 and 500000
select * from Worker where SALARY between 100000 and 500000;

-- the Workers who have joined in Feb’2014
select * from Worker where year(JOINING_DATE) = 2014 and month(JOINING_DATE) = 2;

-- the count of employees working in the department ‘Admin’
select * from Worker where DEPARTMENT='Admin';

-- fetch worker names with salaries >= 50000 and <= 100000
select concat(FIRST_NAME, ' ', LAST_NAME) As Worker_Name, Salary
from Worker 
where WORKER_ID IN 
(select WORKER_ID from worker 
where Salary BETWEEN 50000 AND 100000);

-- fetch the no. of workers for each department in the descending order
select DEPARTMENT, count(WORKER_ID) No_Of_Workers 
from Worker 
group by DEPARTMENT 
order  by No_Of_Workers desc;

-- the Workers who are also Managers
select DISTINCT W.FIRST_NAME, T.WORKER_TITLE
from Worker W
inner join Title T
ON W.WORKER_ID = T.WORKER_REF_ID
AND T.WORKER_TITLE in ('Manager');

-- fetch duplicate records having matching data in some fields of a table
select WORKER_TITLE, AFFECTED_from, COUNT(*)
from Title
group by WORKER_TITLE, AFFECTED_from
HAVING count(*) > 1;

-- odd rows from a table
select * from Worker where MOD (WORKER_ID, 2) <> 0;

-- even rows from a table
select * from Worker where MOD (WORKER_ID, 2)=0;

-- the current date and time
select now();

-- top n (say 10) records of a table
select * from Worker order  by Salary desc LIMIT 10;

-- the nth (say n=5) highest salary from a table
select SALARY, FIRST_NAME
from Worker W
where 4 = (select count(distinct( S.SALARY ))
from Worker S
where S.SALARY >= W.SALARY);

-- list of employees with the same salary
select distinct W.WORKER_ID, W.FIRST_NAME, W.Salary 
from Worker W, Worker W1 
where W.Salary = W1.Salary 
and W.WORKER_ID != W1.WORKER_ID;

-- second highest salary from a table
select max(Salary) from Worker 
where Salary not in (select max(Salary) from Worker);

-- first 50% records from a table
select * from Worker 
where WORKER_ID <= (select count(WORKER_ID)/2 from Worker);

-- departments that have less than five people in it
select DEPARTMENT, COUNT(WORKER_ID) as 'Number of Workers' 
from Worker 
group by DEPARTMENT HAVING COUNT(WORKER_ID) < 5;

-- all departments along with the number of people in there
select DEPARTMENT, COUNT(DEPARTMENT) as 'Number of Workers' 
from Worker
group by DEPARTMENT;

-- the last record from a table
select * from Worker where WORKER_ID = (select max(WORKER_ID) from Worker);

-- the first row of a table
select * from Worker where WORKER_ID =(select min(WORKER_ID) from Worker);

-- three max salaries from a table
select distinct Salary
from worker a where 3 >= (select count(distinct Salary)
from worker b where a.Salary <= b.Salary)
order  by a.Salary desc;

-- three min salaries from a table
select distinct Salary 
from worker a where 3 >= (select count(distinct Salary) 
from worker b where a.Salary >= b.Salary) 
order  by a.Salary desc;

-- total salaries paid for each of them
 select DEPARTMENT, sum(Salary) 
 from Worker 
 group by DEPARTMENT;

-- names of workers who earn the highest salary
select FIRST_NAME, SALARY 
from Worker where SALARY=(select max(SALARY) from Worker);