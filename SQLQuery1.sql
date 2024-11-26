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

create table Instructror 
(
 Instructor_ID int primary key identity(1,1),
 Ins_Fname varchar(30),
 Ins_Lname varchar(30),
 Email varchar(30),
 Username varchar(30),
 Ins_password varchar (30)
)
create table Course 
( 
    Course_Id int primary key identity (1,1),
	Cur_Name varchar(30),
	descriptions varchar(100),
	Max_degree int ,
	Min_dgree int,
	Ins_Id int foreign key references  Instructror (Instructor_ID)
)

CREATE TABLE Student 
(
    ID INT PRIMARY KEY IDENTITY(1,1), -- Auto-incrementing primary key
    FirstName NVARCHAR(50) NOT NULL, -- First name of the student
    LastName NVARCHAR(50) NOT NULL,  -- Last name of the student
    Email NVARCHAR(100) NOT NULL UNIQUE, -- Unique email address
    Password NVARCHAR(100) NOT NULL,  -- Password for the student
    Username NVARCHAR(50) NOT NULL UNIQUE -- Unique username
); 
create table Exam 
(
 Exam_id int primary key ,
 StartTime date,
 End_time date,
 Total  int ,
 exam_type varchar(40),
 Course_id int foreign key references Course(Course_Id)
 )

 create table Branch 
 (
  Branch_Id int primary key ,
  Branch_name varchar(30),
 )
 create table Track 
 (
  track_id int primary key identity(1,1),
  track_name varchar(40)
)

create table T_F_Question 
(
 ID int primary key Identity (1,1),
 content varchar(150),
 correct_Answer varchar(40),
 Option1 varchar(4),
 Option2 varchar(5),
 Dgree int 
)

create table MCQ_Question 
( 
 ID  int primary key identity (1,1),
 Content varchar(150),
 Correct_Answer varchar(100),
 Option1 varchar(100),
 Option2 varchar(100),
 Option3 varchar(100),
 Option4 varchar(100),
 Degree int 
 )

 CREATE TABLE StudentAnswers (
    ExamID INT NOT NULL,
    StudentID INT NOT NULL,
    Answer TEXT,
    PRIMARY KEY (ExamID, StudentID)
);

create table Exam_Question 
(
ID int primary key identity(1,1),
Exam_Id int foreign key references Exam(Exam_id),
MCQ_id int foreign key references MCQ_Question(ID),
T_F_ID int foreign key references T_F_Question(ID),
Student_Answer Text 
)

Create table Student_Exam_Result 
(
ID int primary key identity(1,1),
Stu_ID int foreign key references Student(ID),
Cour_ID int foreign key references Course(Course_Id)
)
create table Intake 
(
intake_ID int primary key identity (1,1),
intake_name varchar(40)
)
