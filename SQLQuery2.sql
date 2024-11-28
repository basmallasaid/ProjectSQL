SELECT 
    Student.FirstName, 
    Student.LastName, 
    Course.Cur_Name AS Course_Name, 
    Branch.Branch_name AS Branch_Name, 
    Track.track_name AS Track_Name
FROM 
    Student
JOIN 
    InfoSystem ON Student.ID = InfoSystem.Std_ID
JOIN 
    Course ON InfoSystem.Crs_ID = Course.Course_Id
JOIN 
    Branch ON InfoSystem.Branch_ID = Branch.Branch_Id
JOIN 
    Track ON InfoSystem.Track_ID = Track.track_id;


	select * from Exam_Question