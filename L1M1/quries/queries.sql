-- Q1--Names of the professors who work in the department 
--that have fewer than 50 phd student

SELECT p.pname as Professors_name
FROM prof p
JOIN dept d ON p.dname = d.dname
WHERE d.numphds < 50;

--Q2-- Print the names of the students with the lowest GPA

-- by using comman table expression 


WITH MinGPA AS (
    SELECT MIN(gpa) AS min_gpa 
    FROM student
)
SELECT s.sname AS Student_name
FROM student s
JOIN MinGPA m ON s.gpa = m.min_gpa;

-- by using the subquery 

SELECT s.sname ,s.gpa as Gpa from student s 
WHERE s.gpa=(SELECT MIN(gpa) from student );

--Q3--For each Computer Sciences course, print the course  number, section number, 
--and the average gpa of the students enrolled in the course  section
 

 SELECT e.cno AS course_no, 
       e.sectno AS section_number, 
       AVG(s.gpa) AS Average_gpa
FROM enroll e
JOIN student s ON e.sid = s.sid
WHERE e.dname = 'Computer Sciences'
GROUP BY e.cno, e.sectno;                                                                                                                                                                                                                                                                                     


            --I think it will be name of COURSES 
--Q4-- Print the  COURSE names and section numbers of all sections(CLASSES) 
--with more than six students enrolled in them.
                   
     
       
       WITH m_sid AS(
        SELECT cno ,sectno FROM enroll
        GROUP BY cno,sectno
        HAVING count(sectno)>6
       )

       SELECT c.cname AS course_name ,m.sectno AS section_number 
       FROM course c  RIGHT JOIN m_sid m ON c.cno=m.cno; 

      
    
           

--Q5--Print the name(s) and sid(s) of the student(s) enrolled in the most sections.

WITH count AS (SELECT e.sid AS s_id ,count(e.sid) 
AS count FROM enroll e
GROUP BY e.sid
 
)

 
 SELECT  distinct s.sname AS Student_name ,e.sid as s_id FROM enroll e
 JOIN student s ON s.sid=e.sid 
 JOIN count c on e.sid=c.s_id 
 where c.count=(SELECT MAX(count) from count );


 --Q6--Print the names of departments that have one or more 
 --majors who are under 18 years old.

 SELECT d.dname AS departments from major d 
 JOIN student s ON s.sid=d.sid 
 WHERE  s.age<18
 GROUP BY d.dname;

--Q7--Print thComputer Sciencese names and majors of students
-- who are taking one of the College Geometry courses
 
    WITH CNO AS( 
        SELECT cno FROM course 
        WHERE cname LIKE 'College Geometry%'
    )

SELECT s.sname AS Student_name ,m.dname AS Major from enroll e 
JOIN major m ON e.sid=m.sid
JOIN student s ON m.sid=s.sid
WHERE e.cno IN(SELECT cno from CNO);

--Q8--For those departments that have no major taking a College Geometry course print 
--the department name and the number of PhD students in the department.

WITH CNO AS(
        SELECT cno FROM course 
        WHERE cname LIKE 'College Geometry%'
    ),

g_id AS(
    SELECT DISTINCT sid FROM enroll 
    WHERE cno IN (SELECT cno FROM CNO)
), temp AS(

SELECT DISTINCT  m.dname AS dname  
FROM major m JOIN g_id g ON m.sid=g.sid)

SELECT  d.dname AS department ,d.numphds AS phds 
FROM dept d WHERE d.dname NOT IN (SELECT * from temp);


 

 
--  SELECT dept.dname, dept.numphds 
--  FROM dept 
--  LEFT JOIN course on course.dname = dept.dname  
--  and course.cname LIKE '%College Geometry%'
--  where course.dname is NULL;

 --Q9 -- Print the names of students who are taking both a Computer Sciences 
 --course and a Mathematics course.

   WITH CSC AS(
    SELECT cno FROM  course
    WHERE dname='Computer Sciences'
   ),
   MC AS(
    SELECT cno FROM  course
    WHERE dname='Mathematics'
   )
   
   SELECT s.sname AS Student_name FROM enroll e
   JOIN enroll e1 ON e.sid=e1.sid
   JOIN student s ON s.sid=e.sid
   WHERE e.cno IN(SELECT * FROM CSC) AND e1.cno IN(SELECT * FROM MC);
    
  --Q10-- Print the age difference between the oldest and the youngest 
  --Computer Sciences major

    SELECT MAX(s.age)-MIN(s.age) AS Age_difference
   FROM student s
   JOIN major m ON m.sid = s.sid
   WHERE m.dname = 'Computer Sciences';

   --Q11--For each department that has one or more majors with a GPA under 1.0, 
   --print the name of the department and the average Genroll e PA of its majors.
     
     WITH sid_ugpa1 AS(
        SELECT sid ,gpa FROM student
        WHERE gpa<1
     )

     SELECT m.dname AS Department, avg(u.gpa)
     AS Average_gpa FROM major m
     JOIN sid_ugpa1 u ON u.sid=m.sid
     GROUP BY m.dname; 

     --Q12--Print the ids, names and GPAs of the students who are currently 
     --taking all the Civil Engineering courses.

      WITH ave AS(
        SELECT count(cno) FROM course
        WHERE dname='Civil Engineering'
        GROUP BY dname
      ),
        csid AS( 
      SELECT e.sid AS sid   
      FROM enroll e  
      WHERE  e.dname='Civil Engineering' 
      GROUP BY e.sid 
      HAVING  count(e.cno)= (SELECT * FROM ave)
     )
      
      SELECT s.sid AS Id ,s.sname AS Name ,s.gpa AS Gpa 
      FROM student s RIGHT JOIN csid c ON c.sid=s.sid;

      