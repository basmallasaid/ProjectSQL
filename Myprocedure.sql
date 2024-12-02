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



