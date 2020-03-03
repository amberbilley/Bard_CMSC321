CREATE TABLE PUBLISHER (
  Name VARCHAR(30) NOT NULL,
  Address VARCHAR(255),
  Phone INT(10),
  PRIMARY KEY (Name)
);
CREATE TABLE `BOOK` (
  `Book_id` INT NOT NULL,
  `Title` VARCHAR(255) NOT NULL,
  `Publisher_name` VARCHAR(30),
  PRIMARY KEY(`Book_id`),
  FOREIGN KEY(`Publisher_name`) REFERENCES PUBLISHER(`Name`)
);
CREATE TABLE BOOK_AUTHORS (
  Book_id INT,
  Author_name VARCHAR(30),
  PRIMARY KEY (Author_name),
  FOREIGN KEY (Book_id) REFERENCES BOOK(Book_id)
);
CREATE TABLE LIBRARY_BRANCH (
  Branch_id INT NOT NULL,
  Branch_name VARCHAR(255),
  Address VARCHAR(255),
  PRIMARY KEY (Branch_id)
);
CREATE TABLE BOOK_COPIES (
  Book_id INT,
  Branch_id INT,
  No_of_copies INT(3),
  FOREIGN KEY (Book_id) REFERENCES BOOK(Book_id),
  FOREIGN KEY (Branch_id) REFERENCES LIBRARY_BRANCH(Branch_id)
);
CREATE TABLE BORROWER (
  Card_no INT NOT NULL,
  Name VARCHAR(30),
  Address VARCHAR(255),
  Phone INT(10),
  PRIMARY KEY (Card_no)
);
CREATE TABLE BOOK_LOANS (
  Book_id INT,
  Branch_id INT,
  Card_no INT,
  Date_out DATE,
  Due_date DATE,
  FOREIGN KEY (Book_id) REFERENCES BOOK(Book_id),
  FOREIGN KEY (Branch_id) REFERENCES LIBRARY_BRANCH(Branch_id),
  FOREIGN KEY (Card_no) REFERENCES BORROWER(Card_no)
)
