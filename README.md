# Design Document

By Patryk Paszkieiwcz

## Scope

The purpose of a database is to keep track of how the gym franchise works and develops. It could be used by gym owners to keep track of clients, classes and trainers across one gym, or, in case of owners of the whole franchise, across multiple gyms. The database includes clients, trainers, classes, membership cards, and gyms themselves.

The database doesnt't include such things as equipment, workers other than trainers, owners of gyms, number of lockers or rooms at a gym.

## Functional Requirements

A user of the database, should be able to:
- perform CRUD operations clients attending classes
- check whether clients use the services of a personal trainer
- chekc who conducts which class and when
- block clients' access to classes for which they do not have a right card
- look-up the trainer's occupancy, both regarding personal and group classes.
- look up which trainer is assigned to a specific gym.

A user of the database won't be able to create a weekly class schedule. The database keeps track only of days when a class takes place together with their duration but not specific hour.

### Entities

The database contains 5 entities:
The `clients` table includes:
- id, which specifies the unique ID for the student as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
- `first name`, which specifies the student's first name as `TEXT`, given `TEXT` is appropriate for name fields. It also uses `NOT NULL` constraint.
- `last name`, which specifies the student's first name as `TEXT`, given `TEXT` is appropriate for name fields. It also uses `NOT NULL` constraint.
- `date of birth`, which specifies the client's date of birth AS `TEXT`.
- `PESEL`, which a `INTEGER UNIQUE NOT NULL` every citizen of Poland has.
- `card`, which stores type of card a client has as `INTEGER`. It is a `FOREIGN KEY` referencing `cards` table.
- `gym`, which stores the gym a client is signed up to as `INTEGER`. It is a `FOREIGN KEY` referencing `gyms` table.

All columns have `NOT NULL` constraint as all data is necessary to succesffuly identify a person.

The `classes` table includes:
- `id`, which specifies the unique ID for the class as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
- `name`, `TEXT` storing the name of the class.
- `intensity`, storing intensity of a class as `TEXT`. `NOT NULL` and `CHECK` applied make sure that a class has one of three levels ('low', 'moderate', 'high').
- `length`, stores the length of a class as `INTEGER`.
- `day`, stores which day of the week a class is conducted using `TEXT` constraint.
- `card`, which tells which card is necessary to access a `class`. Note that high-level cards allow to enter lower-level `class`. `FOREIGN KEY` constraint is applied.
- `gym`, which specifies as `INTEGER` the `gym` a class takes place at.

All columns but`gym` have `NOT NULL` constraint as all data is necessary to succesffuly identify a person. `Gym` has `CHECK` constraint which check if a class has an access level assigned.

The `trainers` table includes:
- `id`, which specifies the unique ID for the trainer as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
- `first name`, which specifies the student's first name as `TEXT`, given `TEXT` is appropriate for name fields. It also uses `NOT NULL` constraint.
- `last name`, which specifies the student's first name as `TEXT`, given `TEXT` is appropriate for name fields. It also uses `NOT NULL` constraint.
- `date of birth`, which specifies the client's date of birth AS `TEXT`.
- `PESEL`, which a `INTEGER UNIQUE NOT NULL` every citizen of Poland has.
- `gym`, which specifies as `INTEGER` the `gym` a trainer works at. Uses `NOT NULL` constraint.

The `gyms` table includes:
- `id`, which specifies the unique ID for the gym as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
- `name`, which specifies the gyms name as `TEXT`, given `TEXT` is appropriate for name fields. It also uses `NOT NULL` and `UNIQUE` constraint.
- `city`, which specifies the city a gym is in AS `TEXT`.
- `voivodeship` - which specifies the voivodeship a gym is in AS `TEXT`.
`City` and `voivodeship` have `NOT NULL` constraint applied.

The `cards` table includes:
- `id`, which specifies the unique ID for the card as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
- `name`, which specifies the cards name as `TEXT`, given `TEXT` is appropriate for name fields. It also uses `NOT NULL` and `CHECK` constraint ('Standard', 'Silver', 'Premium')

To ensure that attributes work together well, additional tables have been introduced:

The `client_class` table keeps track of which client attends which class. It includes:
- `id`, which specifies the unique ID for the client and class connection as `INTEGER`.
- `client`, which specifies ID of client attending a class.
- `class` which specifies ID of class to which a client joins

Together with two `BEFORE INSERT` triggers, only clients with the right card and in the right city can attend a class. Columns `client` and `class` have `FOREIGN KEY` constraints.

The `client_trainer` table keeps track of which client has a personal trainer. It includes:
- `id`, which specifies as `INTEGER` the unique ID for the client and their trainer connection as `INTEGER`.
- `client`, which specifies as `INTEGER` ID of client attending having a personal trainer.
- `class` which specifies as `INTEGER` ID of trainer who trains with a client.

`BEFORE INSERT` trigger

The `class_trainer` table keeps track of which trainer conducts a class. It includes:
- `id`, which specifies as `INTEGER` the unique ID for the class and their trainer connection as `INTEGER`.
- `class`, which specifies as `INTEGER` ID of class led.
- `trainer` which specifies as `INTEGER` ID of trainer who conducts a class

### Relationships

The relationship in a diagram should be read as follows:

A client can have only 1 card and can attend 0, 1 or many classes at a gym they have a card for. Clients can use services of 1 trainer at a time or not at all. If yes, they have to be at the same gym. Clients can go to 1 gym only.

A trainer can train 0, 1 or many clients in their gym. A trainer can can conduct 0, 1 or many classes at their gym. Trainers can work at 1 gym at the time.

A class requires only one type of card and can be attended by 0, 1 or many clients from who have a card at the same gym. It can be conducted by 1 trainer at a time from the same gym. One type of class can take place at 0, 1 or many different gyms.

A gym can accomodate many clients and host 0, 1 or many classes. 0, 1 or more trainers can work at a gym.

A card allows to join 1 or more classes. A type of card can be possesed by 0, 1 or many clients

## Optimizations

Additional views were not necessary, however, additional tables were created to have easier access to most common person-person or entity-entity connections.

Per queries.sql, the most common queries are run using gyms and classes tables. Therefore, indexes are created on gyms table on `name`, and `city`columns and on classes table on `name` column.

## Limitations

The main limitation of a table is inability to track what is happening at the gym live. The card doesn't have "swipes" column with datestamp which would allow to check the occupancy of the gym at the specific time of the day.

Transfers of both clients and trainers reqiures altering a table. In case of trainer substitutions, e.g. during sick leave, the change in the database is also necessary. The remedy would be to keep every instance of class every week.

Individual classes are not kept track of, neither the date nor time.

In case someone decide to leave the gym altogether, their data and record will be kept in the database. A "soft" deletion column would need to be created in clients table together with AFTER UPDATE trigger or temporary turning off the FOREIGN KEY constr
