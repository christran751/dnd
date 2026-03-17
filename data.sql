-- USE name_of_database;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS StatusEffects;
DROP TABLE IF EXISTS HealthChangeLogs;
DROP TABLE IF EXISTS Turns;
DROP TABLE IF EXISTS CharactersEncounters;
DROP TABLE IF EXISTS Encounters;
DROP TABLE IF EXISTS Characters;

-- Create Table --

CREATE TABLE Characters (
	idCharacters INT NOT NULL AUTO_INCREMENT,
	displayName VARCHAR(50) NOT NULL,
    race VARCHAR(50) NOT NULL,
    characterClass VARCHAR(50),
	characterRole ENUM('PC', 'NPC') NOT NULL,
	characterLevel INT DEFAULT 1,
    maxHitPoint INT NOT NULL,
    armorClass INT DEFAULT 10,
    initiativeBonus INT DEFAULT 0,
	PRIMARY KEY (idCharacters)
);

CREATE TABLE Encounters (
	idEncounters INT NOT NULL AUTO_INCREMENT,
	nameOfLocation VARCHAR(50) NOT NULL,
	location VARCHAR(50) DEFAULT 'UNKNOWN',
	PRIMARY KEY (idEncounters)
);

CREATE TABLE CharactersEncounters (
    idCharacterEncounter INT NOT NULL AUTO_INCREMENT,
    idCharacters INT NOT NULL,
    idEncounters INT NOT NULL,
    initiativeOrder INT NOT NULL,
    initiativeRoll INT NOT NULL,
    PRIMARY KEY (idCharacterEncounter),
    UNIQUE (idCharacters, idEncounters),
    FOREIGN KEY (idCharacters) REFERENCES Characters(idCharacters) ON DELETE CASCADE,
    FOREIGN KEY (idEncounters) REFERENCES Encounters(idEncounters) ON DELETE CASCADE
);

CREATE TABLE Turns (
	idTurns INT NOT NULL AUTO_INCREMENT,
    idCharacterEncounter INT NOT NULL,
	actionOrderInRound INT NOT NULL,
	roundNumber INT DEFAULT 1,
	actionTaken VARCHAR(100) NOT NULL,
	PRIMARY KEY (idTurns),
    FOREIGN KEY (idCharacterEncounter) REFERENCES CharactersEncounters(idCharacterEncounter) ON DELETE CASCADE
);

-- Made a new entity because old set up had redunancy and so I had to remove one relationship. Need this to meet the requirment of 4.
CREATE TABLE StatusEffects (
    idStatusEffect INT NOT NULL AUTO_INCREMENT,
    idTurns INT NOT NULL,
    conditionStatus ENUM('Healthy', 'Buffed', 'Poisoned', 'Stunned', 'Dead') DEFAULT 'Healthy',
    duration INT DEFAULT 1,
    effectAmount INT DEFAULT 0,
    PRIMARY KEY (idStatusEffect),
    FOREIGN KEY (idTurns) REFERENCES Turns(idTurns) ON DELETE CASCADE
);

CREATE TABLE HealthChangeLogs (
    idHealthChangeLogs INT NOT NULL AUTO_INCREMENT,
    idTurns INT NOT NULL,
    hitPointChange INT NOT NULL,
    hitPointChangeSource VARCHAR(50) NOT NULL,
    PRIMARY KEY (idHealthChangeLogs),
    FOREIGN KEY (idTurns) REFERENCES Turns(idTurns) ON DELETE CASCADE
);


-- Example Inserted Table Data --
-- Characters
INSERT INTO Characters (displayName, race, characterClass, characterRole, characterLevel, maxHitPoint, armorClass, initiativeBonus)
VALUES
('Gandalf', 'Maia', 'Wizard', 'PC', 10, 68, 15, 2),
('Aragorn', 'Human', 'Ranger', 'PC', 8, 75, 17, 3),
('Ahri', 'Vastaya', 'Sorcerer', 'PC', 7, 52, 14, 4),
('Orc Warrior', 'Orc', 'Fighter', 'NPC', 5, 40, 13, 1),
('Balrog', 'Demon', 'Fire Elemental', 'NPC', 12, 120, 18, 0),
('Goblin', 'Goblin', 'Rogue', 'NPC', 3, 25, 12, 2);

-- Encounters
INSERT INTO Encounters (nameOfLocation, location)
VALUES
('Battle of Helm’s Deep', 'Rohan'),
('Skirmish at Summoner’s Rift', 'Valoran'),
('Siege of Shiganshina', 'Wall Maria');

-- CHARACTER_ENCOUNTER
INSERT INTO CharactersEncounters (idCharacters, idEncounters, initiativeOrder, initiativeRoll)
VALUES
(1, 1, 2, 14),
(2, 1, 3, 16),
(4, 1, 1, 10),
(3, 2, 2, 19),
(5, 2, 1, 15),
(2, 3, 2, 17),
(6, 3, 1, 12);

-- TURNS
INSERT INTO Turns (idCharacterEncounter, actionOrderInRound, roundNumber, actionTaken)
VALUES
(3, 1, 1, 'Orc Warrior attacks Gandalf'),
(1, 2, 1, 'Gandalf casts Fireball on Orc Warrior'),
(2, 3, 1, 'Aragorn strikes Orc Warrior'),
(5, 1, 1, 'Balrog attacks Ahri'),
(4, 2, 1, 'Ahri casts Orb of Deception on Balrog'),
(6, 1, 1, 'Goblin attacks Aragorn'),
(7, 2, 1, 'Aragorn strikes Goblin');

-- HEALTHCHANGE LOGS
INSERT INTO HealthChangeLogs (idTurns, hitPointChange, hitPointChangeSource)
VALUES
(2, -8, 'Orc Warrior attacks Gandalf'),
(1, -25, 'Gandalf casts Fireball on Orc Warrior'),
(1, -12, 'Aragorn strikes Orc Warrior'),
(5, -18, 'Balrog attacks Ahri'),
(4, -10, 'Ahri casts Orb of Deception on Balrog'),
(7, -6, 'Goblin attacks Aragorn'),
(6, -14, 'Aragorn strikes Goblin');

-- STATUS EFFECT
INSERT INTO StatusEffects (idTurns, conditionStatus, duration, effectAmount)
VALUES
(1, 'Healthy', 1, 0),
(2, 'Buffed', 1, 2),
(3, 'Healthy', 1, 0),
(4, 'Poisoned', 1, 2),
(5, 'Healthy', 1, 0),
(6, 'Healthy', 1, 0),
(7, 'Healthy', 1, 0);


SET FOREIGN_KEY_CHECKS = 1;