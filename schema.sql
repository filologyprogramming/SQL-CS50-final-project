-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

-- Clients table
CREATE TABLE "clients" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "date_of_birth" TEXT NOT NULL,
    "PESEL" TEXT UNIQUE NOT NULL,
    "card" INTEGER NOT NULL,
    "gym" INTEGER NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("card") REFERENCES "cards" ("id"),
    FOREIGN KEY ("gym") REFERENCES "gyms" ("id")
);

-- Trainers table
CREATE TABLE "trainers" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "date_of_birth" TEXT NOT NULL,
    "PESEL" TEXT UNIQUE NOT NULL,
    "gym" INTEGER NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("gym") REFERENCES "gyms" ("id")
);

-- Gyms table
CREATE TABLE "gyms" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "city" TEXT NOT NULL,
    "voivodeship" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

-- Classes table
CREATE TABLE "classes" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "intensity" TEXT NOT NULL CHECK("intensity" IN ('low', 'moderate', 'high')),
    "length" INTEGER NOT NULL,
    "day_of_conduct" TEXT NOT NULL,
    "card" INTEGER CHECK("card" IN (1, 2, 3)),
    "gym" INTEGER NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("card") REFERENCES "cards" ("id"),
    FOREIGN KEY ("gym") REFERENCES "gyms" ("id")
);

-- Membership table
CREATE TABLE "cards" (
    "id" INTEGER,
    "name" TEXT NOT NULL CHECK ("name" IN ('Standard', 'Silver', 'Premium')),
    PRIMARY KEY ("id")
);

-- Table showing which client has a personal trainer
CREATE TABLE "client_trainer" (
    "id" INTEGER,
    "client" INTEGER NOT NULL UNIQUE,
    "trainer" INTEGER,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("client") REFERENCES "clients" ("id"),
    FOREIGN KEY ("trainer") REFERENCES "trainers" ("id")
);

-- Table showing which client attends a class
CREATE TABLE "client_class" (
    "id" INTEGER,
    "client" INTEGER NOT NULL,
    "class" INTEGER,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("client") REFERENCES "clients" ("id"),
    FOREIGN KEY ("class") REFERENCES "classes" ("id")
);

-- Table showing who conducts a class
CREATE TABLE "class_trainer" (
    "id" INTEGER,
    "class" INTEGER NOT NULL UNIQUE,
    "trainer" INTEGER NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("class") REFERENCES "classes" ("id"),
    FOREIGN KEY ("trainer") REFERENCES "trainers" ("id")
);

-- A trigger ensuring that a client can join only classes to which their card has access to
 -- Check if the client ID is correct
 -- Check, if card is greater or equal to what a class requires
CREATE TRIGGER client_joining_class
BEFORE INSERT ON client_class
FOR EACH ROW
BEGIN
    SELECT RAISE (ABORT, 'Client does not have access.')
    WHERE NOT EXISTS (
        SELECT 1
        FROM clients
        JOIN cards ON cards.id = clients.card
        WHERE clients.id = NEW.client
        AND CAST (NEW.class AS INTEGER) <= CAST (cards.id AS INTEGER)
    );
END;

-- Check if a person joins the class in the correct gym
-- Make sure client id is correct
-- Make sure class id is correct
-- Check if the client signs-up to the right gym

CREATE TRIGGER client_gym
BEFORE INSERT ON client_class
FOR EACH ROW
BEGIN
    SELECT RAISE (ABORT, 'Wrong Gym')
    WHERE NOT EXISTS (
        SELECT 1
        FROM clients
        JOIN gyms ON gyms.id = clients.gym
        JOIN classes ON classes.gym = gyms.id
        WHERE NEW.client = clients.id
        AND NEW.class = classes.id
        AND clients.gym = gyms.id
        );
END;

-- Make sure client id is correct
-- Make sure class id is correct
-- Check if the client signs-up to the right trainer

CREATE TRIGGER client_trainer
BEFORE INSERT ON client_trainer
FOR EACH ROW
BEGIN
    SELECT RAISE (ABORT, 'Wrong Gym')
    WHERE NOT EXISTS (
        SELECT 1
        FROM clients
        JOIN gyms ON gyms.id = clients.gym
        JOIN trainers ON trainers.gym = gyms.id
        WHERE NEW.client = clients.id
        AND NEW.trainer = trainers.id
        AND trainers.gym = clients.gym
        );
END;

-- Make sure client id is correct
-- Make sure class id is correct
-- Check if the trainer is signed to the class at the gym in the same city

CREATE TRIGGER class_trainer
BEFORE INSERT ON class_trainer
FOR EACH ROW
BEGIN
    SELECT RAISE (ABORT, 'Wrong Gym')
    WHERE NOT EXISTS (
        SELECT 1
        FROM trainers
        JOIN gyms ON gyms.id = trainers.gym
        JOIN classes ON classes.gym = gyms.id
        WHERE NEW.class = classes.id
        AND NEW.trainer = trainers.id
        AND trainers.gym = classes.gym
    );
END;