USE library_management;

CREATE TABLE Authors (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Bio TEXT
);

CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    AuthorID INT,
    Genre VARCHAR(50),
    PublishedDate DATE,
    ISBN VARCHAR(20),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

CREATE TABLE Borrowers (
    BorrowerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255),
    Phone VARCHAR(20)
);

CREATE TABLE Loans (
    LoanID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT,
    BorrowerID INT,
    LoanDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (BorrowerID) REFERENCES Borrowers(BorrowerID)
);
INSERT INTO Authors (Name, Bio) VALUES ('J.K. Rowling', 'Author of the Harry Potter series.');
SELECT Books.Title, Authors.Name
FROM Books
JOIN Authors ON Books.AuthorID = Authors.AuthorID;

CREATE DATABASE ecommerce;

USE ecommerce;

CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);

CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2),
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Address VARCHAR(255)
);

CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    CustomerID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment TEXT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

SELECT Products.Name, SUM(OrderDetails.Quantity * OrderDetails.UnitPrice) AS TotalSales
FROM OrderDetails
JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY Products.Name;

SELECT Orders.OrderID, Orders.OrderDate, Orders.TotalAmount
FROM Orders
WHERE Orders.CustomerID = 1;

SELECT Orders.OrderID, Orders.OrderDate, Orders.TotalAmount
FROM Orders
WHERE Orders.CustomerID = 1;

CREATE DATABASE hospital_management;

USE hospital_management;

CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    DateOfBirth DATE,
    Gender CHAR(1),
    ContactInfo VARCHAR(100)
);

CREATE TABLE Doctors (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Specialty VARCHAR(100),
    ContactInfo VARCHAR(100)
);

CREATE TABLE Appointments (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATE,
    Reason VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE TABLE Treatments (
    TreatmentID INT AUTO_INCREMENT PRIMARY KEY,
    AppointmentID INT,
    TreatmentDescription TEXT,
    Cost DECIMAL(10, 2),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);

SELECT Patients.Name, Appointments.AppointmentDate, Appointments.Reason
FROM Appointments
JOIN Patients ON Appointments.PatientID = Patients.PatientID
WHERE Appointments.DoctorID = 1;

SELECT SUM(Treatments.Cost) AS TotalTreatmentCost
FROM Treatments
JOIN Appointments ON Treatments.AppointmentID = Appointments.AppointmentID
WHERE Appointments.PatientID = 1;

CREATE DATABASE inventory_management;

USE inventory_management;

CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);

CREATE TABLE Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    ContactInfo VARCHAR(100)
);

CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    CategoryID INT,
    SupplierID INT,
    Price DECIMAL(10, 2),
    StockQuantity INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE StockMovements (
    MovementID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    MovementType ENUM('IN', 'OUT'),
    Date DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

SELECT ProductName, StockQuantity
FROM Products;

INSERT INTO StockMovements (ProductID, Quantity, MovementType, Date)
VALUES (1, 100, 'IN', CURDATE());

CREATE DATABASE student_enrollment;

USE student_enrollment;

CREATE TABLE Students (
    StudentID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    DateOfBirth DATE,
    Address VARCHAR(255),
    Email VARCHAR(100)
);

CREATE TABLE Courses (
    CourseID INT AUTO_INCREMENT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    InstructorID INT,
    Credits INT
);

CREATE TABLE Enrollments (
    EnrollmentID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE Instructors (
    InstructorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Department VARCHAR(100)
);

CREATE TABLE Grades (
    GradeID INT AUTO_INCREMENT PRIMARY KEY,
    EnrollmentID INT,
    Grade CHAR(1),
    FOREIGN KEY (EnrollmentID) REFERENCES Enrollments(EnrollmentID)
);

SELECT Courses.CourseName
FROM Enrollments
JOIN Courses ON Enrollments.CourseID = Courses.CourseID
WHERE Enrollments.StudentID = 1;

SELECT Courses.CourseName, AVG(CASE WHEN Grades.Grade = 'A' THEN 4 WHEN Grades.Grade = 'B' THEN 3 WHEN Grades.Grade = 'C' THEN 2 WHEN Grades.Grade = 'D' THEN 1 ELSE 0 END) AS AverageGrade
FROM Grades
JOIN Enrollments ON Grades.EnrollmentID = Enrollments.EnrollmentID
JOIN Courses ON Enrollments.CourseID = Courses.CourseID
GROUP BY Courses.CourseName;