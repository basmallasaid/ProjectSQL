-- Edit or Add course
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
EXEC EditCourse NULL, 'Object Oriented Programming', 'Learn OOP fundamentals', 100, 50, 1, 'Insert';


 -- Delete Course
CREATE or Alter PROCEDURE DeleteCourse @CourseName varchar(30)
AS  
  BEGIN 
    
            Delete FROM  Course
            WHERE  Cur_Name = @CourseName 
 END

 exec DeleteCourse 'Object Oriented Programming'
 
SELECT * FROM Course


-- Edit mcq question
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

  -- Edit true or false question
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

EXEC EditTrueFalse @Id = 12, @Degree = Null, @Content = NULL, @CorrectChoice = NULL, @StatementType = 'Delete';





------------------------------------------------------------------------------
-- Basmala
-- Availablle Courses
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

--Show student courses
CREATE PROCEDURE ShowStudentCourses
@UserName NVARCHAR(255)
AS
BEGIN
    SELECT DISTINCT 
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
EXEC ShowStudentCourses ahmed_hassan;
SELECT * FROM Student

-- Edit password
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

Exec EditPassWord ahmed_hassan , 'ADMIN12345' 
--Edit username
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
Exec EditUserName yas_mohamed ,'Yasmeen_Muhammed';

select *from Student
--Add Student To Course
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
Exec AddStudentToCourse ahmed_hassan ,'Object Oriented Programming';

select *from InfoSystem
select *from Course
select *from Student

--Remove Student From Course
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

    IF NOT EXISTS (SELECT 1 FROM InfoSystem WHERE Std_ID = @StudentID AND Crs_ID = @CourseID AND IsDeleted= 0)
    BEGIN
        PRINT 'Error: Student is not enrolled in this course or already removed.';
        RETURN;
    END
    UPDATE InfoSystem
    SET IsDeleted = 1
    WHERE Std_ID = @StudentID AND Crs_ID = @CourseID;

    PRINT 'Student removed from the course successfully.';
END;

---Calculate Question Result
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



SELECT * FROM MCQ_Question
SELECT * FROM Exam_Question
select * from TrueFalseQue;
INSERT INTO Exam_Question (Exam_Id, MCQ_id,TF_ID ,Student_Answer)
VALUES
--( 1, 1, Null,'B'),  
( 1, 2, Null,'A'),
( 1, NULL, 3,'T'); 


ALTER TABLE Exam
ADD CourseID INT;
ALTER TABLE Exam
drop CONSTRAINT CourseID;

ALTER TABLE Exam
ADD CONSTRAINT FK_Exam_Course
FOREIGN KEY (CourseID)
REFERENCES Course(Course_id)
select * from Exam;


/*INSERT INTO Exam (Exam_id, StartTime, End_time,E_Date, Total,exam_type, Course_id)
VALUES
( 1, '2024-12-05 09:00', '2024-12-05 11:00', '2024-12-05', '120', 'Exam',1),
( 2, '2024-12-06 09:00', '2024-12-06 11:00', '2024-12-06', '120', 'corrective',2);*/

--Calculate Final Result 
CREATE OR ALTER PROCEDURE CalculateFinalResult
@UserName varchar(200),
@ExamID varchar(200)
AS
BEGIN
    DECLARE @studentID INT;
    SELECT @studentID = ID FROM Student WHERE UserName = @UserName;
    
    DECLARE @FinalResult INT = 0;
    DECLARE @MCQID INT;
    DECLARE @TFQID INT;
    DECLARE @QuestionType CHAR(3);

    DECLARE s_cur CURSOR FOR
    SELECT MCQ_id, TFQID, TXQID, QuestionType
    FROM Questions.ExamQuestion
    WHERE Exam_ID = @ExamID 
    FOR READ ONLY; 
    
    OPEN s_cur;
    
    FETCH NEXT FROM s_cur INTO @MCQID, @TFQID, @TXQID, @QuestionType;
    
    -- التكرار عبر الأسئلة
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF (@QuestionType = 'MCQ')
        BEGIN
            -- حساب نتيجة السؤال من نوع MCQ
            EXEC CalculateQuestionResult @UserName, @MCQID, @ExamID, @QuestionType;
        END
        ELSE IF (@QuestionType = 'TXQ')
        BEGIN
            -- حساب نتيجة السؤال من نوع TXQ
            EXEC CalculateQuestionResult @UserName, @TXQID, @ExamID, @QuestionType;
        END
        ELSE IF (@QuestionType = 'TFQ')
        BEGIN
            -- حساب نتيجة السؤال من نوع TFQ
            EXEC CalculateQuestionResult @UserName, @TFQID, @ExamID, @QuestionType;
        END
        
        -- الانتقال إلى السؤال التالي
        FETCH NEXT FROM s_cur INTO @MCQID, @TFQID, @TXQID, @QuestionType;
    END;
    
    -- إغلاق المؤشر
    CLOSE s_cur;
    DEALLOCATE s_cur;
    
    -- حساب النتيجة النهائية للطالب
    SELECT @FinalResult = SUM(StudentAnswerResult)
    FROM Questions.ExamQuestion
    WHERE ExamID = @ExamID AND StudentID = @studentID;
    
    -- تحديث النتيجة النهائية في جدول StudentExamResult
    UPDATE Exam.StudentExamResult
    SET Result = @FinalResult
    WHERE StudentID = @studentID AND ExamID = @ExamID;
    
    -- إرجاع النتيجة النهائية
    SELECT @FinalResult AS FinalResult;
END;
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

InstructorCourses Amr




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

NumOfStudentInEachCourse 1 


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

-----------------------------------------------------------------

--Insert / make Exam  for a specific Course 

/*create or alter proc MakeCourseExam(@CourseTitle varchar(40) ,@ExamID int)
as
begin
declare @sum int;
set @sum=0;
declare @courseID int;
set @courseID=(select Course_Id from Course where Cur_Name =@CourseTitle);
select  @courseID
declare @MaxDegree int;
set @MaxDegree =(select [Max_degree] from Course where Cur_Name =@CourseTitle);
select  @MaxDegree
create table #MCQ
(
 ID int 
)
insert into #MCQ select ID from Questions.[MCQ] where CourseID=@courseID 
--
create table #TF
(
ID int
)
insert into #TF select ID from Questions.[TrueFalseQuestion] where CourseID=@courseID 

---

declare ss1_cur cursor
	for select ID from #MCQ
	for read only  
declare @id1 int
open ss1_cur 
begin
	print @@Fetch_status
	
	fetch ss1_cur into @id1
	While @@fetch_status=0  
	begin
		declare @fullDegree int
		set @fullDegree =(select [FullDegree] from Questions.[MCQ] where ID=@id1)
		if(@FullDegree is not null and @FullDegree >0 and @FullDegree+@sum <= @MaxDegree)
          begin
           set @sum+=@fullDegree
           insert into Questions.[ExamQuestion]([ExamID],[MCQID],[QuestionType]) values (@ExamID,@id1,'MCQ');
           end
		fetch ss1_cur into @id1
	end
end
---

declare ss2_cur cursor
	for select ID from #TF
	for read only  
declare @id2 int
open ss2_cur 
begin
	print @@Fetch_status
	
	fetch ss2_cur into @id2
	While @@fetch_status=0  
	begin
		declare @fullDegree2 int
		set @fullDegree2 =(select [FullDegree] from Questions.[TrueFalseQuestion] where ID =@id2)
		if(@FullDegree2 is not null and @FullDegree2 >0 and @FullDegree2+@sum <= @MaxDegree)
          begin
           set @sum+=@fullDegree2
           insert into Questions.[ExamQuestion]([ExamID],[TFQID],[QuestionType]) values (@ExamID,@id2,'TFQ');
           end
		fetch ss2_cur into @id2
	end
end
------
declare ss3_cur cursor
	for select ID from #TF
	for read only  
declare @id3 int
open ss3_cur 
begin
	print @@Fetch_status
	
	fetch ss3_cur into @id3
	While @@fetch_status=0  
	begin
		declare @fullDegree3 int
		set @fullDegree3 =(select [FullDegree] from Questions.[TrueFalseQuestion] where ID =@id3)
		if(@FullDegree3 is not null and @FullDegree3 >0 and @FullDegree3+@sum <= @MaxDegree)
          begin
           set @sum+=@fullDegree3
           insert into Questions.[ExamQuestion]([ExamID],[TXQID],[QuestionType]) values (@ExamID,@id3,'TXQ');
           end
		fetch ss3_cur into @id3
	end
end
end

--exec MakeCourseExam 'SQL',@ExamID=3*/


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
-- Shows Students's Results in a specific Exam  
 -- where is the result of sutdent where are you stored it 
/*create or alter proc StudentsResultExam (@ExamID int)
as
begin
select [StudentID] as 'StudentName' , [Result] 
from Exam.[StudentExamResult]
where [ExamID]=@ExamID
end*/
----
--exec StudentsResultExam @ExamID=3

---------------------------------------------------------------------------

--Add Exam Scedule .. define its starttime , EndTime , Total time and Exam Type (Corrective or not) ..

create  proc AddExam(@StartTime datetime ,@EndTime datetime ,@TotalTime int,@ExamType varchar(30) )
as
begin
insert into Exam (StartTime,End_time,Total,exam_type)
values(@StartTime,@EndTime,@TotalTime,@ExamType)
end



