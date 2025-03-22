select*from books;
select*from returnstatus;
select*from members;
select*from issueid;
---------------------------------------------
-- Advanced Questions
/*
Task 13: 
Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.
*/
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

/*    
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
*/

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
------------------------------
-- Second Method Stored Procedure
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

/*
Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
*/

select*from issueid;
select*from branch;
select*from books;
select*from employees;
select*from returnstatus;
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
select*from branch_status;
drop table branch_status;
-- Task 16: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.
create table active_members
as
select * from members 
where member_id in(select
distinct(issued_member_id)
from issueid
where issued_date>= current_date()-interval 6 Month);
select*from active_members;

-- Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
select e.emp_name,count(ist.issued_id) as count,br.*
from issueid as ist
join
employees as e
on e.emp_id=ist.issued_emp_id
join
branch as br
on br.branch_id=e.branch_id
group by 1,3;

-- Task 17: Identify members Issuing High-Risk books
-- Write a query to identify members who have issued books more than twice with the status "damaged" in the books table.Display the member_name,book_title, and number of time they have issued the damaged books.
select*from employees;
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

/*
Task 19: Stored Procedure Objective: 

Create a stored procedure to manage the status of books in a library system. 

Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 

The procedure should function as follows: 

The stored procedure should take the book_id as an input parameter. 

The procedure should first check if the book is available (status = 'yes'). 

If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
*/

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

