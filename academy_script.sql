use academy;
show tables;
select * from course;
select * from students;
select * from result;

select * from result
inner join students on result.student_ID = students.student_ID
inner join course on result.course_ID = course.course_ID;

select stud.student_ID, concat(stud.student_first_name, ' ', stud.student_last_name) as 'Full Name', 
course.course_ID, course.max_grades 'maximum grades', grades 'earned grades' from result
inner join students stud on result.student_ID = stud.student_ID
inner join course course on result.course_ID = course.course_ID;


-- will select all values in the 'left table', whether or not they meet
-- the condition. Be sutre to structure the query correctly to bring back 
-- the records that you are interested in.
select * from result r
left join course c on r.course_ID = c.course_ID;


-- will select all the values in the 'right table' whether or not they meet
-- the condition. Be sure to structure the query correctly to bring back
-- the records that you are interested in.
select * from result r
right join course c on r.course_ID = c.course_ID;

-- will select all records on either side regardless of there being a match
select * from result r
cross join course c;


select distinct * from result;	-- this is for distinct rows in the table

select distinct course_ID from result;	-- this looks for distinct values of mentioned column

select course_ID, student_ID from result
group by course_ID, student_ID;		-- outputs same as distinct course_ID but helps grouping the rows with same column value
						-- hence used for aggregate functions/calculations further.


-- count of number of students having completed a course
select c.course_name, count(student_ID) 'total candidates' from result r
inner join course c on c.course_ID = r.course_ID
group by c.course_name;


-- avg of all the scores obtained by all the students for any single given course
select c.course_name, avg(r.grades) from result r
inner join course c on c.course_ID = r.course_ID
group by c.course_name;


-- scorecard for any given student that shows all his scores for all the courses
select concat(s.student_first_name, ' ', s.student_last_name) as 'student full name',
 c.course_name, grades, date_of_completion from result r
inner join students s on s.student_ID = r.student_ID
inner join course c on c.course_ID = r.course_ID
where s.student_first_name = "rajkumar";


-- scorecard for any given student that shows only his best score per course
select concat(s.student_first_name, ' ',s.student_last_name) as 'student name',
c.course_name, max(grades) 'max earned grades', date_of_completion
from result r
inner join students s on s.student_ID = r.student_ID
inner join course c on c.course_ID = r.course_ID
where s.student_first_name = "rajkumar"
group by c.course_name;


-- scorecard for any given student that shows only his latest score per course
select result.result_id, result.course_ID, course.course_name, result.student_ID, students.student_first_name, result.date_of_completion, result.grades from (
	SELECT result.course_ID, result.student_ID, MAX(date_of_completion) as latestDate
	FROM result INNER JOIN students s on s.student_ID = result.student_ID
	where s.student_first_name = "rajkumar"
	GROUP BY course_ID
) r
inner join result on result.student_ID = r.student_ID
inner join course on course.course_ID = r.course_ID
inner join students on students.student_ID = result.student_ID
where result.course_ID = r.course_ID and r.latestDate = result.date_of_completion;


-- the best score obtained (by any students) per course along with the name of the student. Kind of the like topper of each course.
select s.student_ID, concat(s.student_first_name, ' ', s.student_last_name) as 'student name', c.course_name, MAX(grades) as 'highest individual grades'
from result
inner join students s on s.student_ID = result.student_ID
inner join course c on c.course_ID = result.course_ID
where s.student_first_name = "rajkumar"
group by result.student_ID, result.course_ID;
