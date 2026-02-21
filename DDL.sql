-- This section is used to temporarily disables foreign key checks so that we could delete table. For testing purposes.
SET FOREIGN_KEY_CHECKS = 0;
SET AUTOCOMMIT = 0;

DROP TABLE IF EXISTS Characters;
DROP TABLE IF EXISTS Encounters;
DROP TABLE IF EXISTS Characters_Encounters;
DROP TABLE IF EXISTS Turns;
DROP TABLE IF EXISTS HealthChangeLogs;
DROP TABLE IF EXISTS StatusEffects;

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

CREATE TABLE Characters_Encounters (
    idCharacterEncounter INT NOT NULL AUTO_INCREMENT,
    idCharacters INT NOT NULL,
    idEncounters INT NOT NULL,
    initiativeOrder INT NOT NULL,
    initiativeRoll INT NOT NULL,
    currentHitPoint INT NOT NULL,
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
    FOREIGN KEY (idCharacterEncounter) REFERENCES Characters_Encounters(idCharacterEncounter) ON DELETE CASCADE
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
INSERT INTO Characters
(displayName, race, characterClass, characterRole, characterLevel, maxHitPoint, armorClass, initiativeBonus)
VALUES
('Gandalf the Grey', 'Maia', 'Wizard', 'PC', 10, 68, 15, 2),
('Aragorn', 'Human', 'Ranger', 'PC', 8, 75, 17, 3),
('Ahri', 'Vastaya', 'Sorcerer', 'PC', 7, 52, 14, 4),
('Yasuo', 'Human', 'Fighter', 'PC', 7, 65, 16, 5),
('Mikasa Ackerman', 'Human', 'Fighter', 'PC', 6, 60, 16, 4),
('Soraka', 'Celestial', 'Cleric', 'PC', 7, 55, 13, 1);

-- Encounters
INSERT INTO Encounters
(nameOfLocation, location)
VALUES
('Battle of Helm’s Deep', 'Rohan'),
('Skirmish at Summoner’s Rift', 'Valoran'),
('Siege of Shiganshina', 'Wall Maria'),
('Goblin Cave Assault', 'Sword Coast'),
('Forest Ambush', 'Fangorn Forest'),
('Ruined Shrine Defense', 'Ionia');

-- Characters_Encounters
INSERT INTO Characters_Encounters
(idCharacters, idEncounters, initiativeOrder, initiativeRoll, currentHitPoint)
VALUES
(1, 1, 3, 14, 68),  
(2, 1, 2, 16, 75),  
(3, 2, 1, 19, 52), 
(4, 2, 2, 17, 65),  
(5, 3, 1, 20, 60),  
(6, 2, 3, 12, 55);

-- Turns

INSERT INTO Turns
(idCharacterEncounter, actionOrderInRound, roundNumber, actionTaken)
VALUES
(1, 1, 1, 'Hit by Aragorn’s Sword Slash'),       
(2, 2, 1, 'Hit by Gandalf’s Fireball'),          
(4, 1, 1, 'Hit by Yasuo’s Wind-Infused Blade'), 
(3, 2, 1, 'Hit by Ahri’s Orb of Deception'),     
(5, 1, 1, 'Hit by Goblin Counterattack'),       
(5, 2, 1, 'Healed by Soraka’s Healing Word'),   
(2, 3, 1, 'Drinking Potion');

-- HealthChangeLogs
INSERT INTO HealthChangeLogs
(idTurns, hitPointChange, hitPointChangeSource)
VALUES
(1, -10, 'Sword slash from Aragorn'),  
(2, -14, 'Fireball explosion'),         
(3, -7, 'Wind-infused blade'),          
(4, -8, 'Orb of Deception'),           
(5, -12, 'Counterattack wound'),      
(6, +15, 'Healing Word'),              
(7, +10, 'Drinking Potion');

-- Status Effect
INSERT INTO StatusEffects
(idTurns, conditionStatus, duration, effectAmount)
VALUES
(1, 'Poisoned', 2, 3),     
(2, 'Buffed', 1, 2),         
(3, 'Stunned', 1, 0),     
(4, 'Healthy', 1, 0),     
(5, 'Healthy', 1, 0),     
(6, 'Buffed', 2, 5); 

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;



