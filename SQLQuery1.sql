create database Examinationsystem
use Examinationsystem
create schema Examinationsystem

CREATE TABLE Student 
(
    ID INT PRIMARY KEY IDENTITY(1,1), -- Auto-incrementing primary key
    FirstName NVARCHAR(50) NOT NULL, -- First name of the student
    LastName NVARCHAR(50) NOT NULL,  -- Last name of the student
    Email NVARCHAR(100) NOT NULL UNIQUE, -- Unique email address
    Password NVARCHAR(100) NOT NULL,  -- Password for the student
    Username NVARCHAR(50) NOT NULL UNIQUE -- Unique username
); 