create database project2;
create table branch(branch_id varchar(10) primary key,manager_id varchar(10),branch_address varchar(55),contact_no varchar(10));
create table employees(emp_id varchar(10) primary key,emp_name varchar(20),position varchar(10),salary int,branch_id varchar(10));
create table books(isbn varchar(20) primary key,book_title varchar(75),category varchar(20),rental_price float,status varchar(10),author varchar(35),publisher varchar(55));
create table members(member_id varchar(10) primary key,member_name varchar(20),member_address varchar(40),reg_date date);
create table issueid(issued_id varchar(10) primary key,issued_member_id varchar(10),issued_book_name varchar(40),issued_date date,issued_book_isbn varchar(40),issued_emp_id varchar(10));
create table returnstatus(return_id varchar(20) primary key,issued_id varchar(20),return_book_name varchar(50),return_date date,return_book_isbn varchar(10));
-- Foregin key;
Alter table issueid
Add constraint fk_issued_member
foreign key(issued_member_id)
references members(member_id);

Alter table issueid
Add constraint fk_books
foreign key(issued_book_isbn )
references books(isbn);

Alter table issueid
Add constraint fk_employee_id
foreign key(issued_emp_id )
references employees(emp_id);

Alter table employees
Add constraint fk_branch
foreign key(branch_id )
references branch(branch_id);

Alter table returnstatus
Add constraint fk_issue_status
foreign key(issued_id )
references issueid(issued_id);

INSERT INTO issueid(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id) 
VALUES
('IS106', 'C106', 'Animal Farm', '2024-03-10', '978-0-330-25864-8', 'E104'),
('IS107', 'C107', 'One Hundred Years of Solitude', '2024-03-11', '978-0-14-118776-1', 'E104'),
('IS108', 'C108', 'The Great Gatsby', '2024-03-12', '978-0-525-47535-5', 'E104'),
('IS109', 'C109', 'Jane Eyre', '2024-03-13', '978-0-141-44171-6', 'E105'),
('IS110', 'C110', 'The Alchemist', '2024-03-14', '978-0-307-37840-1', 'E105'),
('IS111', 'C109', 'Harry Potter and the Sorcerers Stone', '2024-03-15', '978-0-679-76489-8', 'E105'),
('IS112', 'C109', 'A Game of Thrones', '2024-03-16', '978-0-09-957807-9', 'E106'),
('IS113', 'C109', 'A Peoples History of the United States', '2024-03-17', '978-0-393-05081-8', 'E106'),
('IS114', 'C109', 'The Guns of August', '2024-03-18', '978-0-19-280551-1', 'E106'),
('IS115', 'C109', 'The Histories', '2024-03-19', '978-0-14-044930-3', 'E107'),
('IS116', 'C110', 'Guns, Germs, and Steel: The Fates of Human Societies', '2024-03-20', '978-0-393-91257-8', 'E107'),
('IS117', 'C110', '1984', '2024-03-21', '978-0-679-64115-3', 'E107'),
('IS118', 'C101', 'Pride and Prejudice', '2024-03-22', '978-0-14-143951-8', 'E108'),
('IS119', 'C110', 'Brave New World', '2024-03-23', '978-0-452-28240-7', 'E108'),
('IS120', 'C110', 'The Road', '2024-03-24', '978-0-670-81302-4', 'E108'),
('IS121', 'C102', 'The Shining', '2024-03-25', '978-0-385-33312-0', 'E109'),
('IS122', 'C102', 'Fahrenheit 451', '2024-03-26', '978-0-451-52993-5', 'E109'),
('IS123', 'C103', 'Dune', '2024-03-27', '978-0-345-39180-3', 'E109'),
('IS124', 'C104', 'Where the Wild Things Are', '2024-03-28', '978-0-06-025492-6', 'E110'),
('IS125', 'C105', 'The Kite Runner', '2024-03-29', '978-0-06-112241-5', 'E110'),
('IS126', 'C105', 'Charlotte''s Web', '2024-03-30', '978-0-06-440055-8', 'E110'),
('IS127', 'C105', 'Beloved', '2024-03-31', '978-0-679-77644-3', 'E110'),
('IS128', 'C105', 'A Tale of Two Cities', '2024-04-01', '978-0-14-027526-3', 'E110'),
('IS129', 'C105', 'The Stand', '2024-04-02', '978-0-7434-7679-3', 'E110'),
('IS130', 'C106', 'Moby Dick', '2024-04-03', '978-0-451-52994-2', 'E101'),
('IS131', 'C106', 'To Kill a Mockingbird', '2024-04-04', '978-0-06-112008-4', 'E101'),
('IS132', 'C106', 'The Hobbit', '2024-04-05', '978-0-7432-7356-4', 'E106'),
('IS133', 'C107', 'Angels & Demons', '2024-04-06', '978-0-7432-4722-5', 'E106'),
('IS134', 'C107', 'The Diary of a Young Girl', '2024-04-07', '978-0-375-41398-8', 'E106'),
('IS135', 'C107', 'Sapiens: A Brief History of Humankind', '2024-04-08', '978-0-307-58837-1', 'E108'),
('IS136', 'C107', '1491: New Revelations of the Americas Before Columbus', '2024-04-09', '978-0-7432-7357-1', 'E102'),
('IS137', 'C107', 'The Catcher in the Rye', '2024-04-10', '978-0-553-29698-2', 'E103'),
('IS138', 'C108', 'The Great Gatsby', '2024-04-11', '978-0-525-47535-5', 'E104'),
('IS139', 'C109', 'Harry Potter and the Sorcerers Stone', '2024-04-12', '978-0-679-76489-8', 'E105'),
('IS140', 'C110', 'Animal Farm', '2024-04-13', '978-0-330-25864-8', 'E102');

INSERT INTO returnstatus(return_id, issued_id, return_date) 
VALUES
('RS106', 'IS108', '2024-05-05'),
('RS107', 'IS109', '2024-05-07'),
('RS108', 'IS110', '2024-05-09'),
('RS109', 'IS111', '2024-05-11'),
('RS110', 'IS112', '2024-05-13'),
('RS111', 'IS113', '2024-05-15'),
('RS112', 'IS114', '2024-05-17'),
('RS113', 'IS115', '2024-05-19'),
('RS114', 'IS116', '2024-05-21'),
('RS115', 'IS117', '2024-05-23'),
('RS116', 'IS118', '2024-05-25'),
('RS117', 'IS119', '2024-05-27'),
('RS118', 'IS120', '2024-05-29');

-- Task 1.Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

insert into books(isbn,book_title,category,rental_price,status,author,publisher)
values('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
select* from members

-- Task 2: Update an Existing Member's Address
update members
set member_address="125 Main St"
where member_id="C101"

-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

select* from issueid
delete from issueid
where issued_id="IS121"

-- Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

select* from issueid
where issued_emp_id='E101';

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

select issued_emp_id,count(issued_id)
from issueid
group by issued_emp_id
having count(issued_id)>1;
select* from books;
select*from issueid;
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
create table book_count
as
select b.isbn,b.book_title,count(issued_id) from books as b
join
issueid as ist
on ist.issued_book_isbn=b.isbn
group by 1;
select*from book_count;
-- Task 7. Retrieve All Books in a Specific Category:
select* from books
where category="Children";

-- Task 8: Find Total Rental Income by Category:
select b.category,sum(rental_price),count(*)as count
from books as b
join
issueid as ist
on issued_book_isbn=b.isbn
group by 1;

-- Task 9. List Members Who Registered in the Last 180 Days:
select*from members
where reg_date>=current_date- interval 180 Day;

--  task 10 List Employees with Their Branch Manager's Name and their branch details:
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
-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:
select*from books
where rental_price>="7";
-- Task 12: Retrieve the List of Books Not Yet Returned
select*
from issueid as isr
left join
returnstatus as rr
on rr.issued_id=isr.issued_id