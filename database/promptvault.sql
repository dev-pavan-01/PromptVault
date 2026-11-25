CREATE DATABASE promptvault;

USE promptvault;

SHOW TABLES;

CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255)
);


CREATE TABLE Prompts (
    prompt_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    category_id INT NOT NULL,
    prompt_type VARCHAR(50) DEFAULT 'Text',
    ai_tool VARCHAR(100) DEFAULT 'Any',
    source_name VARCHAR(150),
    source_url VARCHAR(500),
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (category_id)
        REFERENCES Categories(category_id)
);


CREATE TABLE Tags (
    tag_id INT AUTO_INCREMENT PRIMARY KEY,
    tag_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Prompt_Tags (
    prompt_id INT,
    tag_id INT,

    PRIMARY KEY (prompt_id, tag_id),

    FOREIGN KEY (prompt_id)
        REFERENCES Prompts(prompt_id)
        ON DELETE CASCADE,

    FOREIGN KEY (tag_id)
        REFERENCES Tags(tag_id)
        ON DELETE CASCADE
);

CREATE TABLE Favorites (
    favorite_id INT AUTO_INCREMENT PRIMARY KEY,
    prompt_id INT NOT NULL UNIQUE,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (prompt_id)
        REFERENCES Prompts(prompt_id)
        ON DELETE CASCADE
);

SHOW TABLES;