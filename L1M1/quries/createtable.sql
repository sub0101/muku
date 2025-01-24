--   Creating the tables  
  CREATE TABLE student (
    sid INT PRIMARY KEY,
    sname VARCHAR(100),
    sex CHAR(1),
    age INT,
    year INT,
    gpa NUMERIC(12, 10)
);

CREATE TABLE dept (
    dname VARCHAR(100) PRIMARY KEY,
    numphds INT
);

CREATE TABLE prof (
    pname VARCHAR(100),
    dname VARCHAR(100),
    PRIMARY KEY (pname),
    FOREIGN KEY (dname) REFERENCES dept(dname)
);

CREATE TABLE course (
    cno INT,
    cname VARCHAR(100),   
    dname VARCHAR(100),
    PRIMARY KEY (dname, cno),
    FOREIGN KEY (dname) REFERENCES dept(dname)
);

CREATE TABLE major (
    dname VARCHAR(100),
    sid INT,
    PRIMARY KEY (dname, sid),
    FOREIGN KEY (dname) REFERENCES dept(dname),
    FOREIGN KEY (sid) REFERENCES student(sid)
);

CREATE TABLE section (
    dname VARCHAR(100),
    cno INT,
    sectno INT,
    pname VARCHAR(100),
    PRIMARY KEY (dname, cno, sectno),
    FOREIGN KEY (dname) REFERENCES dept(dname),
    FOREIGN KEY (cno,dname) REFERENCES course(cno,dname),
    FOREIGN KEY (pname) REFERENCES prof(pname)
);

CREATE TABLE enroll (
    sid INT,
     gpa NUMERIC(12, 10),
    dname VARCHAR(100),
    cno INT,
    sectno INT,
   
    PRIMARY KEY (sid, dname, cno, sectno),
    FOREIGN KEY (sid) REFERENCES student(sid),
    FOREIGN KEY (dname) REFERENCES dept(dname),
    FOREIGN KEY (cno,dname) REFERENCES course(cno,dname),
    FOREIGN KEY (dname,cno,sectno) 
    REFERENCES section(dname, cno, sectno)
);