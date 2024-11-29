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
SELECT * FROM Student


