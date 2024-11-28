create database Examinationsystem
use Examinationsystem
create schema Examinationsystem
ALTER schema Examinationsystem transfer Student
ALTER schema Examinationsystem transfer [dbo].[MCQ_Question]
ALTER schema Examinationsystem transfer [dbo].[Intake]
ALTER schema Examinationsystem transfer [dbo].[Instructor]
ALTER schema Examinationsystem transfer [dbo].[Exam_Question]
ALTER schema Examinationsystem transfer [dbo].[Exam]
ALTER schema Examinationsystem transfer [dbo].[Course]
ALTER schema Examinationsystem transfer [dbo].[Branch]
ALTER schema Examinationsystem transfer [dbo].[Student_Exam_Result]
ALTER schema Examinationsystem transfer [dbo].[StudentAnswers]
ALTER schema Examinationsystem transfer [dbo].[T_F_Question]
ALTER schema Examinationsystem transfer [dbo].[Track]
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
alter table Instructror 
add constraint c1 unique (Email)

ALTER TABLE Instructror
ADD CONSTRAINT check_password_not_empty CHECK (Ins_password IS NOT NULL AND Ins_password != '');

create table Course 
( 
    Course_Id int primary key identity (1,1),
	Cur_Name varchar(30),
	descriptions varchar(100),
	Max_degree int ,
	Min_dgree int,
	Ins_Id int foreign key references Instructor (ID)
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
 E_Date date, 
 Total  int ,
 exam_type varchar(40),
 Course_id int foreign key references Course(Course_Id)
 )

 create table Branch 
 (
  Branch_Id int primary key identity(1,1),
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
alter table T_F_Question ALTER column correct_Answer varchar(1) 
alter table T_F_Question ALTER column Option2 varchar(1) 
alter table T_F_Question add constraint c4 check (Option1='T' and Option2='F')
alter table T_F_Question add constraint c5 check (correct_Answer='T' or correct_Answer='F')

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
TF_ID int foreign key references TrueFalseQue(ID),
Student_Answer varchar(100) 
)

Create table Student_Exam_Result 
(
ID int primary key identity(1,1),
Std_ID int foreign key references Student(ID),
Crs_ID int foreign key references Course(Course_Id)
)
create table Intake 
(
Intake_ID int primary key identity (1,1),
Intake_name varchar(40)
)

CREATE Table InfoSystem
(
	DataID int primary KEY identity (1 , 1),
	Std_ID int foreign key references Student(ID),
	Crs_ID int foreign key references Course(Course_Id),
	Intake_ID int foreign key references Intake(Intake_ID),
	Branch_ID int foreign key references Branch(Branch_Id),
	Track_ID int foreign key references Track(track_id)
)
