
-- 1. Enter a new customer (30/day).
DROP PROCEDURE IF EXISTS insertCustomer;
GO
CREATE PROCEDURE insertCustomer
    @name_customer VARCHAR(100),
    @address_customer VARCHAR(100),
    @category INT
AS
BEGIN
    INSERT INTO customer (name_customer, address_customer, category)
    VALUES (@name_customer, @address_customer, @category);
END

-- 2. Enter a new department (infrequent).
DROP PROCEDURE IF EXISTS insertDepartment;
GO
CREATE PROCEDURE insertDepartment
    @dept_no INT,
    @dept_data VARCHAR(100)
AS
BEGIN
    INSERT INTO department (dept_no, dept_data)
    VALUES (@dept_no, @dept_data);
END

/*SELECT * from department*/

-- 3. FIT: Enter a new process-ID and its department information (infrequent).
DROP PROCEDURE IF EXISTS insertFitProcess;
GO
CREATE PROCEDURE insertFitProcess
    @process_id INT,
    @dept_no INT,
    @process_data VARCHAR(100),
    @fit_type VARCHAR(50)
AS
BEGIN
    INSERT INTO process_fit (process_id, dept_no, process_data, fit_type)
    VALUES (@process_id, @dept_no, @process_data, @fit_type);
END

/*SELECT * From process_fit*/

-- 3. PAINT: Enter a new process-ID and its department information (infrequent).
DROP PROCEDURE IF EXISTS insertPaintProcess;
GO
CREATE PROCEDURE insertPaintProcess
    @process_id INT,
    @process_data VARCHAR(100),
    @dept_no INT,
    @paint_type VARCHAR(100),
    @painting_method VARCHAR(100)
AS
BEGIN
    INSERT INTO process_paint (process_id, process_data, dept_no, paint_type, painting_method)
    VALUES (@process_id, @process_data, @dept_no, @paint_type, @painting_method);
END

/*SELECT * From process_paint*/

-- 3. CUT: Enter a new process-ID and its department information (infrequent).
DROP PROCEDURE IF EXISTS insertCutProcess;
GO
CREATE PROCEDURE insertCutProcess
    @process_id INT,
    @process_data VARCHAR(100),
    @dept_no INT,
    @cutting_type VARCHAR(50),
    @machine_type VARCHAR(50)
AS
BEGIN
    INSERT INTO process_cut (process_id, process_data, dept_no, cutting_type, machine_type)
    VALUES (@process_id, @process_data, @dept_no, @cutting_type, @machine_type);
END

/*SELECT * From process_cut*/


-- 4. Enter a new assembly with its customer-name, assembly-details, assembly-id, and date ordered and associate it with one or more processes (40/day).
DROP PROCEDURE IF EXISTS insertAssembly;
GO
CREATE PROCEDURE insertAssembly
    @assembly_id INT,
    @date_ordered VARCHAR(100),
    @assembly_details VARCHAR(100),
    @customer_name VARCHAR(100),
    @process_ids VARCHAR(MAX)  -- Comma-separated string of process IDs
AS
BEGIN
    -- Insert data into Assembly table
    INSERT INTO Assembly (assembly_id, date_ordered, assembly_details, Customer_name)
    VALUES (@assembly_id, @date_ordered, @assembly_details, @customer_name);

    -- Split the comma-separated process_ids string into a table
    DECLARE @process_id_table TABLE (process_id INT);
    INSERT INTO @process_id_table (process_id)
    SELECT value
    FROM STRING_SPLIT(@process_ids, ',');

    -- Associate with processes
    INSERT INTO manufacture (assembly_id, process_id)
    SELECT @assembly_id, process_id
    FROM @process_id_table;
END

/*SELECT * From assembly
SELECT * FROM manufacture*/


-- 5. ASSEMBLY ACCOUNT: Create a new account and associate it with the process, assembly, or department to which it is applicable.
DROP PROCEDURE IF EXISTS createAssemblyAccount;
GO
CREATE PROCEDURE createAssemblyAccount
    @account_no INT,
    @creation_date VARCHAR(100),
    @details_1 INT,
    @assembly_id INT
AS
BEGIN
    -- Insert data into account_assembly
    INSERT INTO account_assembly (account_no, creation_date, details_1)
    VALUES (@account_no, @creation_date, @details_1);

    -- Insert into record_assembly to associate account with assembly
    INSERT INTO record_assembly (account_no, assembly_id)
    VALUES (@account_no, @assembly_id);
END

/*
Select * From account_assembly
Select * From record_assembly*/


-- 5. ACCOUNT PROCESS: Create a new account and associate it with the process, assembly, or department to which it is applicable.
DROP PROCEDURE IF EXISTS createProcessAccount;
GO
CREATE PROCEDURE createProcessAccount
    @account_no INT,
    @creation_date VARCHAR(100),
    @details_3 VARCHAR(100),
    @process_id INT
AS
BEGIN
    -- Insert data into account_process
    INSERT INTO account_process (account_no, creation_date, details_3)
    VALUES (@account_no, @creation_date, @details_3);

    -- Insert into record_proc to associate account with process
    INSERT INTO record_process (account_no, process_id)
    VALUES (@account_no, @process_id);
END

/*Select * From account_process
Select * From record_process*/

-- 5. ACCOUNT DEPT: Create a new account and associate it with the process, assembly, or department to which it is applicable (10/day).
DROP PROCEDURE IF EXISTS createDepartmentAccount;
GO
CREATE PROCEDURE createDepartmentAccount
    @account_no INT,
    @creation_date VARCHAR(100),
    @details_2 VARCHAR(100),
    @dept_no INT
AS
BEGIN
    -- Insert data into account_dept
    INSERT INTO account_department (account_no, creation_date, details_2)
    VALUES (@account_no, @creation_date, @details_2);

    -- Insert into record_dept to associate account with department
    INSERT INTO record_department (account_no, dept_no)
    VALUES (@account_no, @dept_no);
END

/*Select * From account_department
Select * From record_department*/


-- 6. FIT: Enter a new job, given its job-no, assembly-id, process-id, and date the job commenced (50/day).
DROP PROCEDURE IF EXISTS insertJobFit;
GO
CREATE PROCEDURE insertJobFit
    @job_no INT,
    @assembly_id INT,
    @process_id INT,
    @date_start VARCHAR(100)
AS
BEGIN
    -- Insert data into job_fit
    INSERT INTO job_fit (job_no, date_start)
    VALUES (@job_no, @date_start);

    -- Insert or update the job number in the manufacture table
    MERGE manufacture AS target
    USING (SELECT @assembly_id AS assembly_id, @process_id AS process_id) AS source
    ON target.assembly_id = source.assembly_id AND target.process_id = source.process_id
    WHEN MATCHED THEN
        UPDATE SET target.job_no = @job_no
    WHEN NOT MATCHED THEN
        INSERT (assembly_id, process_id, job_no)
        VALUES (@assembly_id, @process_id, @job_no);
END

/*SELECT* From job_fit
SELECT * FROM manufacture*/


-- 6. PAINT: Enter a new job, given its job-no, assembly-id, process-id, and date the job commenced (50/day).
DROP PROCEDURE IF EXISTS insertJobPaint;
GO
CREATE PROCEDURE insertJobPaint
    @job_no INT,
    @assembly_id INT,
    @process_id INT,
    @date_start VARCHAR(100)
AS
BEGIN
    -- Insert data into job_paint
    INSERT INTO job_paint (job_no, date_start)
    VALUES (@job_no, @date_start);

    -- Insert or update the job number in the manufacture table
    MERGE manufacture AS target
    USING (SELECT @assembly_id AS assembly_id, @process_id AS process_id) AS source
    ON target.assembly_id = source.assembly_id AND target.process_id = source.process_id
    WHEN MATCHED THEN
        UPDATE SET target.job_no = @job_no
    WHEN NOT MATCHED THEN
        INSERT (assembly_id, process_id, job_no)
        VALUES (@assembly_id, @process_id, @job_no);
END

/*SELECT* From job_paint
SELECT * FROM manufacture*/


-- 6. CUT: Enter a new job, given its job-no, assembly-id, process-id, and date the job commenced (50/day).
DROP PROCEDURE IF EXISTS insertJobCut;
GO
CREATE PROCEDURE insertJobCut
    @job_no INT,
    @assembly_id INT,
    @process_id INT,
    @date_start VARCHAR
AS
BEGIN
    -- Insert data into job_cut
    INSERT INTO job_cut (job_no, date_start)
    VALUES (@job_no, @date_start);

    -- Insert or update the job number in the manufacture table
    MERGE manufacture AS target
    USING (SELECT @assembly_id AS assembly_id, @process_id AS process_id) AS source
    ON target.assembly_id = source.assembly_id AND target.process_id = source.process_id
    WHEN MATCHED THEN
        UPDATE SET target.job_no = @job_no
    WHEN NOT MATCHED THEN
        INSERT (assembly_id, process_id, job_no)
        VALUES (@assembly_id, @process_id, @job_no);
END

/*SELECT* From job_cut
SELECT * FROM manufacture*/


-- 7. FIT: At the completion of a job, enter the date its completed and the information relevant to the type (50/day)
-- Update a Fit_job upon completion
DROP PROCEDURE IF EXISTS completeFitJob;
GO
CREATE PROCEDURE completeFitJob
    @job_no INT,
    @date_end VARCHAR(100),
    @labor_time DECIMAL(10,2)
AS
BEGIN
    UPDATE job_fit
    SET date_end = @date_end, labor_time = @labor_time
    WHERE job_no = @job_no;
END;
GO

/*SELECT* FROM job_fit*/


-- 7. PAINT: At the completion of a job, enter the date its completed and the information relevant to the type (50/day)
-- Update a Paint_job upon completion
DROP PROCEDURE IF EXISTS completePaintJob;
GO
CREATE PROCEDURE completePaintJob
    @job_no INT,
    @date_end VARCHAR(100),
    @color VARCHAR(100),
    @volume INT,
    @labor_time DECIMAL(10,2)
AS
BEGIN
    UPDATE job_paint
    SET date_end = @date_end, color = @color, volume = @volume, labor_time = @labor_time
    WHERE job_no = @job_no;
END;
GO

/*SELECT* FROM job_paint*/


-- 7. CUT: At the completion of a job, enter the date its completed and the information relevant to the type (50/day)
-- Update a Cut_job upon completion
DROP PROCEDURE IF EXISTS completeCutJob;
GO
CREATE PROCEDURE completeCutJob
    @job_no INT,
    @date_end VARCHAR(100),
    @type_machine_used VARCHAR(100),
    @time_machine_used DECIMAL(10,2),
    @material_used VARCHAR(100),
    @labor_time DECIMAL(10,2)
AS
BEGIN
    UPDATE job_cut
    SET date_end = @date_end, type_machine_used = @type_machine_used, 
        time_machine_used = @time_machine_used, material_used = @material_used, 
        labor_time = @labor_time
    WHERE job_no = @job_no;
END;
GO

/*SELECT* FROM job_cut*/


-- 8. Enter a transaction-no and its sup-cost and update all the costs (details) of the affected accounts by adding sup-cost to their current values of details (50/day).
DROP PROCEDURE IF EXISTS enterTransactionAndUpdateAccounts;
GO
CREATE PROCEDURE enterTransactionAndUpdateAccounts
    @transaction_no INT,
    @sup_cost DECIMAL(10, 2),
    @assembly_account_no INT = NULL,  -- Optional parameters, NULL if not applicable
    @process_account_no INT = NULL,
    @dept_account_no INT = NULL
AS
BEGIN
    -- Insert data into transactions table
    INSERT INTO transactions (transaction_no, sup_cost)
    VALUES (@transaction_no, @sup_cost);

    -- Check if the assembly account number is provided
    IF @assembly_account_no IS NOT NULL
    BEGIN
        -- Update the details_1 in account_assembly
        UPDATE account_assembly
        SET details_1 = details_1 + @sup_cost
        WHERE account_no = @assembly_account_no;

        --Also fill up the update account (comes in handy for query 9)
        INSERT INTO updates(transaction_no, account_no_assembly)
        VALUES (@transaction_no, @assembly_account_no)
    END

    -- Check if the process account number is provided
    IF @process_account_no IS NOT NULL
    BEGIN
        -- Update the details_3 in account_process
        UPDATE account_process
        SET details_3 = details_3 + @sup_cost
        WHERE account_no = @process_account_no;
    END

    -- Check if the department account number is provided
    IF @dept_account_no IS NOT NULL
    BEGIN
        -- Update the details_2 in account_dept
        UPDATE account_department
        SET details_2 = details_2 + @sup_cost
        WHERE account_no = @dept_account_no;
    END
END
GO
/*
Select * From transactions

SELECT * From account_assembly
SELECT * From account_process
SELECT * From account_department
*/

-- 9. Retrieve the total cost incurred on an assembly-id (200/day).
DROP PROCEDURE IF EXISTS calculateTotalCostForAssembly;
GO
CREATE PROCEDURE calculateTotalCostForAssembly
    @assembly_id INT
AS
BEGIN
    DECLARE @totalCost DECIMAL(10, 2);

    SELECT @totalCost = SUM(t.sup_cost)
    FROM transactions t
    INNER JOIN updates u ON t.transaction_no = u.transaction_no
    INNER JOIN record_assembly ra ON u.account_no_assembly = ra.account_no
    WHERE ra.assembly_id = @assembly_id;

    -- Return the total cost
    SELECT @totalCost AS TotalCost;
END;

/*
-- Insert sample data into the assembly table
INSERT INTO assembly (assembly_id, date_ordered, assembly_details, customer_name)
VALUES
(1, '2023-01-01', 'Details for Assembly 1', 'Customer A'),
(2, '2023-01-02', 'Details for Assembly 2', 'Customer B'),
(3, '2023-01-03', 'Details for Assembly 3', 'Customer C'),
(4, '2023-01-04', 'Details for Assembly 4', 'Customer D'),
(5, '2023-01-05', 'Details for Assembly 5', 'Customer E'),
(6, '2023-01-06', 'Details for Assembly 6', 'Customer F'),
(7, '2023-01-07', 'Details for Assembly 7', 'Customer G'),
(8, '2023-01-08', 'Details for Assembly 8', 'Customer H'),
(9, '2023-01-09', 'Details for Assembly 9', 'Customer I'),
(10, '2023-01-10', 'Details for Assembly 10', 'Customer J');

-- Insert sample data into the account_assembly table with arbitrary details
INSERT INTO account_assembly (account_no, creation_date, details_1)
VALUES
(1, '2023-01-11', 1000),
(2, '2023-01-12', 2000),
(3, '2023-01-13', 3000),
(4, '2023-01-14', 4000),
(5, '2023-01-15', 5000),
(6, '2023-01-16', 6000),
(7, '2023-01-17', 7000),
(8, '2023-01-18', 8000),
(9, '2023-01-19', 9000),
(10, '2023-01-20', 10000);

-- Insert sample data into the record_assembly table
-- Assuming each account_no in account_assembly corresponds to an assembly_id
INSERT INTO record_assembly (account_no, assembly_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- Insert sample data into the transactions table with increasing supply costs
INSERT INTO transactions (transaction_no, sup_cost)
VALUES
(1, 100),
(2, 200),
(3, 300),
(4, 400),
(5, 500),
(6, 600),
(7, 700),
(8, 800),
(9, 900),
(10, 1000);

-- Insert sample data into the updates table linking transactions to account_assembly
-- Assuming that each transaction is linked to a corresponding account_assembly
INSERT INTO updates (transaction_no, account_no_assembly, account_no_process, account_no_department)
VALUES
(1, 1, NULL, NULL),
(2, 2, NULL, NULL),
(3, 3, NULL, NULL),
(4, 4, NULL, NULL),
(5, 5, NULL, NULL),
(6, 6, NULL, NULL),
(7, 7, NULL, NULL),
(8, 8, NULL, NULL),
(9, 9, NULL, NULL),
(10, 10, NULL, NULL);

*/


-- 10. Retrieve the total labor time within a department for jobs completed in the department during a given date (20/day).

DROP PROCEDURE IF EXISTS TotalLaborTimeInDepartment_WithIndex;
GO
CREATE PROCEDURE TotalLaborTimeInDepartment_WithIndex
    @dept_no INT,
    @given_date VARCHAR(100),
    @total_labor_time INT OUTPUT
AS
BEGIN
    SELECT @total_labor_time = SUM(labor_time)
    FROM (
        SELECT labor_time FROM job_fit
        WHERE job_no IN (SELECT job_no FROM manufacture WHERE process_id IN (SELECT process_id FROM process_fit WHERE dept_no = @dept_no))
          AND date_end = @given_date
        UNION ALL
        SELECT labor_time FROM job_cut
        WHERE job_no IN (SELECT job_no FROM manufacture WHERE process_id IN (SELECT process_id FROM process_cut WHERE dept_no = @dept_no))
          AND date_end = @given_date
        UNION ALL
        SELECT labor_time FROM job_paint
        WHERE job_no IN (SELECT job_no FROM manufacture WHERE process_id IN (SELECT process_id FROM process_paint WHERE dept_no = @dept_no))
          AND date_end = @given_date
    ) AS Jobs;
END;

/*
--- Insert sample data into process_fit table
INSERT INTO process_fit (process_id, process_data, dept_no, fit_type)
VALUES
(1, 'Fit Process 1', 1, 'Type X'),
(2, 'Fit Process 2', 2, 'Type Y');

-- Insert sample data into process_cut table
INSERT INTO process_cut (process_id, process_data, dept_no, cutting_type, machine_type)
VALUES
(3, 'Cut Process 1', 1, 'Type C', 'Cutter'),
(4, 'Cut Process 2', 2, 'Type D', 'Saw');

-- Insert sample data into process_paint table
INSERT INTO process_paint (process_id, process_data, dept_no, paint_type, painting_method)
VALUES
(5, 'Paint Process 1', 1, 'Type A', 'Spray'),
(6, 'Paint Process 2', 2, 'Type B', 'Dip');

-- Insert sample data into manufacture table
INSERT INTO manufacture (assembly_id, process_id, job_no)
VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6);

-- Insert sample data into job_fit table
INSERT INTO job_fit (job_no, date_start, date_end, labor_time)
VALUES
(1, '2023-01-01', '2023-01-10', 8),
(2, '2023-01-01', '2023-01-10', 10);

-- Insert sample data into job_cut table
INSERT INTO job_cut (job_no, date_start, date_end, labor_time, type_machine_used, time_machine_used, material_used)
VALUES
(3, '2023-01-01', '2023-01-10', 7,NUll,NUll,NUll),
(4, '2023-01-01', '2023-01-10', 5,NUll,NUll,NUll);

-- Insert sample data into job_paint table
INSERT INTO job_paint (job_no, date_start, date_end, labor_time)
VALUES
(5, '2023-01-01', '2023-01-10', 6),
(6, '2023-01-01', '2023-01-10', 9);

DECLARE @TotalLaborTime INT;

EXEC TotalLaborTimeInDepartment_WithIndex 
    @dept_no = 5, 
    @given_date = '2023-01-10', 
    @total_labor_time = @TotalLaborTime OUTPUT;

SELECT @TotalLaborTime AS TotalLaborTime; -- Should return 21
*/



-- 11. Retrieve the processes through which a given assembly-id has passed so far (in date commenced order) and the department responsible for each process (100/day).
DROP PROCEDURE IF EXISTS ProcessesForAssembly_WithIndex;
GO

CREATE PROCEDURE ProcessesForAssembly_WithIndex
    @givenAssemblyId INT
AS
BEGIN
    SELECT 
        m.assembly_id,
        m.process_id,
        COALESCE(pf.process_data, pp.process_data, pc.process_data) AS process_data,
        COALESCE(pf.dept_no, pp.dept_no, pc.dept_no) AS dept_no,
        d.dept_data AS department_responsible
    FROM 
        manufacture m
        LEFT JOIN process_fit pf ON m.process_id = pf.process_id
        LEFT JOIN process_paint pp ON m.process_id = pp.process_id
        LEFT JOIN process_cut pc ON m.process_id = pc.process_id
        LEFT JOIN department d ON d.dept_no = COALESCE(pf.dept_no, pp.dept_no, pc.dept_no)
    WHERE 
        m.assembly_id = @givenAssemblyId
    ORDER BY 
        COALESCE(pf.process_data, pp.process_data, pc.process_data); -- Assuming process_data has date info
END;
/*
-- Insert sample data into department table
INSERT INTO department (dept_no, dept_data) VALUES
(1, 'Cutting'),
(2, 'Fitting'),
(3, 'Painting');

-- Insert sample data into process_fit table
INSERT INTO process_fit (process_id, process_data, dept_no, fit_type) VALUES
(101, 'Fitting A1', 2, 'Type F1'),
(102, 'Fitting A2', 2, 'Type F2'),
(103, 'Fitting A3', 2, 'Type F3');

-- Insert sample data into process_paint table
INSERT INTO process_paint (process_id, process_data, dept_no, paint_type, painting_method) VALUES
(201, 'Painting A1', 3, 'Type P1', 'Method P1'),
(202, 'Painting A2', 3, 'Type P2', 'Method P2'),
(203, 'Painting A3', 3, 'Type P3', 'Method P3');

-- Insert sample data into process_cut table
INSERT INTO process_cut (process_id, process_data, dept_no, cutting_type, machine_type) VALUES
(301, 'Cutting A1', 1, 'Type C1', 'Machine C1'),
(302, 'Cutting A2', 1, 'Type C2', 'Machine C2'),
(303, 'Cutting A3', 1, 'Type C3', 'Machine C3');

-- Insert sample data into manufacture table
INSERT INTO manufacture (assembly_id, process_id, job_no) VALUES
(1, 101, 1001),
(1, 201, 1002),
(1, 301, 1003),
(2, 102, 1004),
(2, 202, 1005),
(2, 302, 1006),
(3, 103, 1007),
(3, 203, 1008),
(3, 303, 1009);
*/
/*
Test Case for Assembly ID 1: Expected to list processes 101, 201, and 301 in order based on process_data.
Test Case for Assembly ID 2: Expected to list processes 102, 202, and 302 in order based on process_data.
Test Case for Assembly ID 3: Expected to list processes 103, 203, and 303 in order based on process_data.
*/


-- 12. Retrieve the customers (in name order) whose category is in a given range (100/day).
DROP PROCEDURE IF EXISTS retrieveCustomerByRange;
GO
CREATE PROCEDURE retrieveCustomerByRange
    @category_start VARCHAR(100),
    @category_end VARCHAR(100)
AS
BEGIN
    SELECT name_customer, address_customer, category
    FROM customer
    WHERE category BETWEEN @category_start AND @category_end
    ORDER BY name_customer;
END;


/*
-- Insert sample data into customer table
INSERT INTO customer (name_customer, address_customer, category) VALUES
('Alice Smith', '123 Main St', 1),
('Bob Johnson', '456 Oak St', 2),
('Charlie Brown', '789 Pine St', 3),
('Diana Prince', '321 Maple St', 2),
('Edward Elric', '654 Palm St', 1),
('Fiona Gallagher', '987 Cedar St', 3);
SELECT * from customer
*/


-- 13. Delete all cut-jobs whose job-no is in a given range (1/month).
DROP PROCEDURE IF EXISTS deleteCutJobsInRange;
GO
CREATE PROCEDURE deleteCutJobsInRange
    @start_job_no INT,
    @end_job_no INT
AS
BEGIN
    DELETE FROM job_cut
    WHERE job_no BETWEEN @start_job_no AND @end_job_no;
END;

/*
-- Populate the job_cut table with 10 entries
INSERT INTO job_cut (job_no, date_start, date_end, labor_time, type_machine_used, time_machine_used, material_used)
VALUES
(1, '2023-01-01', '2023-01-02', 5, 'Cutter A', '1 hour', 'Steel'),
(2, '2023-01-02', '2023-01-03', 6, 'Cutter B', '1.5 hours', 'Aluminum'),
(3, '2023-01-03', '2023-01-04', 4, 'Cutter C', '2 hours', 'Copper'),
(4, '2023-01-04', '2023-01-05', 8, 'Cutter D', '2.5 hours', 'Titanium'),
(5, '2023-01-05', '2023-01-06', 3, 'Cutter E', '3 hours', 'Carbon Steel'),
(6, '2023-01-06', '2023-01-07', 7, 'Cutter F', '3.5 hours', 'Stainless Steel'),
(7, '2023-01-07', '2023-01-08', 9, 'Cutter G', '4 hours', 'Brass'),
(8, '2023-01-08', '2023-01-09', 5, 'Cutter H', '4.5 hours', 'Bronze'),
(9, '2023-01-09', '2023-01-10', 6, 'Cutter I', '5 hours', 'Iron'),
(10, '2023-01-10', '2023-01-11', 8, 'Cutter J', '5.5 hours', 'Nickel');

select * From job_cut
*/


-- 14. Change the color of a given paint job (1/week).
DROP PROCEDURE IF EXISTS updatePaintJobColor;
GO
CREATE PROCEDURE updatePaintJobColor
    @job_no INT,
    @new_color VARCHAR(100)
AS
BEGIN
    UPDATE job_paint
    SET color = @new_color
    WHERE job_no = @job_no;
END;

/*
-- Populate the job_paint table with 10 entries
INSERT INTO job_paint (job_no, date_start, date_end, labor_time, color, volume)
VALUES
(1, '2023-01-12', '2023-01-13', 9, 'Red', 100),
(2, '2023-01-13', '2023-01-14', 11, 'Blue', 120),
(3, '2023-01-14', '2023-01-15', 7, 'Green', 140),
(4, '2023-01-15', '2023-01-16', 5, 'Yellow', 160),
(5, '2023-01-16', '2023-01-17', 8, 'Black', 180),
(6, '2023-01-17', '2023-01-18', 10, 'White', 200),
(7, '2023-01-18', '2023-01-19', 6, 'Orange', 220),
(8, '2023-01-19', '2023-01-20', 12, 'Purple', 240),
(9, '2023-01-20', '2023-01-21', 4, 'Pink', 260),
(10, '2023-01-21', '2023-01-22', 13, 'Gray', 280);

SELECT job_no, color From job_paint where job_no = 4
*/