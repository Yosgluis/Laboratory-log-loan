-- 'users' table
CREATE TABLE IF NOT EXISTS users(
    ID VARCHAR(20) PRIMARY KEY,
    username VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(70) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 'computers' table (computers inventory)
CREATE TABLE IF NOT EXISTS computers(
    ID INT AUTO_INCREMENT PRIMARY KEY,
    asset_code VARCHAR(30) UNIQUE NOT NULL,
    serial_number VARCHAR(50) UNIQUE NOT NULL,
    brand VARCHAR(40) NOT NULL,
    model VARCHAR(40) NOT NULL,
    processor VARCHAR(60) NOT NULL,
    ram_gb INT NOT NULL CHECK(ram_gb > 0), -- there cannot be negative values of ram or 0
    storage_gb INT NOT NULL CHECK(storage_gb > 0), -- there cannot be negative values of storeage or 0
    storage_type VARCHAR(10) CHECK(storage_type IN ('HDD', 'SSD', 'NVMe')),
    location_lab VARCHAR(20) NOT NULL,
    status VARCHAR(15) CHECK(status IN ('AVAILABLE', 'IN_USE', 'MAINTENANCE', 'RETIRED')),

    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 'students' table
CREATE TABLE IF NOT EXISTS students(
    ID VARCHAR(20) PRIMARY KEY,
    full_name VARCHAR(70) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    career VARCHAR(60) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 'loans' table
CREATE TABLE IF NOT EXISTS loans(
    ID INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20) NOT NULL,
    computer_id INT NOT NULL,
    created_by_user_id VARCHAR(20) NOT NULL,
    returned_to_user_id VARCHAR(20),
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estimated_end_time TIMESTAMP NOT NULL,
    return_time TIMESTAMP,
    status VARCHAR(15) CHECK (status IN ('ACTIVE', 'RETURNED', 'CANCELLED', 'OVERDUE')),
    notes_delivery VARCHAR(255),
    notes_return VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- FK from 'users' table
    CONSTRAINT fk_created_by
        FOREIGN KEY (created_by_user_id)
        REFERENCES users(ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_returned_by
        FOREIGN KEY (returned_to_user_id)
        REFERENCES users(ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    -- FK from 'computers' table
    CONSTRAINT fk_loaned_computer
        FOREIGN KEY (computer_id)
        REFERENCES computers(ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    -- FK from 'students' table
    CONSTRAINT fk_loaned_student
        FOREIGN KEY (student_id)
        REFERENCES students(ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Computer incidents
CREATE TABLE IF NOT EXISTS computer_incidents(
    ID INT AUTO_INCREMENT PRIMARY KEY,
    computer_id INT NOT NULL,
    loan_id INT NULL,
    reported_by_user_id VARCHAR(20) NOT NULL,
    severity VARCHAR(10) CHECK(severity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    status VARCHAR(15) CHECK(status IN ('OPEN', 'IN PROGRESS', 'RESOLVED')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- FK from 'users' table
    CONSTRAINT fk_incident_reported_by
        FOREIGN KEY (reported_by_user_id)
        REFERENCES users(ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    
    -- FK from 'computers' table
    CONSTRAINT fk_incident_computer
        FOREIGN KEY (computer_id)
        REFERENCES computers(ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    
    -- FK from 'loans' table
    CONSTRAINT fk_incident_loan
        FOREIGN KEY (loan_id)
        REFERENCES loans(ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);