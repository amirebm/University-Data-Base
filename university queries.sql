use [University]

-- 1- نام دانشجویانی را بیابید که در نیمسال اول 80 درس پایگاه داده ها را گرفته اند

select Student.Sname  from g,Course,Student where
term='801' and Student.Student_ID=g.Std_ID and Course.Cname= N'پایگاه داده ها'
and g.Crs_ID=Course.Crs_ID


-- 2- نام دانشجویانی را بیابید که در نیمسال اول 80 درس پایگاه داده ها را نگرفته اند.

select Student.Sname from Student,g where term='801'and  
Student.Student_ID=g.Std_ID and  g.Std_ID not in
 (	select g.Std_ID  from g,Course where
 Course.Cname= N'پایگاه داده ها'
and g.Crs_ID=Course.Crs_ID)

-- 3-نام دانشجویانی را بیابید که در نیمسال اول 80 هیچ درسی نگرفته اند

select distinct (Student.Sname) from Student,g where 
 Student.Student_ID=g.Std_ID and g.Std_ID 
 not in( select distinct (g.Std_ID) from g where term='801')

--4-لیستی از نام دروس تخصصی رشته مهندسی کامپیوتر تهیه کنید

select Course.Cname from Course,cf,Field where 
Course.Crs_ID=CF.Crs_ID and cf.kind='T' and
 Field.Field_ID=cf.Field_ID  and  Field.Field_Name= 'computer' 
 -- کامپیوتر به فارسی را پیدا نکرد! ---> Field.Field_Name= N'کامپیوتر'

--5- تعداد دروس تخصصی رشته مهندسی کامپیوتر را به دست آورید
select count(Course.Cname) from Course,cf,Field where 
Course.Crs_ID=CF.Crs_ID and cf.kind='T' and
 Field.Field_ID=cf.Field_ID  and  Field.Field_Name= 'computer' 


--6- لیستی از شماره دانشجویان مهندسی کامپیوتر و تعداد کل درسهای تخصصی گذرانده شده توسط هر یک از آنها تهیه کنید

select g.Std_ID, COUNT(g.Crs_ID) from g,Student,Field where g.Std_ID= Student.Student_ID 
and Student.Field_ID=Field.Field_ID and Field_Name='computer' and g.Gradent>10  group by g.Std_ID

--7- شماره دانشجویان مهندسی کامپیوتری را بیابید که کلیه درسهای تخصصی رشته خود را گذرانده اند

select distinct (g.Std_ID) from Student,Field,g where field.Field_Name='computer' and 
Field.Field_ID=Student.Field_ID  and g.Crs_ID in(select  distinct (cf.Crs_ID) from CF,Field 
where cf.Field_ID=Field.Field_ID and field.Field_Name<>'computer')


--8- شماره دانشجویان مهندسی کامپیوتری را بیابید  که کلیه درسهای تخصصی رشته خود را نگذرانده اند

select Student.Student_ID from Student,Field where Student.Field_ID=Field.Field_ID and Field.Field_Name=N'computer'
and Student.Student_ID not in (select distinct (g.Std_ID) from g,CF where G.Crs_ID=CF.Crs_ID and cf.kind='T')

select distinct (Student.Student_ID) from Student,Field where field.Field_Name='computer' and Field.Field_ID=Student.Field_ID
 and student.Student_ID not in (select distinct (g.Std_ID) from g,Student,Field where g.Std_ID=Student.Student_ID and
 field.Field_Name='computer' and Field.Field_ID=Student.Field_ID and g.Crs_ID not in 
 (select  cf.Crs_ID from CF,Field where cf.Field_ID=Field.Field_ID 
 and field.Field_Name='computer'))


 
--9- شماره دانشجویان مهندسی کامپیوتری را بیابید که درس نخصصی مربوط به مهندسی کامپیوتر وجود دارد که این دانشجویان آنها را نگذرانده باشد.

select Student.Student_ID from Student,Field where field.Field_Name='computer'and Field.Field_ID=Student.Field_ID 
and student.Student_ID in(select g.Std_ID from g 
Group by g.Std_ID having count (g.Crs_ID) < 
(select  count (cf.Crs_ID) from CF,Field where cf.Field_ID=Field.Field_ID and field.Field_Name='computer'))

--10- لیستی از شماره دانشجویان و تعداد کل واحدهای گذرانده شده توسط هر یک از آنها تهیه کنید.

select g.Std_ID,sum(Course.unit) from g,Course where Course.Crs_ID=g.Crs_ID group by g.Std_ID

--11- لیستی از نام کلیه دانشجویان و تعداد کل واحدهای گذرانده شده توسط هر یک از آنها تهیه کنید

select Student.Sname,sum(Course.unit) from g,Course,Student where 
Course.Crs_ID=g.Crs_ID and g.Std_ID=student.Student_ID group by Student.Sname 


--12- لیستی از شماره دانشجویان که مجموعا بیش از 100 واحد درس گذرانده اند تهیه کنید.

select g.Std_ID from g,Course where Course.Crs_ID=g.Crs_ID group by g.Std_ID having sum(Course.unit)>100


-- 13- لیستی از نام دانشجویانی که مجموعا بیش از 100 واحد درس گذرانده اند تهیه کنید.

select Student.Sname from g,Course,Student where 
Course.Crs_ID=g.Crs_ID and g.Std_ID=student.Student_ID group by Student.Sname having sum(Course.unit)>100



--14-  لیستی از شماره دانشجویی کلیه دانشجویان ورودی 80 و معدل هر یک از آنها در نیمسال اول 81 تهیه کنید


select g.Std_ID, (sum(g.Gradent*Course.unit))/sum(Course.unit) as moadel  from g,Student,Course
where  Student.Start_Year='80' and g.Term='811' and
Student.Student_ID=g.Std_ID and g.Crs_ID=Course.Crs_ID group by g.Std_ID 


--15-  لیستی از نام  دانشجویان ورودی 80 و معدل هر یک از آنها در نیمسال اول 81  بیشتر از 18 بوده است تهیه کنید

select Student.Sname from g,Student,Course
where  Student.Start_Year='80' and g.Term='811' and
Student.Student_ID=g.Std_ID and g.Crs_ID=Course.Crs_ID 
group by Student.Sname having (sum(g.Gradent*Course.unit))/sum(Course.unit) >18


--16-  لیستی از نام اساتیدی که  درس پایگاه داده ها را تدریس کرده اند را تهیه کنید

select prof.Pname from prof,pc,Course where prof.prof_ID=pc.prof_ID and pc.Crs_ID=Course.Crs_ID

and Course.Cname= N'پایگاه داده ها'

--17- لیستی از شماره اساتیدی که درس پایگاه داده ها را بیش از چهار ترم تدریس کرده اند تهیه کنید

select pc.prof_ID from pc,Course where pc.Crs_ID=Course.Crs_ID

and Course.Cname= N'پایگاه داده ها'  group by pc.prof_ID having count(PC.Term) >2
--18- لیستی از نام دروس عملی تهیه کنید که توسط استاد شماره 100 در نیمسال دوم 83 تدریس شده اند

select Course.Cname from Course,PC,Type_Course where Course.Crs_ID=PC.Crs_ID and PC.prof_ID='108' and
 Course.TypeC_ID=Type_Course.TypeC_ID and Type_Course.TypeC_Name= N'عملی'

--19-   لیستی از شماره دورسی تهیه کنید که پیش نیاز درس پایگاه داده ها هستند

select 

--20- لیستی از نام دروسی تهیه کنید که پیش نیاز درس پایگاه داده ها هستند

select Course.Cname from Course where Course.Crs_ID  in(select pre.Pre_ID from pre,Course 

where Course.Crs_ID=Pre.course_ID and Course.Cname=N'پایگاه داده ها')


