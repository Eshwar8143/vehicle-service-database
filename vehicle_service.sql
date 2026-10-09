CREATE DATABASE IF NOT EXISTS veh_service_db;
USE veh_service_db;

-- ==========================================
-- 1. CORE TABLES & ENTITIES
-- ==========================================

CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(50) UNIQUE,
    address VARCHAR(100)
);

CREATE TABLE vehicle (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    veh_no VARCHAR(20) UNIQUE NOT NULL,
    veh_type VARCHAR(50) NOT NULL,
    make VARCHAR(50),
    model VARCHAR(50),
    year INT CHECK (year BETWEEN 1950 AND 2026),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);

CREATE TABLE mechanic (
    mechanic_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    skill_specialist VARCHAR(50) NOT NULL
);

CREATE TABLE service (
    ser_id INT AUTO_INCREMENT PRIMARY KEY,
    ser_name VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE spare_part (
    spare_id INT AUTO_INCREMENT PRIMARY KEY,
    spare_name VARCHAR(50) NOT NULL,
    brand VARCHAR(50),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    stock_quantity INT CHECK (stock_quantity >= 0)
);

CREATE TABLE supplier (
    supp_id INT AUTO_INCREMENT PRIMARY KEY,
    supp_name VARCHAR(50) NOT NULL,
    address VARCHAR(100),
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(50) UNIQUE
);

-- ==========================================
-- 2. TRANSACTIONAL & OPERATIONAL TABLES
-- ==========================================

CREATE TABLE job_card (
    job_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT NOT NULL,
    mechanic_id INT NOT NULL,
    arrival_date DATE NOT NULL,
    delivery_date DATE, -- NULL for pending jobs
    work_status VARCHAR(50) NOT NULL CHECK (work_status IN ('Pending', 'Completed', 'In Progress')),
    FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id) ON DELETE CASCADE,
    FOREIGN KEY (mechanic_id) REFERENCES mechanic(mechanic_id) ON DELETE CASCADE
);

CREATE TABLE job_services (
    job_id INT NOT NULL,
    ser_id INT NOT NULL,
    PRIMARY KEY (job_id, ser_id),
    FOREIGN KEY (job_id) REFERENCES job_card(job_id) ON DELETE CASCADE,
    FOREIGN KEY (ser_id) REFERENCES service(ser_id) ON DELETE CASCADE
);

CREATE TABLE service_part (
    job_id INT NOT NULL,
    spare_id INT NOT NULL,
    quantity_used INT NOT NULL CHECK (quantity_used > 0),
    -- price_applied represents the total calculated price for the quantity of spare parts used (unit_price * quantity_used)
    price_applied DECIMAL(10,2) NOT NULL CHECK (price_applied >= 0),
    PRIMARY KEY (job_id, spare_id),
    FOREIGN KEY (job_id) REFERENCES job_card(job_id) ON DELETE CASCADE,
    FOREIGN KEY (spare_id) REFERENCES spare_part(spare_id) ON DELETE CASCADE
);

CREATE TABLE purchase (
    pur_id INT AUTO_INCREMENT PRIMARY KEY,
    supp_id INT NOT NULL,
    spare_id INT NOT NULL,
    pur_date DATE NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    total_cost DECIMAL(10,2) NOT NULL CHECK (total_cost >= 0),
    FOREIGN KEY (supp_id) REFERENCES supplier(supp_id),
    FOREIGN KEY (spare_id) REFERENCES spare_part(spare_id)
);

CREATE TABLE bill (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    job_id INT UNIQUE,
    bill_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    payment_status VARCHAR(50) NOT NULL CHECK (payment_status IN ('Paid', 'Pending')),
    FOREIGN KEY (job_id) REFERENCES job_card(job_id)
);

-- ==========================================
-- 3. SAMPLE DATA INSERTS
-- ==========================================

INSERT INTO customer (name, phone, email, address) VALUES
('Navdeep','9000000001','nav778@gmail.com','amberpet'),
('Charith','9000086575','charitrajj@gmail.com','Lb nagar'),
('Harshith','9876543456','harshithhgg@gmail.com','meerpet'),
('Satwik','9877773456','satwikerg@gmail.com','suryapet'),
('Mandeep','7796543456','manur@gmail.com','kukatpally'),
('sidharth','9956543456','sidhua@gmail.com','secunderabad'),
('Bhanu','9988543456','bhanuu@gmail.com','pochampally'),
('neeraj','9877788456','pneeraj@gmail.com','kothagudem'),
('omkar','9889943456','omigam@gmail.com','pochampally'),
('deepak','9870076456','deepakreddy@gmail.com','meerpet');

INSERT INTO vehicle (customer_id, veh_no, veh_type, make, model, year) VALUES
(1,'TS01AB1234','Bike','Hero','Splendor',2020),
(2,'AP02CD2345','Car','Maruti','Alto',2019),
(3,'TS03EF3456','Car','Hyundai','i20',2021),
(4,'AP04GH4567','Bike','Honda','Shine',2022),
(5,'TS05IJ5678','6 Wheeler','Tata','Truck',2018),
(6,'AP06KL6789','Car','Toyota','Innova',2020),
(7,'TS07MN7890','Bike','Bajaj','Pulsar',2021),
(8,'AP08OP8901','Car','Kia','Seltos',2022),
(9,'TS09QR9012','6 Wheeler','Ashok Leyland','Truck',2017),
(10,'AP10ST0123','Bike','TVS','Apache',2023);

-- Mechanics with specializations correctly aligned with vehicle types
INSERT INTO mechanic (name, phone, skill_specialist) VALUES
('Ramesh','8000000001','Bike'),
('Suresh','8000000002','Car'),
('Mahesh','8000000003','Car'),
('Naresh','8000000004','Bike'),
('Kiran','8000000005','6 Wheeler'),
('Rajesh','8000000006','Car'),
('Vijay','8000000007','6 Wheeler'),
('Ajay','8000000008','Car'),
('Teja','8000000009','6 Wheeler'),
('Arun','8000000010','Bike');

INSERT INTO service (ser_name, price) VALUES
('Oil Change',500),
('Engine Repair',5000),
('Wheel Alignment',800),
('Battery Check',300),
('Full Service',7000),
('Brake Service',1200),
('AC Repair',2500),
('Painting',6000),
('Tyre Change',1500),
('General Checkup',400);

INSERT INTO spare_part (spare_name, brand, unit_price, stock_quantity) VALUES
('Engine Oil','Castrol',500,50),
('Brake Pad','Bosch',800,30),
('Battery','Exide',4000,20),
('Tyre','MRF',3500,25),
('Clutch Plate','Valeo',2000,15),
('Air Filter','Bosch',600,40),
('Spark Plug','NGK',300,60),
('Headlight','Philips',1200,20),
('Radiator','Tata',5000,10),
('Chain Kit','Rolon',1500,18);

INSERT INTO supplier (supp_name, address, phone, email) VALUES
('ABC Suppliers','Hyderabad','7000000001','abc@gmail.com'),
('XYZ Traders','Vizag','7000000002','xyz@gmail.com'),
('Auto Parts Co','Guntur','7000000003','auto@gmail.com'),
('Speed Motors','Warangal','7000000004','speed@gmail.com'),
('Prime Parts','Nellore','7000000005','prime@gmail.com'),
('Mega Supplies','Kurnool','7000000006','mega@gmail.com'),
('Turbo Traders','Vijayawada','7000000007','turbo@gmail.com'),
('Elite Parts','Tirupati','7000000008','elite@gmail.com'),
('Fast Supply','Karimnagar','7000000009','fast@gmail.com'),
('Super Auto','Nizamabad','7000000010','super@gmail.com');

-- Job Cards (Pending jobs have NULL delivery dates; Job 7 assigned to bike specialist Mechanic 1)
INSERT INTO job_card (vehicle_id, mechanic_id, arrival_date, delivery_date, work_status) VALUES
(1,1,'2026-03-01','2026-03-02','Completed'),
(2,2,'2026-03-02','2026-03-04','Completed'),
(3,3,'2026-03-03','2026-03-05','Completed'),
(4,4,'2026-03-04',NULL,'Pending'),
(5,5,'2026-03-05','2026-03-08','Completed'),
(6,6,'2026-03-06',NULL,'Pending'),
(7,1,'2026-03-07','2026-03-10','Completed'), 
(8,8,'2026-03-08','2026-03-11','Completed'),
(9,9,'2026-03-09',NULL,'Pending'),
(10,10,'2026-03-10','2026-03-13','Completed');

INSERT INTO job_services (job_id, ser_id) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10);

INSERT INTO service_part (job_id, spare_id, quantity_used, price_applied) VALUES
(1,1,2,1000),
(2,2,1,800),
(3,3,1,4000),
(4,4,2,7000),
(5,5,1,2000),
(6,6,2,1200),
(7,7,3,900),
(8,8,1,1200),
(9,9,1,5000),
(10,10,2,3000);

INSERT INTO purchase (supp_id, spare_id, pur_date, quantity, total_cost) VALUES
(1,1,'2026-02-01',10,5000),
(2,2,'2026-02-02',5,4000),
(3,3,'2026-02-03',4,16000),
(4,4,'2026-02-04',6,21000),
(5,5,'2026-02-05',3,6000),
(6,6,'2026-02-06',7,4200),
(7,7,'2026-02-07',8,2400),
(8,8,'2026-02-08',2,2400),
(9,9,'2026-02-09',1,5000),
(10,10,'2026-02-10',3,4500);

-- Bills with amounts accurately matching Service + Parts total costs
INSERT INTO bill (job_id, bill_date, total_amount, payment_status) VALUES
(1,'2026-03-02',1500.00,'Paid'),       -- 500 service + 1000 parts
(2,'2026-03-04',5800.00,'Paid'),       -- 5000 service + 800 parts
(3,'2026-03-05',4800.00,'Paid'),       -- 800 service + 4000 parts
(4,'2026-03-06',7300.00,'Pending'),    -- 300 service + 7000 parts
(5,'2026-03-08',9000.00,'Paid'),       -- 7000 service + 2000 parts
(6,'2026-03-09',2400.00,'Pending'),    -- 1200 service + 1200 parts
(7,'2026-03-10',3400.00,'Paid'),       -- 2500 service + 900 parts
(8,'2026-03-11',7200.00,'Paid'),       -- 6000 service + 1200 parts
(9,'2026-03-12',6500.00,'Pending'),    -- 1500 service + 5000 parts
(10,'2026-03-13',3400.00,'Paid');      -- 400 service + 3000 parts