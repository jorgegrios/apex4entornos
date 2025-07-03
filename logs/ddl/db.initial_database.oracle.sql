-- liquibase formatted sql

-- changeset oracle:1750934584336-1 splitStatements:true
CREATE TABLE REGIONS (REGION_ID NUMBER CONSTRAINT REGION_ID_NN NOT NULL, REGION_NAME VARCHAR2(25 BYTE), CONSTRAINT REG_ID_PK PRIMARY KEY (REGION_ID));
COMMENT ON TABLE REGIONS IS 'Regions table that contains region numbers and names. references with the Countries table.';
COMMENT ON COLUMN REGIONS.REGION_ID IS 'Primary key of regions table.';
COMMENT ON COLUMN REGIONS.REGION_NAME IS 'Names of regions. Locations are in the countries of these regions.';

-- changeset oracle:1750934584336-2 splitStatements:true
CREATE TABLE COUNTRIES (COUNTRY_ID CHAR(2 BYTE) CONSTRAINT COUNTRY_ID_NN NOT NULL, COUNTRY_NAME VARCHAR2(60 BYTE), REGION_ID NUMBER, CONSTRAINT COUNTRY_C_ID_PK PRIMARY KEY (COUNTRY_ID));
COMMENT ON TABLE COUNTRIES IS 'country table. References with locations table.';
COMMENT ON COLUMN COUNTRIES.COUNTRY_ID IS 'Primary key of countries table.';
COMMENT ON COLUMN COUNTRIES.COUNTRY_NAME IS 'Country name';
COMMENT ON COLUMN COUNTRIES.REGION_ID IS 'Region ID for the country. Foreign key to region_id column in the departments table.';

-- changeset oracle:1750934584336-3 splitStatements:true
CREATE TABLE LOCATIONS (LOCATION_ID NUMBER(4, 0) NOT NULL, STREET_ADDRESS VARCHAR2(40 BYTE), POSTAL_CODE VARCHAR2(12 BYTE), CITY VARCHAR2(30 BYTE) CONSTRAINT LOC_CITY_NN NOT NULL, STATE_PROVINCE VARCHAR2(25 BYTE), COUNTRY_ID CHAR(2 BYTE), CONSTRAINT LOC_ID_PK PRIMARY KEY (LOCATION_ID));
COMMENT ON TABLE LOCATIONS IS 'Locations table that contains specific address of a specific office,
warehouse, and/or production site of a company. Does not store addresses /
locations of customers. references with the departments and countries tables.';
COMMENT ON COLUMN LOCATIONS.LOCATION_ID IS 'Primary key of locations table';
COMMENT ON COLUMN LOCATIONS.STREET_ADDRESS IS 'Street address of an office, warehouse, or production site of a company.
Contains building number and street name';
COMMENT ON COLUMN LOCATIONS.POSTAL_CODE IS 'Postal code of the location of an office, warehouse, or production site 
of a company.';
COMMENT ON COLUMN LOCATIONS.CITY IS 'A not null column that shows city where an office, warehouse, or 
production site of a company is located.';
COMMENT ON COLUMN LOCATIONS.STATE_PROVINCE IS 'State or Province where an office, warehouse, or production site of a 
company is located.';
COMMENT ON COLUMN LOCATIONS.COUNTRY_ID IS 'Country where an office, warehouse, or production site of a company is
located. Foreign key to country_id column of the countries table.';

-- changeset oracle:1750934584336-4 splitStatements:true
CREATE TABLE DEPARTMENTS (DEPARTMENT_ID NUMBER(4, 0) NOT NULL, DEPARTMENT_NAME VARCHAR2(30 BYTE) CONSTRAINT DEPT_NAME_NN NOT NULL, MANAGER_ID NUMBER(6, 0), LOCATION_ID NUMBER(4, 0), CONSTRAINT DEPT_ID_PK PRIMARY KEY (DEPARTMENT_ID));
COMMENT ON TABLE DEPARTMENTS IS 'Departments table that shows details of departments where employees 
work. references with locations, employees, and job_history tables.';
COMMENT ON COLUMN DEPARTMENTS.DEPARTMENT_ID IS 'Primary key column of departments table.';
COMMENT ON COLUMN DEPARTMENTS.DEPARTMENT_NAME IS 'A not null column that shows name of a department. Administration, 
Marketing, Purchasing, Human Resources, Shipping, IT, Executive, Public 
Relations, Sales, Finance, and Accounting.';
COMMENT ON COLUMN DEPARTMENTS.MANAGER_ID IS 'Manager_id of a department. Foreign key to employee_id column of employees table. The manager_id column of the employee table references this column.';
COMMENT ON COLUMN DEPARTMENTS.LOCATION_ID IS 'Location id where a department is located. Foreign key to location_id column of locations table.';

-- changeset oracle:1750934584336-5 splitStatements:true
CREATE TABLE JOBS (JOB_ID VARCHAR2(10 BYTE) NOT NULL, JOB_TITLE VARCHAR2(35 BYTE) CONSTRAINT JOB_TITLE_NN NOT NULL, MIN_SALARY NUMBER(6, 0), MAX_SALARY NUMBER(6, 0), CONSTRAINT JOB_ID_PK PRIMARY KEY (JOB_ID));
COMMENT ON TABLE JOBS IS 'jobs table with job titles and salary ranges.
References with employees and job_history table.';
COMMENT ON COLUMN JOBS.JOB_ID IS 'Primary key of jobs table.';
COMMENT ON COLUMN JOBS.JOB_TITLE IS 'A not null column that shows job title, e.g. AD_VP, FI_ACCOUNTANT';
COMMENT ON COLUMN JOBS.MIN_SALARY IS 'Minimum salary for a job title.';
COMMENT ON COLUMN JOBS.MAX_SALARY IS 'Maximum salary for a job title';

-- changeset oracle:1750934584336-6 splitStatements:true
CREATE TABLE EMPLOYEES (EMPLOYEE_ID NUMBER(6, 0) NOT NULL, FIRST_NAME VARCHAR2(20 BYTE), LAST_NAME VARCHAR2(25 BYTE) CONSTRAINT EMP_LAST_NAME_NN NOT NULL, EMAIL VARCHAR2(25 BYTE) CONSTRAINT EMP_EMAIL_NN NOT NULL, PHONE_NUMBER VARCHAR2(20 BYTE), HIRE_DATE date CONSTRAINT EMP_HIRE_DATE_NN NOT NULL, JOB_ID VARCHAR2(10 BYTE) CONSTRAINT EMP_JOB_NN NOT NULL, SALARY NUMBER(8, 2), COMMISSION_PCT NUMBER(2, 2), MANAGER_ID NUMBER(6, 0), DEPARTMENT_ID NUMBER(4, 0), CONSTRAINT EMP_EMP_ID_PK PRIMARY KEY (EMPLOYEE_ID));
COMMENT ON TABLE EMPLOYEES IS 'employees table. References with departments,
jobs, job_history tables. Contains a self reference.';
COMMENT ON COLUMN EMPLOYEES.EMPLOYEE_ID IS 'Primary key of employees table.';
COMMENT ON COLUMN EMPLOYEES.FIRST_NAME IS 'First name of the employee. A not null column.';
COMMENT ON COLUMN EMPLOYEES.LAST_NAME IS 'Last name of the employee. A not null column.';
COMMENT ON COLUMN EMPLOYEES.EMAIL IS 'Email id of the employee';
COMMENT ON COLUMN EMPLOYEES.PHONE_NUMBER IS 'Phone number of the employee; includes country code and area code';
COMMENT ON COLUMN EMPLOYEES.HIRE_DATE IS 'Date when the employee started on this job. A not null column.';
COMMENT ON COLUMN EMPLOYEES.JOB_ID IS 'Current job of the employee; foreign key to job_id column of the 
jobs table. A not null column.';
COMMENT ON COLUMN EMPLOYEES.SALARY IS 'Monthly salary of the employee. Must be greater 
than zero (enforced by constraint emp_salary_min)';
COMMENT ON COLUMN EMPLOYEES.COMMISSION_PCT IS 'Commission percentage of the employee; Only employees in sales 
department elgible for commission percentage';
COMMENT ON COLUMN EMPLOYEES.MANAGER_ID IS 'Manager id of the employee; has same domain as manager_id in 
departments table. Foreign key to employee_id column of employees table. 
(useful for reflexive joins and CONNECT BY query)';
COMMENT ON COLUMN EMPLOYEES.DEPARTMENT_ID IS 'Department id where employee works; foreign key to department_id 
column of the departments table';

-- changeset oracle:1750934584336-7
CREATE SEQUENCE EMPLOYEES_SEQ START WITH 207 INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999999999999999999999999 NOCACHE NOORDER;

-- changeset oracle:1750934584336-8 splitStatements:true
CREATE TABLE JOB_HISTORY (EMPLOYEE_ID NUMBER(6, 0) CONSTRAINT JHIST_EMPLOYEE_NN NOT NULL, START_DATE date CONSTRAINT JHIST_START_DATE_NN NOT NULL, END_DATE date CONSTRAINT JHIST_END_DATE_NN NOT NULL, JOB_ID VARCHAR2(10 BYTE) CONSTRAINT JHIST_JOB_NN NOT NULL, DEPARTMENT_ID NUMBER(4, 0), CONSTRAINT JHIST_EMP_ID_ST_DATE_PK PRIMARY KEY (EMPLOYEE_ID, START_DATE));
COMMENT ON TABLE JOB_HISTORY IS 'Table that stores job history of the employees. If an employee 
changes departments within the job or changes jobs within the department, 
new rows get inserted into this table with old job information of the 
employee. Contains a complex primary key: employee_id+start_date.
References with jobs, employees, and departments tables.';
COMMENT ON COLUMN JOB_HISTORY.EMPLOYEE_ID IS 'A not null column in the complex primary key employee_id+start_date. 
Foreign key to employee_id column of the employee table';
COMMENT ON COLUMN JOB_HISTORY.START_DATE IS 'A not null column in the complex primary key employee_id+start_date. 
Must be less than the end_date of the job_history table. (enforced by 
constraint jhist_date_interval)';
COMMENT ON COLUMN JOB_HISTORY.END_DATE IS 'Last day of the employee in this job role. A not null column. Must be 
greater than the start_date of the job_history table. 
(enforced by constraint jhist_date_interval)';
COMMENT ON COLUMN JOB_HISTORY.JOB_ID IS 'Job role in which the employee worked in the past; foreign key to 
job_id column in the jobs table. A not null column.';
COMMENT ON COLUMN JOB_HISTORY.DEPARTMENT_ID IS 'Department id in which the employee worked in the past; foreign key to deparment_id column in the departments table';

-- changeset oracle:1750934584336-9
CREATE OR REPLACE FORCE VIEW "EMP_DETAILS_VIEW" ("EMPLOYEE_ID", "JOB_ID", "MANAGER_ID", "DEPARTMENT_ID", "LOCATION_ID", "COUNTRY_ID", "FIRST_NAME", "LAST_NAME", "SALARY", "COMMISSION_PCT", "DEPARTMENT_NAME", "JOB_TITLE", "CITY", "STATE_PROVINCE", "COUNTRY_NAME", "REGION_NAME") AS SELECT
  e.employee_id, 
  e.job_id, 
  e.manager_id, 
  e.department_id,
  d.location_id,
  l.country_id,
  e.first_name,
  e.last_name,
  e.salary,
  e.commission_pct,
  d.department_name,
  j.job_title,
  l.city,
  l.state_province,
  c.country_name,
  r.region_name
FROM
  employees e,
  departments d,
  jobs j,
  locations l,
  countries c,
  regions r
WHERE e.department_id = d.department_id
  AND d.location_id = l.location_id
  AND l.country_id = c.country_id
  AND c.region_id = r.region_id
  AND j.job_id = e.job_id 
WITH READ ONLY;

-- changeset oracle:1750934584336-10
CREATE SEQUENCE DEPARTMENTS_SEQ START WITH 280 INCREMENT BY 10 MINVALUE 1 MAXVALUE 9990 NOCACHE NOORDER;

-- changeset oracle:1750934584336-11
CREATE SEQUENCE LOCATIONS_SEQ START WITH 3300 INCREMENT BY 100 MINVALUE 1 MAXVALUE 9900 NOCACHE NOORDER;

-- changeset oracle:1750934584336-12
CREATE TABLE PRODUCTOS (ID NUMBER GENERATED BY DEFAULT AS IDENTITY NOT NULL, NOMBRE VARCHAR2(100 BYTE), PRECIO NUMBER(10, 2), CONSTRAINT SYS_C0013490 PRIMARY KEY (ID));

-- changeset oracle:1750934584336-13
CREATE UNIQUE INDEX EMP_EMAIL_UK ON EMPLOYEES(EMAIL);

-- changeset oracle:1750934584336-14
ALTER TABLE EMPLOYEES ADD CONSTRAINT EMP_EMAIL_UK UNIQUE (EMAIL) USING INDEX EMP_EMAIL_UK;

-- changeset oracle:1750934584336-15
CREATE INDEX DEPT_LOCATION_IX ON DEPARTMENTS(LOCATION_ID);

-- changeset oracle:1750934584336-16
CREATE INDEX EMP_DEPARTMENT_IX ON EMPLOYEES(DEPARTMENT_ID);

-- changeset oracle:1750934584336-17
CREATE INDEX EMP_JOB_IX ON EMPLOYEES(JOB_ID);

-- changeset oracle:1750934584336-18
CREATE INDEX EMP_MANAGER_IX ON EMPLOYEES(MANAGER_ID);

-- changeset oracle:1750934584336-19
CREATE INDEX EMP_NAME_IX ON EMPLOYEES(LAST_NAME, FIRST_NAME);

-- changeset oracle:1750934584336-20
CREATE INDEX JHIST_DEPARTMENT_IX ON JOB_HISTORY(DEPARTMENT_ID);

-- changeset oracle:1750934584336-21
CREATE INDEX JHIST_EMPLOYEE_IX ON JOB_HISTORY(EMPLOYEE_ID);

-- changeset oracle:1750934584336-22
CREATE INDEX JHIST_JOB_IX ON JOB_HISTORY(JOB_ID);

-- changeset oracle:1750934584336-23
CREATE INDEX LOC_CITY_IX ON LOCATIONS(CITY);

-- changeset oracle:1750934584336-24
CREATE INDEX LOC_COUNTRY_IX ON LOCATIONS(COUNTRY_ID);

-- changeset oracle:1750934584336-25
CREATE INDEX LOC_STATE_PROVINCE_IX ON LOCATIONS(STATE_PROVINCE);

-- changeset oracle:1750934584336-26
ALTER TABLE COUNTRIES ADD CONSTRAINT COUNTR_REG_FK FOREIGN KEY (REGION_ID) REFERENCES REGIONS (REGION_ID);

-- changeset oracle:1750934584336-27
ALTER TABLE DEPARTMENTS ADD CONSTRAINT DEPT_LOC_FK FOREIGN KEY (LOCATION_ID) REFERENCES LOCATIONS (LOCATION_ID);

-- changeset oracle:1750934584336-28
ALTER TABLE DEPARTMENTS ADD CONSTRAINT DEPT_MGR_FK FOREIGN KEY (MANAGER_ID) REFERENCES EMPLOYEES (EMPLOYEE_ID);

-- changeset oracle:1750934584336-29
ALTER TABLE EMPLOYEES ADD CONSTRAINT EMP_DEPT_FK FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENTS (DEPARTMENT_ID);

-- changeset oracle:1750934584336-30
ALTER TABLE EMPLOYEES ADD CONSTRAINT EMP_JOB_FK FOREIGN KEY (JOB_ID) REFERENCES JOBS (JOB_ID);

-- changeset oracle:1750934584336-31
ALTER TABLE EMPLOYEES ADD CONSTRAINT EMP_MANAGER_FK FOREIGN KEY (MANAGER_ID) REFERENCES EMPLOYEES (EMPLOYEE_ID);

-- changeset oracle:1750934584336-32
ALTER TABLE JOB_HISTORY ADD CONSTRAINT JHIST_DEPT_FK FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENTS (DEPARTMENT_ID);

-- changeset oracle:1750934584336-33
ALTER TABLE JOB_HISTORY ADD CONSTRAINT JHIST_EMP_FK FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES (EMPLOYEE_ID);

-- changeset oracle:1750934584336-34
ALTER TABLE JOB_HISTORY ADD CONSTRAINT JHIST_JOB_FK FOREIGN KEY (JOB_ID) REFERENCES JOBS (JOB_ID);

-- changeset oracle:1750934584336-35
ALTER TABLE LOCATIONS ADD CONSTRAINT LOC_C_ID_FK FOREIGN KEY (COUNTRY_ID) REFERENCES COUNTRIES (COUNTRY_ID);

