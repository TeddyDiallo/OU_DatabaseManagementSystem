DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS manufacture;
DROP TABLE IF EXISTS assembly;
DROP TABLE IF EXISTS job_fit;
DROP TABLE IF EXISTS job_paint;
DROP TABLE IF EXISTS job_cut; 
DROP TABLE IF EXISTS process_fit;
DROP TABLE IF EXISTS process_paint;
DROP TABLE IF EXISTS Process_cut;
DROP TABLE IF EXISTS account_assembly;
DROP TABLE IF EXISTS account_process;
DROP TABLE IF EXISTS account_department;
DROP TABLE IF EXISTS record_asssembly;
DROP TABLE IF EXISTS record_process;
DROP TABLE IF EXISTS record_department;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS updates;
DROP TABLE IF EXISTS creates;



CREATE TABLE customer (
    name_customer VARCHAR(100)  PRIMARY KEY,
    address_customer VARCHAR(100),
    category INT,  
    CONSTRAINT CHK_category_type CHECK (category IN (1,2,3,4,5))
);
CREATE NONCLUSTERED INDEX idx_customer_category ON customer(category);


CREATE TABLE department (
    dept_no INT PRIMARY KEY, 
    dept_data VARCHAR(100),
);


CREATE TABLE manufacture (
    assembly_id INT,
    process_id INT,
    job_no INT,
    PRIMARY KEY (assembly_id, process_id),
);
CREATE NONCLUSTERED INDEX idx_manufacture_assembly_id ON manufacture (assembly_id);


CREATE TABLE assembly (
    assembly_id INT  PRIMARY KEY,
    date_ordered VARCHAR(100), 
    assembly_details VARCHAR(100),
    customer_name VARCHAR(100),
);


CREATE TABLE job_fit (
    job_no INT PRIMARY KEY,
    date_start VARCHAR(100), 
    date_end VARCHAR(100),
    labor_time INT, 
);

CREATE TABLE job_paint (
    job_no INT PRIMARY KEY,
    date_start VARCHAR(100), 
    date_end VARCHAR(100),
    labor_time INT,
    color VARCHAR(100), 
    volume INT, 
);

CREATE TABLE job_cut (
    job_no INT PRIMARY KEY,
    date_start VARCHAR(100), 
    date_end VARCHAR(100),
    labor_time INT,
    type_machine_used VARCHAR(100), 
    time_machine_used VARCHAR(100),
    material_used VARCHAR(100), 
); 

CREATE TABLE process_fit(
    process_id INT PRIMARY KEY, 
    process_data VARCHAR(100), 
    dept_no INT,
    fit_type VARCHAR(100),
);

CREATE TABLE process_paint (
    process_id INT PRIMARY KEY, 
    process_data VARCHAR(100), 
    dept_no INT,
    paint_type VARCHAR(100), 
    painting_method VARCHAR(100),
);

CREATE TABLE process_cut (
    process_id INT PRIMARY KEY, 
    process_data VARCHAR(100), 
    dept_no INT,
    cutting_type VARCHAR(100), 
    machine_type VARCHAR(100),
);

CREATE TABLE account_assembly (
    account_no INT PRIMARY KEY NONCLUSTERED,
    creation_date VARCHAR(100),
    details_1 INT,
);
CREATE CLUSTERED INDEX idx_account_assembly ON account_assembly(account_no);

CREATE TABLE record_assembly (
    account_no INT PRIMARY KEY, 
    assembly_id INT,
);
CREATE NONCLUSTERED INDEX idx_record_assembly ON record_assembly(assembly_id);

CREATE TABLE account_process (
    account_no INT PRIMARY KEY NONCLUSTERED,
    creation_date VARCHAR(100), 
    details_3 INT,
);
CREATE CLUSTERED INDEX idx_account_process ON account_process(account_no);

CREATE TABLE record_process (
    account_no INT PRIMARY KEY,
    process_id INT,
);

CREATE TABLE account_department (
    account_no INT PRIMARY KEY NONCLUSTERED,
    creation_date VARCHAR(100), 
    details_2 INT,
);
CREATE CLUSTERED INDEX idx_account_department ON account_department(account_no);

CREATE TABLE record_department (
    account_no INT PRIMARY KEY,
    dept_no INT,
);

CREATE TABLE transactions (
    transaction_no INT PRIMARY KEY, 
    sup_cost INT,
);

CREATE TABLE updates (
    transaction_no INT PRIMARY KEY, 
    account_no_assembly INT,
    account_no_process INT,
    account_no_department INT,
);

CREATE TABLE creates (
    job_no INT PRIMARY KEY, 
    transaction_no INT,
);
