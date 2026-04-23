CREATE DATABASE IF NOT EXISTS family_bonding_db;
USE family_bonding_db;

CREATE TABLE IF NOT EXISTS Family (
    family_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    family_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS User (
    user_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'FAMILY_MEMBER', -- SYSTEM_ADMIN, FAMILY_ADMIN, FAMILY_MEMBER, GUEST
    points INT DEFAULT 0,
    profile_picture_url VARCHAR(255),
    phone_number VARCHAR(20),
    family_id INT,
    FOREIGN KEY (family_id) REFERENCES Family(family_id) ON DELETE SET NULL
);


CREATE TABLE IF NOT EXISTS Shopping_Item (
    item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    quantity VARCHAR(50),
    is_bought BOOLEAN DEFAULT FALSE,
    added_by INT,
    family_id INT NOT NULL,
    FOREIGN KEY (added_by) REFERENCES User(user_id) ON DELETE SET NULL,
    FOREIGN KEY (family_id) REFERENCES Family(family_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Badge (
    badge_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    icon_url VARCHAR(255),
    description TEXT
);

CREATE TABLE IF NOT EXISTS User_Badge (
    user_id INT,
    badge_id INT,
    awarded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, badge_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (badge_id) REFERENCES Badge(badge_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Chartboard_Post (
    post_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    content TEXT NOT NULL,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Comment (
    comment_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES Chartboard_Post(post_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Challenge (
    challenge_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    points_value INT DEFAULT 50,
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES User(user_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS User_Challenge (
    user_id INT,
    challenge_id INT,
    status VARCHAR(50) DEFAULT 'IN_PROGRESS', -- COMPLETED, IN_PROGRESS
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, challenge_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (challenge_id) REFERENCES Challenge(challenge_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Question (
    question_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    content TEXT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Answer (
    answer_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    content TEXT NOT NULL,
    user_id INT NOT NULL,
    question_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES Question(question_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Notification (
    notification_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Calendar_Event (
    event_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    event_date DATETIME NOT NULL,
    location VARCHAR(255),
    family_id INT NOT NULL,
    created_by INT,
    FOREIGN KEY (family_id) REFERENCES Family(family_id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES User(user_id) ON DELETE SET NULL
);

-- Default Challenges
INSERT IGNORE INTO Challenge (title, description) VALUES 
('Family MasterChef', 'Cook a full 3-course meal together from scratch. No ordering in allowed!'),
('No Screen Sunday', 'Spend an entire Sunday without using any phones, computers, or the TV.'),
('Nature Explorers', 'Go for a 1-hour walk or hike in a local park, forest, or beach.'),
('Board Game Marathon', 'Host a family game night and play at least 3 different board games.'),
('Digital Time Capsule', 'Collect 10 family photos and a short video message to be "opened" in 5 years.'),
('Puzzle Masters', 'Work together to complete a jigsaw puzzle of at least 500 pieces.'),
('Acts of Kindness', 'As a family, perform 3 small acts of kindness for neighbors or strangers.'),
('Backyard Campout', 'Set up a tent in the backyard or a "fort" in the living room and sleep there for a night.'),
('Family Workout', 'Complete a 30-minute exercise or yoga session together as a team.');
