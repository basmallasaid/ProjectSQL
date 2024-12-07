-- Ahmed Mustafa && Ahmed
-- 1) Edit Instructor
CREATE PROCEDURE EditInstructor
    @InstructorID INT = NULL,
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(100),
    @Password NVARCHAR(50),
    @UserName NVARCHAR(50),
    @StatementType NVARCHAR(20)
AS
BEGIN
    IF @StatementType = 'Insert'
    BEGIN
        INSERT INTO Instructor
                    (FirstName, LastName, Email, Password, UserName)
        VALUES      (@FirstName, @LastName, @Email, @Password, @UserName)
    END
    ELSE IF @StatementType = 'Update'
    BEGIN
        UPDATE Instructor
        SET    FirstName = @FirstName,
               LastName = @LastName,
               Email = @Email,
               Password = @Password,
               UserName = @UserName
        WHERE  ID = @InstructorID
    END
END

-- Example: Insert a new instructor
EXEC EditInstructor
    @InstructorID = 17,
    @FirstName = 'basant',
    @LastName = 'Mostafa',
    @Email = 'basant.mostafa@example.com',
    @UserName = 'basantUser',
    @Password = '12356',
    @StatementType = 'Insert';

-- Example: Update an existing instructor
EXEC EditInstructor
    @InstructorID = 2,
    @FirstName = 'Basmala',
    @LastName = 'Said',
    @Email = 'basmala.said@gmail.com',
    @UserName = 'BasmalaUser',
    @Password = '12345',
    @StatementType = 'Update';

Select * from dbo.Instructor

-- 2) Show instructor
CREATE FUNCTION ShowInstructors(@UserName NVARCHAR(50))
RETURNS @ShowInstructors TABLE
(
    InstructorID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    UserName NVARCHAR(50)
)
AS
BEGIN
    INSERT INTO @ShowInstructors
    SELECT 
        ID, 
        FirstName, 
        LastName, 
        Email, 
        UserName
    FROM 
        Instructor 
    WHERE 
        UserName = @UserName 

    RETURN;
END;

-- Example: Retrieve instructor information
SELECT * FROM ShowInstructors('AhmedUser');

Select * from Instructor
-- 3) Delete instructor by username
CREATE PROCEDURE DeleteInstructor (@UserName NVARCHAR(50))  
AS  
BEGIN
    DECLARE @InstructorID INT, @CourseID INT;

    SET @InstructorID = (SELECT ID FROM Instructor WHERE UserName = @UserName);

    IF @InstructorID IS NOT NULL
    BEGIN
        DELETE FROM Instructor WHERE UserName = @UserName;
    END
END;
EXEC DeleteInstructor @UserName = 'basantUser';
Select * from Instructor
-- 4) Edit Instructor In Course
CREATE PROCEDURE EditInstructorInCourse (@Cur_Name VARCHAR(50), @UserName VARCHAR(30))
AS
BEGIN
    DECLARE @InstructorID INT;

    SET @InstructorID = (SELECT ID FROM Instructor WHERE Username = @UserName);

    IF @InstructorID IS NOT NULL
    BEGIN
        UPDATE Course
        SET Ins_Id = @InstructorID
        WHERE Cur_Name = @Cur_Name;
        
        PRINT 'Instructor updated successfully!';
    END
    ELSE
    BEGIN
        PRINT 'Instructor not found!';
    END
END;

EXEC EditInstructorInCourse @Cur_Name = 'Web Development', @UserName = 'amr_ezzat';
select *from Course;
select *from Instructor;


-- 5) Edit or Add course
CREATE OR ALTER PROCEDURE EditCourse(@ID INT = NULL , @CourseName varchar(30) , @Description varchar(100) , @MaxDegree
int , @MinDegree int , @InstructorID int , @Statement varchar(20))
AS
	BEGIN
		IF @Statement = 'Insert'
		BEGIN
			INSERT INTO Course(Cur_Name , descriptions , Max_degree , Min_dgree , Ins_Id)
			Values(@CourseName , @Description , @MaxDegree , @MinDegree , @InstructorID)
		END
		IF @Statement = 'Update'
		BEGIN
			UPDATE Course
			SET		Cur_Name = @CourseName,
					descriptions = @Description ,
					Max_degree = @MaxDegree,
					Min_dgree = @MinDegree,
					Ins_Id = @InstructorID
			WHERE Course_Id = @ID
		END
	END
EXEC EditCourse NULL, 'Cybersecurity', 'Cryptography and Network Security', 120, 60, 1, 'Insert';
select *from Course;

 -- 6) Delete Course
CREATE or Alter PROCEDURE DeleteCourse @CourseName varchar(30)
AS  
  BEGIN 
    
            Delete FROM  Course
            WHERE  Cur_Name = @CourseName 
 END

 exec DeleteCourse 'AI'
 
SELECT * FROM Course


-- 7) Edit mcq question
create or alter PROCEDURE EditMCQ (@ID int = null, @Content varchar(150) , @CorrectAnswer varchar(100) ,@option1 varchar(100) ,@option2 varchar(100),@option3 nvarchar(100),@option4 varchar(100),@Degree int, @StatementType VARCHAR(20))  
AS  
  BEGIN 
      IF @StatementType = 'Insert'  
        BEGIN  
            INSERT INTO  MCQ_Question
                        (Content,Correct_Answer,Option1,Option2,Option3,Option4,Degree)  
            VALUES     (@Content,@CorrectAnswer,@option1,@option2,@option3,@option4,@Degree)  
        END  
      IF @StatementType = 'Update'  
        BEGIN  
            UPDATE   MCQ_Question
            SET    Content=@Content,
			       Correct_Answer=@CorrectAnswer,
				   Option1=@option1,
				   Option2=@option2,
				   Option3=@option3,
				   Option4=@option4,
				   Degree = @Degree
            WHERE  ID = @ID
			
        END  
      ELSE IF @StatementType = 'Delete'  
        BEGIN  
            DELETE FROM  MCQ_Question
            WHERE  ID = @ID
        END  
  END   

EXEC EditMCQ 
    @ID = 1, 
    @Content = 'Which OOP concept involves data hiding?', 
    @CorrectAnswer = 'Encapsulation', 
    @option1 = 'Inheritance', 
    @option2 = 'Polymorphism', 
    @option3 = 'Abstraction', 
    @option4 = 'Encapsulation', 
    @Degree = 2, 
    @StatementType = 'Insert';
  Select * from MCQ_Question

  -- 8) Edit true or false question
CREATE OR Alter PROCEDURE EditTrueFalse @Id INT = null, @Degree decimal, @Content varchar(max), @CorrectChoice varchar(10) , @StatementType VARCHAR(30)
AS
BEGIN
    IF @StatementType = 'Insert'
    BEGIN
        INSERT INTO TrueFalseQue(Degree, Content, CorrectChoice, Option1, Option2)
        VALUES (@Degree, @Content, @CorrectChoice , 'True' , 'False');
    END
    ELSE IF @StatementType = 'Update'
    BEGIN
        UPDATE TrueFalseQue
        SET 
            Content = @Content,
            CorrectChoice = @CorrectChoice,
            Degree = @Degree
        WHERE ID = @Id;
    END
    ELSE IF @StatementType = 'Delete'
    BEGIN
        DELETE FROM TrueFalseQue
        WHERE ID = @Id;
    END
END;

select * from TrueFalseQue

EXEC EditTrueFalse @Id = 33, @Degree = Null, @Content = NULL, @CorrectChoice = NULL, @StatementType = 'Delete';

Select * from TrueFalseQue;

-- 9) Add New Track
create PROCEDURE AddNewTrack (@Name varchar(40))  
AS  
  BEGIN  
           INSERT INTO Track  VALUES (@Name)  
 END 

exec AddNewTrack 'Flutter'
select * from Track;

-- 10) Add New Student
CREATE OR ALTER PROCEDURE AddNewStudent 
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(100),
    @UserName NVARCHAR(50),
    @Password NVARCHAR(50),
    @Intake NVARCHAR(50),
    @BranchName NVARCHAR(50),
    @TrackName NVARCHAR(50),
    @CourseName NVARCHAR(50)
AS
BEGIN
    DECLARE @IntakeID INT, 
            @BranchID INT, 
            @TrackID INT, 
            @StudentID INT,
            @CourseID INT;

    SET @IntakeID = (SELECT Intake_ID FROM Intake WHERE Intake_name = @Intake);
    SET @BranchID = (SELECT Branch_Id FROM Branch WHERE Branch_name = @BranchName);
    SET @TrackID = (SELECT Track_ID FROM Track WHERE Track_name = @TrackName);
    SET @CourseID = (SELECT Course_Id FROM Course WHERE Cur_Name = @CourseName);

    IF @IntakeID IS NULL
    BEGIN
        PRINT 'Error: Invalid Intake Name.';
        RETURN;
    END

    IF @BranchID IS NULL
    BEGIN
        PRINT 'Error: Invalid Branch Name.';
        RETURN;
    END

    IF @TrackID IS NULL
    BEGIN
        PRINT 'Error: Invalid Track Name.';
        RETURN;
    END

    IF @CourseID IS NULL
    BEGIN
        PRINT 'Error: Invalid Course Name.';
        RETURN;
    END

    INSERT INTO Student (FirstName, LastName, Email, Password, UserName)
    VALUES (@FirstName, @LastName, @Email, @Password, @UserName);

    SET @StudentID = SCOPE_IDENTITY();

    IF @StudentID IS NULL
    BEGIN
        PRINT 'Error: Failed to insert student record.';
        RETURN;
    END

    INSERT INTO InfoSystem (Std_ID, Crs_ID, Intake_ID, Branch_ID, Track_ID)
    VALUES (@StudentID, @CourseID, @IntakeID, @BranchID, @TrackID);

    PRINT 'Student added successfully!';
END;

EXEC AddNewStudent 
    @FirstName = 'Mohamed',
    @LastName = 'Abdallah',
    @Email = 'mohamed.abdallah@example.eg',
    @UserName = 'mohamed_abdallah',
    @Password = '12345',
    @Intake = 'round 1',
    @BranchName = 'Cairo',
    @TrackName = 'Frontend Development',
    @CourseName = 'Web Development';

	select * from Student
	

------------------------------------------------------------------------------
-- Basmala
-- 1)Availablle Courses
CREATE Function AvailableCourses() 
RETURNS @AvailableCourses TABLE
(
   CourseTitle NVARCHAR(255),
   InstructorName NVARCHAR(255),
   TrackName NVARCHAR(255),
   BranchName NVARCHAR(255)
)
AS
BEGIN
  INSERT INTO @AvailableCourses
  SELECT 
    c.Cur_Name AS CourseTitle, 
    CONCAT(i.FirstName, ' ', i.LastName) AS InstructorName, 
    t.track_name AS TrackName, 
    b.Branch_name AS BranchName
  FROM 
    Course c
    JOIN InfoSystem inf ON c.Course_Id = inf.Crs_ID
    JOIN Instructor i ON c.Ins_Id = i.ID
    JOIN Track t ON inf.Track_ID = t.track_id
    JOIN Branch b ON inf.Branch_ID = b.Branch_Id
  RETURN;
END;
SELECT * FROM AvailableCourses();

-----2)Show student courses
CREATE OR Alter PROCEDURE ShowStudentCourses
@UserName NVARCHAR(255)
AS
BEGIN
    SELECT DISTINCT
		s.FirstName + ' ' + s.LastName As FullName,
        c.Cur_Name AS Course, 
        CONCAT(i.FirstName, ' ', i.LastName) AS InstructorName, 
        t.track_name AS Track, 
        b.Branch_name AS Branch
    FROM 
        Course c
        JOIN InfoSystem inf ON c.Course_Id = inf.Crs_ID
        JOIN Instructor i ON c.Ins_Id = i.ID
        JOIN Track t ON inf.Track_ID = t.track_id
        JOIN Branch b ON inf.Branch_ID = b.Branch_Id
        JOIN Student s ON inf.Std_ID = s.ID
    WHERE 
        s.UserName = @UserName;
END

EXEC ShowStudentCourses 'ahmed_hassan';
SELECT * FROM Student

-- 3) Edit password
CREATE PROCEDURE EditPassWord @UserName NVARCHAR(255), @NewPassword NVARCHAR(255)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Student WHERE UserName = @UserName)
    BEGIN
        PRINT 'Error: Username not found.';
        RETURN;
    END
    UPDATE Student
    SET Password = @NewPassword
    WHERE UserName = @UserName;

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Error: Password update failed.';
    END
    ELSE
    BEGIN
        PRINT 'Password updated successfully.';
    END
END;

Exec EditPassWord ahmed_hassan , '12345' 
SELECT * FROM Student
-- 4)Edit username
CREATE PROCEDURE EditUserName
@OldUserName NVARCHAR(255),
@NewUserName NVARCHAR(255)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Student WHERE UserName = @NewUserName)
    BEGIN
        PRINT 'Error: The new username is already in use.';
        RETURN;
    END
    UPDATE Student
    SET UserName = @NewUserName
    WHERE UserName = @OldUserName;
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Error: Old username not found.';
    END
    ELSE
    BEGIN
        PRINT 'Username updated successfully.';
    END
END;
Exec EditUserName ahmed_hassan ,'ahmedhassan3';
select *from Student

-- 5)Add Student To Course
CREATE PROCEDURE AddStudentToCourse
@UserName NVARCHAR(255),
@Title NVARCHAR(255)
AS
BEGIN
  
    DECLARE @CourseID INT;
    DECLARE @StudentID INT;

  
    SELECT @CourseID = Course_Id FROM Course WHERE Cur_Name = @Title;
    IF @CourseID IS NULL
    BEGIN
        PRINT 'Error: Course not found.';
        RETURN;
    END

    SELECT @StudentID = ID FROM Student WHERE UserName = @UserName;
    IF @StudentID IS NULL
    BEGIN
        PRINT 'Error: Student not found.';
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM InfoSystem WHERE Crs_ID = @CourseID AND Std_ID = @StudentID)
    BEGIN
        PRINT 'Error: Student is already enrolled in this course.';
        RETURN;
    END

    INSERT INTO InfoSystem (Std_ID, Crs_ID)
    VALUES (@StudentID, @CourseID);

    PRINT 'Student added to the course successfully.';
END;
Exec AddStudentToCourse mohamed_abdallah ,'Introduction to Programming';

select *from InfoSystem
select *from Course 
select *from Student 

-- 6)Remove Student From Course
CREATE OR ALTER PROCEDURE RemoveStudentFromCourse
@UserName NVARCHAR(255),
@Title NVARCHAR(255)
AS
BEGIN
    DECLARE @CourseID INT;
    DECLARE @StudentID INT;

    SELECT @CourseID = Course_Id FROM Course WHERE Cur_Name = @Title;
    IF @CourseID IS NULL
    BEGIN
        PRINT 'Error: Course not found.';
        RETURN;
    END

    SELECT @StudentID = ID FROM Student WHERE UserName = @UserName;
    IF @StudentID IS NULL
    BEGIN
        PRINT 'Error: Student not found.';
        RETURN;
    END

    IF NOT EXISTS (
        SELECT 1 FROM InfoSystem 
        WHERE Std_ID = @StudentID AND Crs_ID = @CourseID
    )
    BEGIN
        PRINT 'Error: Student is not enrolled in this course.';
        RETURN;
    END

    DELETE FROM InfoSystem
    WHERE Std_ID = @StudentID AND Crs_ID = @CourseID;

    PRINT 'Student removed from the course successfully.';
END;

Exec RemoveStudentFromCourse 'mohamed_abdallah ','Introduction to Programming';

select * from InfoSystem;

--- 7)Calculate Question Result
CREATE OR ALTER PROCEDURE CalculateQuestionResult
@UserName NVARCHAR(255),
@QuestionID INT,
@ExamID INT,
@QuestionType CHAR(3)
AS
BEGIN
    DECLARE @studentID INT;
    SELECT @studentID = ID FROM Student WHERE UserName = @UserName;
    
    DECLARE @studentAnswer NVARCHAR(2);
    DECLARE @correctAnswer NVARCHAR(2);
    DECLARE @FullDegree INT;
    DECLARE @StudentAnswerResult INT;
    
   
    SELECT @StudentAnswerResult = 0;
    
    IF (@QuestionType = 'MCQ')
    BEGIN
        
        SELECT @correctAnswer = Correct_Answer FROM MCQ_Question WHERE ID = @QuestionID;
        SELECT @FullDegree = Degree FROM MCQ_Question WHERE ID = @QuestionID;
        SELECT @studentAnswer = Student_Answer FROM Exam_Question WHERE ID = @QuestionID AND Exam_Id = @ExamID AND ID = @studentID;

        IF (@studentAnswer = @correctAnswer)
            SET @StudentAnswerResult = @FullDegree;

        UPDATE Exam_Question SET Student_Answer = @StudentAnswerResult WHERE ID = @QuestionID AND Exam_Id = @ExamID AND ID = @studentID;
    END

    ELSE IF (@QuestionType = 'TFQ')
    BEGIN

        SELECT @correctAnswer = CorrectChoice FROM TrueFalseQue WHERE ID = @QuestionID;
        SELECT @FullDegree = Degree FROM TrueFalseQue WHERE ID = @QuestionID;
        SELECT @studentAnswer = Student_Answer FROM Exam_Question WHERE ID = @QuestionID AND Exam_Id = @ExamID AND ID = @studentID;

        IF (@studentAnswer = @correctAnswer)
            SET @StudentAnswerResult = @FullDegree;

        UPDATE Exam_Question SET Student_Answer = @StudentAnswerResult WHERE ID = @QuestionID AND Exam_Id = @ExamID AND ID = @studentID;
    END
END;

EXEC CalculateQuestionResult
    @UserName = 'ahmed_hassan', 
    @QuestionID = 1,             
    @ExamID = 1,                 
    @QuestionType = 'TFQ';  
SELECT * FROM Exam_Question ;


--------------------------------------------------------
--abdulrazeq 


--Courses that he teachs
create proc InstructorCourses(@UserName varchar(20))
as
begin
	select [Cur_Name],[descriptions] 
from  Course
where [Ins_id] in 
(
select ID from [Instructor]
where [FirstName]=@UserName
)
end

 EXEC InstructorCourses @UserName = 'Amr';





---exec InstructorCourses 'AlyUser'

-----------------------------------------------------------

--number of student in each course 

Create proc NumOfStudentInEachCourse(@course_name varchar(30) )
as
begin
	select Cur_Name ,count(Std_ID ) as NumOfStudent from Course c inner join InfoSystem i
on c.Course_Id=i.Crs_id
where Cur_Name=@course_name
group by Cur_Name 
end 

EXEC NumOfStudentInEachCourse @course_name = '1';


--------------------------------------------------------------------------

--Shows Questions of a specific course 

create  proc CourseQuestion(@courseTitle varchar(40))
as
begin

 IF @courseTitle IS NULL 
    BEGIN
        select  'Course title cannot be empty!';
        RETURN;
    END

   DECLARE @courseID INT;

    SELECT @courseID = Course_ID
    FROM [Course]
    WHERE Cur_Name = @courseTitle;

  IF @courseID IS NULL
    BEGIN
       select 'Course not found!';
        RETURN;
    END
    SELECT 
        [Content] AS 'Question',
        [CorrectChoice] AS 'CorrectAnswer'
    FROM 
       [dbo].[TrueFalseQue] t
    inner join [dbo].[Exam_Question]  e 
	on t.ID =e.TF_ID
	inner join Exam x on e.Exam_Id = x.Exam_id
	inner join  Course  c on c.Course_Id= x.Course_id
	where  c.Course_Id=@courseID
UNION ALL	 

    SELECT 
        [Content] AS 'Question',
        [Correct_Answer] AS 'CorrectAnswer'
    FROM 
        [dbo].[MCQ_Question] M
   inner join   [dbo].[Exam_Question]  E 
   on M.ID=E.MCQ_id 
   inner join Exam x on x.Exam_id = E.Exam_Id
   inner join Course c on c.Course_Id= x.Course_id
   where c.Course_Id=@courseID
END;

exec CourseQuestion 'XML'


--exec QuestionOfCourse 'SQL'

-------------------------------------------------------------------------------------
--Edit Instructor UserName 

create or alter proc EditInstructorUserName(@oldUserName varchar(30) ,@NewUserName varchar(30))
as
begin

declare @InstructorID int;
set @InstructorID=(select [ID] from [dbo].[Instructor] where Username=@oldUserName);
update Instructor
set Username=@NewUserName
where [ID]= @InstructorID 

end

exec EditInstructorUserName 'ghidhgdhg' ,  'ahmed_salem'

insert into Instructor
values ('Ahmed','salam','ahmed.salem@gamil.com','ahmed12345','ghidhgdhg')
--------------------------------------------------------------------------------------------

--Edit Instructor's Password  --> this operation needs UserName & Newpass

create or alter proc EditInstructorPass(@UserName varchar(30),@NewPass varchar(30))
as
begin

declare @InstructorID int;
set @InstructorID=(select [ID] from [Instructor] where Username=@UserName);
update [Instructor]
set [Password]=@NewPass
where [ID]= @InstructorID 

end

exec EditInstructorPass 'amr_ezzat','amr12345'

-------------------------------------------------------------------------------------
--Shows Students' Names (who Enrrolled in Instructor's Courses) , and CourseTitle

create or alter proc StudentsOfCourses(@UserName varchar(30))
as
begin
declare @InstructorID int;
set @InstructorID=(select [ID] from [Instructor] where UserName=@UserName)
select FirstName,Cur_Name
from Student stu , Course cors ,InfoSystem dp
where stu.ID =dp.Std_ID and dp.Crs_ID=cors.Course_Id and cors.Course_Id in
(
select [ID] from Course
where Ins_Id=@InstructorID
)
end

exec  StudentsOfCourses'amr_ezzat'

------------------------------------------------------------------------------------

--Shows Questions Of an Exam 

create  proc ShowQuestionsExam(@ExamID int)
as
begin

select distinct [Content]  as 'Question' , Correct_Answer as 'CorrectAnswer'
from MCQ_Question mcq ,Exam_Question EQ
where EQ.Exam_Id=@ExamID and EQ.MCQ_id is not null and EQ.MCQ_id =mcq.ID
union 
select distinct [Content] as 'Question' ,[CorrectChoice] as 'CorrectAnswer'
from [dbo].[TrueFalseQue] TFQ,Exam_Question EQ
where EQ.Exam_Id=@ExamID and EQ.TF_ID is not null and EQ.TF_ID =TFQ.ID
end


exec ShowQuestionsExam  3

---------------------------------------------------------------------

--Add Exam Scedule .. define its starttime , EndTime , Total time and Exam Type (Corrective or not) ..

create  proc AddExam(@StartTime datetime ,@EndTime datetime ,@TotalTime int,@ExamType varchar(30) )
as
begin
insert into Exam (StartTime,End_time,Total,exam_type)
values(@StartTime,@EndTime,@TotalTime,@ExamType)
end

EXEC AddExam 
    @StartTime = '2024-12-07 10:00:00', 
    @EndTime = '2024-12-07 12:00:00', 
    @TotalTime = 120, 
    @ExamType = 'Final';


-- Shows Students's Results in a specific Exam  
 -- where is the result of sutdent where are you stored it 
create  proc StudentsResultExam (@Course_ID int) as 
begin
select ID as 'StudentName' , result  from 
Student_Exam_Result where Crs_ID=@Course_ID 
end ----


exec StudentsResultExam 1

---------------------------------------------------------------------------



--cucullate the result of exam


ALTER PROCEDURE result_of_exam 
    @Exam_id INT
AS
BEGIN
    -- Declare variables
    DECLARE @cur_id INT; -- Course ID
    DECLARE @stu_ID INT; -- Student ID
    DECLARE @grades INT; -- Total grades

    -- Initialize total grades
    SET @grades = 0;

    -- Calculate total grades for the exam
    SELECT 
        @grades = SUM(
            CASE 
                WHEN E.Student_Answer = M.Correct_Answer THEN M.Degree
                WHEN E.Student_Answer = T.CorrectChoice THEN T.Degree
                ELSE 0
            END
        )
    FROM 
        Exam_Question E
    LEFT JOIN 
        MCQ_Question M ON E.MCQ_id = M.ID
    LEFT JOIN 
        TrueFalseQue T ON E.TF_ID = T.ID
    WHERE 
        E.Exam_Id = @Exam_id;

    -- Get Course ID related to the Exam
    SELECT 
        @cur_id = Course_id 
    FROM 
        Exam 
    WHERE 
        Exam_id = @Exam_id;

    -- Get Student ID related to the Exam
    SELECT 
        @stu_ID = Std_ID 
    FROM 
        InfoSystem I
    INNER JOIN 
        Course C ON I.Crs_ID = C.Course_Id
    INNER JOIN 
        Exam E ON E.Course_id = C.Course_Id
    WHERE 
        Exam_id = @Exam_id;

    -- Insert the final result into Student_Exam_Result table
    INSERT INTO Student_Exam_Result (Std_ID, Crs_ID, result)
    VALUES (@stu_ID, @cur_id, @grades);

    -- Return the result
END;



result_of_exam 1


delete from Student_Exam_Result