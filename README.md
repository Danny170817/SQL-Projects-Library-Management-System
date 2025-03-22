# **SQL Projects: Library Management System**

## **Overview**

This repository contains SQL queries for a **Library Management System**. The project consists of **two levels**: basic queries and advanced SQL operations. The queries demonstrate data handling, retrieval, joins, subqueries, and database management.

---

## **Table of Contents**

- [Overview](#overview)
- [Features](#features)
- [Database Schema](#database-schema)
- [Getting Started](#getting-started)
- [Setup](#setup)
- [Questions & Solutions](#questions--solutions)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

---

## **Features**

- Queries structured around a **Library Management System**.
- Covers essential SQL topics such as:
  - Data retrieval (SELECT, WHERE, ORDER BY)
  - Aggregations (COUNT, SUM, AVG)
  - JOIN operations (INNER, LEFT, RIGHT)
  - Subqueries & Common Table Expressions (CTEs)
  - Stored procedures & triggers
- Well-structured and documented for learning and practice.

---

## **Database Schema**

The project operates on a **Library Management System** with the following tables:

- **Branch** (Stores library branch details)
- **Employees** (Library staff details)
- **Books** (Book catalog with availability status)
- **Members** (Registered library members)
- **IssueID** (Records book issue transactions)
- **ReturnStatus** (Tracks book returns)

---

## **Getting Started**

To use this project, follow these steps:

1. Clone the repository.
2. Set up MySQL or any preferred SQL engine.
3. Run the SQL scripts to create and populate the database.
4. Execute the queries to explore insights.

---

## **Setup**

1. **Create the database:**
   ```sql
   CREATE DATABASE library_management;
   USE library_management;
   ```
2. **Execute the provided SQL script:**
   ```sql
   SOURCE SQL_Project_2.sql;
   SOURCE SQL_Project_2_Advanced.sql;
   ```

---

## **Questions & Solutions**

### **Basic Queries (Project 2)**

### **Q.1 Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"**
#### **Solution:**
```sql
insert into books(isbn,book_title,category,rental_price,status,author,publisher)
values('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
select* from members;
```

### **Q.2 Update an Existing Member's Address**
#### **Solution:**
```sql
update members
set member_address="125 Main St"
where member_id="C101";
```

### **Q.3 Delete the record with issued_id = 'IS121' from the issued_status table.**
#### **Solution:**
```sql
select* from issueid
delete from issueid
where issued_id="IS121";
```

### **Q.4 Select all books issued by the employee with emp_id = 'E101'.**
#### **Solution:**
```sql
select* from issueid
where issued_emp_id='E101';
```

### **Q.5 Use GROUP BY to find members who have issued more than one book.**
#### **Solution:**
```sql
select issued_emp_id,count(issued_id)
from issueid
group by issued_emp_id
having count(issued_id)>1;
```

---

### **Q.6 Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
#### **Solution:**
```sql
create table book_count
as
select b.isbn,b.book_title,count(issued_id) from books as b
join
issueid as ist
on ist.issued_book_isbn=b.isbn
group by 1;
select*from book_count;
```

### **Q.7 Retrieve All Books in a Specific Category**
#### **Solution:**
```sql
select* from books
where category="Children";
```

### **Q.8 Find Total Rental Income by Category.**
#### **Solution:**
```sql
select b.category,sum(rental_price),count(*)as count
from books as b
join
issueid as ist
on issued_book_isbn=b.isbn
group by 1;
```

### **Q.9 List Members Who Registered in the Last 180 Days.**
#### **Solution:**
```sql
select*from members
where reg_date>=current_date- interval 180 Day;
```

### **Q.10 List Employees with Their Branch Manager's Name and their branch details**
#### **Solution:**
```sql
select 
	e.*,
    br.manager_id,
    e2.emp_name as manager
    from employees as e
join 
branch as br
on br.branch_id=e.branch_id
join
employees as e2
on br.manager_id=e2.emp_id;
```

### **Q.11 Create a Table of Books with Rental Price Above a Certain Threshold 7USD:**
#### **Solution:**
```sql
select*from books
where rental_price>="7";
```

### **Q.12 Retrieve the List of Books Not Yet Returned**
#### **Solution:**
```sql
select*
from issueid as isr
left join
returnstatus as rr
on rr.issued_id=isr.issued_id
```
## **Advanced Queries (Project 2 Advanced)**

### **Q.13 Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.**
#### **Solution:**
```sql
select
isd.issued_member_id,
m.member_name,
bd.book_title,
isd.issued_date,
rr.return_date,
DATEDIFF(CURRENT_DATE, issued_date) AS over_due_days
from issueid as isd
join
books as bd
on bd.isbn=isd.issued_book_isbn
join
members as m
on m.member_id=isd.issued_member_id
left join
returnstatus as rr
on rr.issued_id=isd.issued_id
where return_date is null and DATEDIFF(CURRENT_DATE, issued_date)>"30";
```

### **Q.14 Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).**
#### **Solution:**
```sql
select*from issueid
where issued_book_isbn="978-0-451-52994-2";
select*from books
where isbn="978-0-451-52994-2";
update books
set status ="No"
where isbn="978-0-451-52994-2";
select*from returnstatus
where issued_id="IS130";
insert into returnstatus(return_id, issued_id, return_date, book_quality)
values('RS125', 'IS130', CURRENT_DATE, 'Good');
select*from returnstatus
where issued_id="IS130";
```
#### ** Second Solution:**
```sql
DELIMITER $$

CREATE PROCEDURE Pro_Status(
    p_return_id VARCHAR(10), 
    p_issued_id VARCHAR(10), 
     p_book_quality VARCHAR(10)
)
BEGIN
    -- Declare variables
    DECLARE v_isbn VARCHAR(50);
    DECLARE v_book_name VARCHAR(80);

    -- Insert into returnstatus table
    INSERT INTO returnstatus(return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE(), p_book_quality);

    -- Fetch book details
    SELECT issued_book_isbn, issued_book_name 
    INTO v_isbn, v_book_name
    FROM issueid
    WHERE issued_id = p_issued_id;

    -- Update book status
    UPDATE books
    SET status = 'no'
    WHERE isbn = v_isbn;
END $$

DELIMITER ;
select*from issueid
where issued_id="is135";
select*from books
where isbn="978-0-307-58837-1";
select*from returnstatus
where return_book_isbn="is135";
call Pro_Status("RS138","IS135","Good");
```
### **Q.15 Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.**
#### **Solution:**
```sql
create table branch_status
as
select br.branch_id,br.manager_id,count(ist.issued_id),count(rr.return_id),sum(b.rental_price)
from issueid as ist
join 
employees as e
on e.emp_id=ist.issued_emp_id
join
branch as br
on br.branch_id=e.branch_id
inner join 
returnstatus as rr
on rr.issued_id=ist.issued_id
join
books as b
on b.isbn=ist.issued_book_isbn
group by 1,2;
```

### **Q.16 Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.**
#### **Solution:**
```sql
create table active_members
as
select * from members 
where member_id in(select
distinct(issued_member_id)
from issueid
where issued_date>= current_date()-interval 6 Month);
select*from active_members;
```

### **Q.17 Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.**
#### **Solution:**
```sql
select e.emp_name,count(ist.issued_id) as count,br.*
from issueid as ist
join
employees as e
on e.emp_id=ist.issued_emp_id
join
branch as br
on br.branch_id=e.branch_id
group by 1,3;
```

### **Q.18 Write a query to identify members who have issued books more than twice with the status "damaged" in the books table.Display the member_name,book_title, and number of time they have issued the damaged books.**
#### **Solution:**
```sql
select count(ist.issued_id)as count,m.member_name,b.book_title
from issueid as ist
join
members as m
on m.member_id=ist.issued_member_id
join
books as b
on b.isbn=ist.issued_book_isbn
where status="Damaged"
GROUP BY m.member_name, b.book_title
HAVING COUNT(ist.issued_id) >= 2;
```

### **Q.19 Stored Procedure Objective: 
Create a stored procedure to manage the status of books in a library system. 
Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 
The procedure should function as follows: 
The stored procedure should take the book_id as an input parameter. 
The procedure should first check if the book is available (status = 'yes'). 
If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.**
#### **Solution:**
```sql
DELIMITER $$

CREATE PROCEDURE issue_status(
    IN p_issued_id VARCHAR(10), 
    IN p_issued_member_id VARCHAR(30), 
    IN p_issued_book_isbn VARCHAR(30),
    IN p_issued_emp_id VARCHAR(10)
)
BEGIN
    -- Declare variables
    DECLARE v_status VARCHAR(20);

    -- Check if book is available
    SELECT status INTO v_status FROM books
    WHERE isbn = p_issued_book_isbn;

    -- If book is available, insert issue record
    IF v_status = 'yes' THEN
        INSERT INTO issueid (issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)  
        VALUES (p_issued_id, p_issued_member_id, CURRENT_DATE(), p_issued_book_isbn, p_issued_emp_id);

        -- Update book status
        UPDATE books
        SET status = 'no'
        WHERE isbn = p_issued_book_isbn;
    ELSE
        SET v_status = 'Not available';
        SELECT v_status AS StatusMessage;  -- Return message
    END IF;
END $$

DELIMITER ;

select* from books
where isbn="9978-0-375-41398-8"; -- status = yes

select* from books
where isbn="978-0-553-29698-2" ;-- status = no

CALL issue_status('IS155', 'C108', '978-0-553-29698-2', 'E103');
CALL issue_status('IS155', 'C108', '9978-0-375-41398-8', 'E103');


```

---

## **License**
This project is licensed under the **MIT License**. 🚀

