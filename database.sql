CREATE TABLE IF NOT EXISTS car_dealer (
    id INT AUTO_INCREMENT PRIMARY KEY,
    model VARCHAR(50) NOT NULL,
    price INT NOT NULL
);

INSERT INTO car_dealer (model, price) VALUES
('adder', 500000),
('banshee', 150000),
('bullet', 300000),
('cheetah', 250000),
('entityxf', 400000);