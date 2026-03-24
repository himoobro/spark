-- ============================================
-- SPARK Database Schema
-- Team: S.C. CHAMPS
-- Project: Student Idea Validation Platform
-- ============================================

CREATE DATABASE IF NOT EXISTS spark_db;
USE spark_db;

-- 1. Users Table (students, experts, admins)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('student', 'expert', 'admin') DEFAULT 'student',
    university_roll VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Ideas Table (submitted by students)
CREATE TABLE ideas (
    idea_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(100),
    status ENUM('pending', 'active', 'shortlisted', 'funded', 'rejected') DEFAULT 'pending',
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(user_id)
);

-- 3. Ratings Table (community rates ideas)
CREATE TABLE ratings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    idea_id INT NOT NULL,
    user_id INT NOT NULL,
    score INT CHECK (score BETWEEN 1 AND 5),
    comment TEXT,
    rated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idea_id) REFERENCES ideas(idea_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    UNIQUE (idea_id, user_id)
);

-- 4. Expert Reviews Table (experts evaluate shortlisted ideas)
CREATE TABLE expert_reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    idea_id INT NOT NULL,
    expert_id INT NOT NULL,
    feedback TEXT,
    score INT CHECK (score BETWEEN 1 AND 10),
    reviewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idea_id) REFERENCES ideas(idea_id),
    FOREIGN KEY (expert_id) REFERENCES users(user_id)
);

-- 5. Funding Records Table (tracks funded ideas)
CREATE TABLE funding_records (
    funding_id INT AUTO_INCREMENT PRIMARY KEY,
    idea_id INT NOT NULL,
    amount DECIMAL(10,2),
    approved_by INT,
    approved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('approved', 'disbursed', 'on_hold') DEFAULT 'approved',
    FOREIGN KEY (idea_id) REFERENCES ideas(idea_id),
    FOREIGN KEY (approved_by) REFERENCES users(user_id)
);