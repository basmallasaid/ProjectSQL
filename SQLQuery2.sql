/*INSERT INTO Student (FirstName, LastName, Email, Password, UserName)
VALUES
('Ahmed', 'Hassan', 'ahmed.hassan@example.com', 'pass1234', 'ahmed_hassan'),
('Yasmine', 'Mohamed', 'yasmine.mohamed@example.com', 'pass5678', 'yas_mohamed'),
('Karim', 'Fathy', 'karim.fathy@example.com', 'karim@123', 'karim_fathy'),
('Nourhan', 'Ali', 'nourhan.ali@example.com', 'nour_pass', 'nourhan_ali');*/
---------------------------------------------------------------------------------
/*INSERT INTO Instructor (FirstName, LastName, Email, Password, UserName)
VALUES
('Amr', 'Ezzat', 'amr.ezzat@example.com', 'instructor1', 'amr_ezzat'),
('Salma', 'Mahmoud', 'salma.mahmoud@example.com', 'instructor2', 'salma_mahmoud');*/
-------------------------------------------------------------------------------------
/*INSERT INTO MCQ_Question (Content, Correct_Answer, Option1, Option2, Option3, Option4, Degree)
VALUES
('What is the time complexity of binary search?', 'B', 'O(n)', 'O(log n)', 'O(n^2)', 'O(1)', 2),
('Which language is used for web development?', 'A', 'HTML', 'Python', 'Java', 'C++', 1),
('What is the function of an operating system?', 'D', 'Compiling code', 'Network design', 'Database storage', 'Resource management', 1);*/
--------------------------------------------------------------------------------------------------
/*INSERT INTO Branch (Branch_name)
VALUES
('Cairo'),
('Alexandria'),
('Giza'),
('Assiut'),
('Mansoura');*/
-----------------------------------------------------------------------------------
/*INSERT INTO Intake (Intake_name)
VALUES
('Round 1'),
('Round 2'),
('Round 3'),
('Round 4'),
('Round 5');*/
-----------------------------------------------------------------------------
/*INSERT INTO Track (track_name)
VALUES
('Frontend Development'),
('Backend Development'),
('Data Science'),
('Cybersecurity'),
('Artificial Intelligence');*/
---------------------------------------------------------
/*INSERT INTO Course (Cur_Name, descriptions, Max_degree, Min_dgree, Ins_Id)
VALUES
('Introduction to Programming', 'Learn basic programming concepts.', 100, 50, 1),
('Web Development', 'Learn HTML, CSS, and JavaScript.', 120, 50, 2),
('Data Structures', 'Understand algorithms and data structures.', 120, 50, 1),
('Database Systems', 'Introduction to relational databases.', 100, 50, 2),
('Operating Systems', 'Learn the fundamentals of OS.', 100, 50, 1);*/
---------------------------------------------------------------------------
/*INSERT INTO TrueFalseQue (Degree, Content, CorrectChoice, Option1, Option2)
VALUES
(1, 'A linked list is a linear data structure.', 'True', 'True', 'False'),
(1, 'TCP/IP is a protocol for web communication.', 'True', 'True', 'False'),
(1, 'The OSI model has 5 layers.', 'False', 'True', 'False'),
(1, 'Python is a compiled language.', 'False', 'True', 'False'),
(1, 'RAM is volatile memory.', 'True', 'True', 'False');*/
------------------------------------------------------------------------------
INSERT INTO InfoSystem(Std_ID, Crs_ID, Intake_ID, Branch_ID, Track_ID)
VALUES
(1, 1, 1, 1, 1), -- Ahmed Hassan enrolled in "Introduction to Programming", Round 1, Cairo, Frontend Development
(2, 2, 2, 2, 2), -- Yasmine Mohamed enrolled in "Web Development", Round 2, Alexandria, Backend Development
(3, 3, 3, 3, 3), -- Karim Fathy enrolled in "Data Structures", Round 3, Giza, Data Science
(4, 4, 4, 4, 4); -- Nourhan Ali enrolled in "Database Systems", Round 4, Assiut, Cybersecurity


Select * from InfoSystem