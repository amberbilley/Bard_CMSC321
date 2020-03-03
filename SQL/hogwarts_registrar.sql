USE HOGWARTS_REGISTRAR;

CREATE TABLE STUDENT (
  matric_no CHAR(8),
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  date_of_birth DATE,
  PRIMARY KEY (matric_no)
);
INSERT INTO STUDENT VALUES (40001010,'Daniel','Radcliff','1989-07-23');
INSERT INTO STUDENT VALUES (40001011,'Emma','Watson','1990-04-15');
INSERT INTO STUDENT VALUES (40001012,'Rupert','Grint','1988-10-24');

CREATE TABLE MODULE (
  module_code CHAR(8),
  module_title VARCHAR(50) NOT NULL,
  level INT NOT NULL,
  credits INT NOT NULL DEFAULT '20',
  PRIMARY KEY (module_code)
);
INSERT INTO MODULE VALUES
  ('HUF07101','Herbology','7',DEFAULT),
  ('SLY07102','Defense Against the Dark Arts','7',DEFAULT),
  ('HUF08102','History of Magic','8',DEFAULT);

CREATE TABLE REGISTRATION (
  matric_no CHAR(8),
  module_code VARCHAR(50) NOT NULL,
  result DECIMAL(4,1),
  FOREIGN KEY (matric_no) REFERENCES STUDENT(matric_no),
  FOREIGN KEY (module_code) REFERENCES MODULE(module_code)
) ;
INSERT INTO registration VALUES ('40001010','SLY07102',90);
INSERT INTO registration VALUES ('40001010','HUF07101',40);
INSERT INTO registration VALUES ('40001010','HUF08102',null);

INSERT INTO registration VALUES ('40001011','SLY07102',99);
INSERT INTO registration VALUES ('40001011','HUF08102',null);

INSERT INTO registration VALUES ('40001012','SLY07102',20);
INSERT INTO registration VALUES ('40001012','HUF07101',20);
