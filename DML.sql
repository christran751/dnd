- /* -----------------------------------------------------------------------------------
-- 1. Characters CRUD
-- ---------------------------------------------------------------------------------------*/

-- CREATE --
-- contains the following query.
-- Query for add a new character functionality with colon : character being used to 
-- denote the variables that will have data from the backend programming language

INSERT INTO Characters
(displayName, race, characterClass, characterRole, characterLevel, maxHitPoint, armorClass, initiativeBonus)
VALUES 
(:displayName, :race, :characterClass, :characterRole, :characterLevel, :maxHitPoint, :armorClass, :initiativeBonus);

-- READ --
SELECT idCharacters, displayName, race, characterClass, characterRole, characterLevel, maxHitPoint, armorClass, initiativeBonus
FROM Characters
ORDER BY idCharacters ASC;

-- UPDATE --

	-- USED TO MAKE A DROPDOWN FOR THE Update Character form
	SELECT idCharacters, displayName
	FROM Characters
	ORDER BY displayName;

    
UPDATE Characters
SET displayName = :displayNameInput,
race = :raceInput,
characterClass = :characterClassInput,
characterRole = :characterRoleInput,
characterLevel = :characterLevelInput,
maxHitPoint = :maxHitPointInput,
armorClass = :armorClassInput,
initiativeBonus = :initiativeBonusInput
WHERE idCharacters = :character_ID_selected_from_drop_down_menu_at;

-- DELETE --
DELETE FROM Characters
WHERE idCharacters = :ID_of_the_row_clicked;

-- /* -----------------------------------------------------------------------------------
-- 2. Encounters CRUD
-- ---------------------------------------------------------------------------------------*/

-- CREATE --
-- contains the following query.
-- Query for add a new Encounter functionality with colon : encounter being used to 
-- denote the variables that will have data from the backend programming language

INSERT INTO Encounters (nameOfLocation, location)
VALUES (:nameOfLocation, :location);

-- READ --
SELECT idEncounters, nameOfLocation, location
FROM Encounters
ORDER BY idEncounters;

-- UPDATE --

	-- get a single encounter for Update form
	SELECT idEncounters, nameOfLocation
	FROM Encounters
    ORDER BY nameOfLocation;

UPDATE Encounters
SET nameOfLocation = :nameOfLocationInput, location = :locationInput
WHERE idEncounters = :encounter_ID_from_update_form;

-- DELETE -- 
DELETE FROM Encounters
WHERE idEncounters = :ID_of_the_row_clicked;

-- /* -----------------------------------------------------------------------------------
-- 3. Characters_Encounters CRUD
-- ---------------------------------------------------------------------------------------*/

-- CREATE --
-- CREATE --
-- contains the following query.
-- Query for add a new character_encounter functionality with colon : character_encounter being used to 
-- denote the variables that will have data from the backend programming language
INSERT INTO Characters_Encounters (idCharacters, idEncounters, initiativeOrder, initiativeRoll, currentHitPoint)
VALUES (:idCharactersInput, :idEncountersInput, :initiativeOrderInput, :initiativeRollInput, :currentHitPointInput);

-- READ -- 

SELECT Characters_Encounters.idCharacterEncounter, Characters.displayName, Encounters.nameOfLocation, initiativeOrder, initiativeRoll, currentHitPoint
FROM Characters_Encounters JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
ORDER BY Encounters.idEncounters, initiativeOrder; -- Encounter 1 is first and Whoever goes 1st

-- UPDATE

	-- get a single data for Update form of Character_Encounters
  SELECT Characters_Encounters.idCharacterEncounter,
  CONCAT(Characters.displayName, ' at ', Encounters.nameOfLocation) AS character_encounter
  FROM Characters_Encounters
  JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
  JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
  ORDER BY Characters_Encounters.idCharacterEncounter;

UPDATE Characters_Encounters
SET idCharacters = :idCharactersInput,
idEncounters = :idEncountersInput,
initiativeOrder = :initiativeOrderInput,
initiativeRoll = :initiativeRollInput,
currentHitPoint = :currentHitPointInput
WHERE idCharacterEncounter = :ID_selected_from_browse_page;

-- DELETE --
DELETE FROM Characters_Encounters
WHERE idCharacterEncounter = :ID_of_the_row_clicked

    
-- /* -----------------------------------------------------------------------------------
-- 4. Turns CRUD
-- ---------------------------------------------------------------------------------------*/

-- CREATE --

-- contains the following query.
-- Query for add a new turn functionality with colon : turn being used to 
-- denote the variables that will have data from the backend programming language
INSERT INTO Turns (idCharacterEncounter, actionOrderInRound, roundNumber, actionTaken)
VALUES 
(:idCharacterEncounter, :actionOrderInRound, :roundNumber, :actionTaken);

-- READ --
SELECT 
Turns.idTurns,
Characters.displayName AS Characters,
Encounters.nameOfLocation AS Encounters,
Turns.actionTaken,
Turns.roundNumber,
Turns.actionOrderInRound
FROM Turns
JOIN Characters_Encounters ON Turns.idCharacterEncounter = Characters_Encounters.idCharacterEncounter
JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
ORDER BY Turns.roundNumber, Turns.actionOrderInRound;

-- UPDATE --

	-- get a single turn's data for the Update Turn Page
    
    SELECT  Turns.idTurns, CONCAT(Characters.displayName, '-', Encounters.nameOfLocation)
	FROM Turns
	JOIN Characters_Encounters ON Turns.idCharacterEncounter = Characters_Encounters.idCharacterEncounter
	JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
	JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
	ORDER BY Turns.idTurns ASC;

UPDATE Turns
SET
idCharacterEncounter = :idCharacterEncounter,
actionOrderInRound = :actionOrderInRound,
roundNumber = :roundNumber,
actionTaken = :actionTaken
WHERE idTurns = :turn_ID_selected_from_drop_down_menu_at_turns_page;

-- DELETE --
DELETE FROM Turns
WHERE idTurns = :idTurns_of_the_row_clicked;

-- /* -----------------------------------------------------------------------------------
-- 5. HealthChangeLogs CRUD
-- ---------------------------------------------------------------------------------------*/

-- CREATE --
-- contains the following query.
-- Query for add a new HealthChangeLogs functionality with colon : HealthChangeLogs being used to 
-- denote the variables that will have data from the backend programming language
INSERT INTO HealthChangeLogs 
(idTurns, hitPointChange, hitPointChangeSource)
VALUES 
(:idTurns, :hitPointChange, :hitPointChangeSource);

-- READ --
SELECT idHealthChangeLogs , idTurns, CONCAT(hitPointChange, ' - ', hitPointChangeSource)
FROM HealthChangeLogs
ORDER BY idHealthChangeLogs  ASC;

-- UPDATE -- 
	
	-- get a single health log data for the Update HealthChangeLogs Page
  	SELECT idHealthChangeLogs, CONCAT(hitPointChange, ' - ', hitPointChangeSource)
  	FROM HealthChangeLogs
  	ORDER BY idHealthChangeLogs ASC;

UPDATE HealthChangeLogs
SET
idTurns = :idTurns,
hitPointChange = :hitPointChange,
hitPointChangeSource = :hitPointChangeSource,
WHERE idHealthChangeLogs = :healthLog_ID_selected_from_browse_page;

-- DELETE -- 
DELETE FROM HealthChangeLogs
WHERE idHealthChangeLogs = :healthLog_ID_selected_from_browse_page;

-- /* -----------------------------------------------------------------------------------
-- 6. StatusEffects CRUD
-- ---------------------------------------------------------------------------------------*/

-- CREATE --
-- contains the following query.
-- Query for add a new StatusEffects functionality with colon : StatusEffects being used to 
-- denote the variables that will have data from the backend programming language

INSERT INTO StatusEffects (idTurns, conditionStatus, duration, effectAmount)
VALUES (:idTurns, :conditionStatus, :duration, :effectAmount);

-- READ --
SELECT StatusEffects.idStatusEffect, CONCAT(Characters.displayName,' - ', Encounters.nameOfLocation,' - ', Turns.actionTaken), StatusEffects.conditionStatus, StatusEffects.duration, StatusEffects.effectAmount
FROM StatusEffects 
JOIN Turns ON StatusEffects.idTurns = Turns.idTurns
JOIN Characters_Encounters ON Turns.idCharacterEncounter = Characters_Encounters.idCharacterEncounter
JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
ORDER BY StatusEffects.idStatusEffect;

-- UPDATE -- 

	-- GET A SINGLE DATA FOR UPDATE FORM
	SELECT idStatusEffect, idTurns, conditionStatus, duration, effectAmount
	FROM StatusEffects
	WHERE idStatusEffect = :se_ID_selected_from_browse_page;
    
UPDATE StatusEffects
SET idTurns = :idTurnsInput,
conditionStatus = :conditionStatusInput,
duration = :durationInput,
effectAmount = :effectAmountInput
WHERE idStatusEffect = :StatusEffects_ID_from_update_form;

-- DELETE --
DELETE FROM StatusEffects
WHERE idStatusEffect = :StatusEffects_ID_selected_from_browse_page;
