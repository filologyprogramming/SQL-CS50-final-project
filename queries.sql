-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- How many people in all gyms train crossfit?
SELECT COUNT(id) FROM client_class
    WHERE class IN (
        SELECT id FROM classes
        WHERE name = "Cross Fit"
    );

-- How many people are signed up to a gym?
SELECT COUNT(clients.id) FROM clients
JOIN gyms ON gyms.id = clients.gym
WHERE clients.gym = 1;

-- In which cities can I join Kettlebells?
SELECT gyms.city FROM gyms
JOIN classes ON classes.id = gyms.id
WHERE classes.name = "Kettlebells";

-- How many trainers from a gym have individual classes
SELECT COUNT(DISTINCT trainer) FROM client_trainer
JOIN trainers ON trainers.id = client_trainer.trainer
JOIN gyms ON gyms.id = trainers.gym
WHERE gyms.id = 1;

-- Which type of subscription is the most common in a city
SELECT COUNT(id), clients.card FROM clients
   WHERE clients.gym = 2
   GROUP BY clients.card;

-- Changing a type of the card a client has
UPDATE clients
SET card = 2
WHERE id = 2;

-- How many people train with a trainer at a gym
SELECT COUNT(client) FROM client_trainer
JOIN trainers ON trainers.id = client_trainer.trainer
JOIN gyms ON gyms.id = trainers.gym
WHERE gyms.name = "BeBig Gym";

-- Inserting new gyms
INSERT INTO gyms (name, city, voivodeship)
VALUES
("BeBig Gym", "Poznań", "wielkopolska");

INSERT INTO gyms (name, city, voivodeship)
VALUES
("No Pain, No Gain", "Warszawa", "mazowieckie");

-- Inserting cards to new gyms
INSERT INTO cards (name)
VALUES
("Standard");

INSERT INTO cards (name)
VALUES
("Silver");

INSERT INTO cards (name)
VALUES
("Premium");

-- Inserting clients
INSERT INTO clients (first_name, last_name, date_of_birth, PESEL, card, gym)
VALUES
("John", "Smith", "24-08-1980", "34567238769", 3, 1);

INSERT INTO clients (first_name, last_name, date_of_birth, PESEL, card, gym)
VALUES
("Eva", "Yellow", "13-12-1990", "35367567432", 1, 1);

INSERT INTO clients (first_name, last_name, date_of_birth, PESEL, card, gym)
VALUES
("Jack", "Skinny", "29-01-2001", "44569029271", 2, 2);

-- Insert classes
INSERT INTO classes (name, intensity, length, day_of_conduct, card, gym)
VALUES
("Cross Fit", "moderate", 40, "Thursday", 1, 2);

INSERT INTO classes (name, intensity, length, day_of_conduct, card, gym)
VALUES
("Kettlebells", "low", 50, "Friday", 2, 1);

INSERT INTO classes (name, intensity, length, day_of_conduct, card, gym)
VALUES
("Healthy spine", "low", 50, "Wednesday", 3, 1);

-- Insert trainers
INSERT INTO trainers (first_name, last_name, date_of_birth, PESEL, gym)
VALUES
("Max", "Muscles", "19-05-1996", "89075637483", 1);

INSERT INTO trainers (first_name, last_name, date_of_birth, PESEL, gym)
VALUES
("Mr", "Flex", "31-12-1990", "18306967843", 2);

-- Sign up people to classes
INSERT INTO client_class (client, class)
VALUES
(2, 3);


