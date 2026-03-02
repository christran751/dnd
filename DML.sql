-- Variables that are populated by backend code are written as :variableName.
-- All work this was our own

/* -----------------------------------------------------------------------------------
-- 1. Characters CRUD
-- ---------------------------------------------------------------------------------------*/

-- CREATE ---------------------------------------------
-- contains the following query.
-- Query for add a new character functionality with colon : character being used to 
-- denote the variables that will have data from the backend programming language

INSERT INTO Characters
(displayName, race, characterClass, characterRole, characterLevel, maxHitPoint, armorClass, initiativeBonus)
VALUES 
(:displayName, :race, :characterClass, :characterRole, :characterLevel, :maxHitPoint, :armorClass, :initiativeBonus);

-- READ ---------------------------------------------
SELECT idCharacters, displayName, race, characterClass, characterRole, characterLevel, maxHitPoint, armorClass, initiativeBonus
FROM Characters
ORDER BY idCharacters ASC;

-- UPDATE ---------------------------------------------

-- USED TO MAKE A DROPDOWN FOR THE Update Character form
SELECT  idCharacters, CONCAT('Character ID: ', displayName, ' (ID: ', idCharacters, ')') AS displayName
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

-- DELETE ---------------------------------------------
DELETE FROM Characters
WHERE idCharacters = :ID_of_the_row_clicked;

/* -----------------------------------------------------------------------------------
-- 2. Encounters CRUD
-- ---------------------------------------------------------------------------------------*/

-- CREATE ---------------------------------------------
-- contains the following query.
-- Query for add a new Encounter functionality with colon : encounter being used to 
-- denote the variables that will have data from the backend programming language

INSERT INTO Encounters (nameOfLocation, location)
VALUES (:nameOfLocation, :location);

-- READ ---------------------------------------------
SELECT idEncounters, nameOfLocation, location
FROM Encounters
ORDER BY idEncounters;

-- UPDATE ---------------------------------------------

	-- get a single encounter for Update form
	SELECT idEncounters, CONCAT(idEncounters, ' - ', nameOfLocation) AS encounter_option
	FROM Encounters
	ORDER BY nameOfLocation;

UPDATE Encounters
SET nameOfLocation = :nameOfLocationInput, location = :locationInput
WHERE idEncounters = :encounter_ID_from_update_form;

-- DELETE --------------------------------------------- 
DELETE FROM Encounters
WHERE idEncounters = :ID_of_the_row_clicked;

-- /* -----------------------------------------------------------------------------------
-- 3. Characters_Encounters CRUD
-- ---------------------------------------------------------------------------------------*/

-- CREATE ---------------------------------------------
-- contains the following query.
-- Query for add a new character_encounter functionality with colon :character_encounter being used to 
-- denote the variables that will have data from the backend programming language

-- DROP DOWN TO ADD CHARACTER_ENCOUNTER
SELECT idCharacters,
CONCAT(displayName, ' (ID: ', idCharacters, ')') AS character_option
FROM Characters
ORDER BY displayName;

SELECT idEncounters,
CONCAT(nameOfLocation, ' (ID: ', idEncounters, ')') AS encounter_option
FROM Encounters
ORDER BY nameOfLocation;

-- ADD or CREATE
INSERT INTO Characters_Encounters (idCharacters, idEncounters, initiativeOrder, initiativeRoll)
VALUES (:idCharactersInput, :idEncountersInput, :initiativeOrderInput, :initiativeRollInput);

-- READ ---------------------------------------------
SELECT Characters_Encounters.idCharacterEncounter, Characters.displayName, Encounters.nameOfLocation, initiativeOrder, initiativeRoll,
	GREATEST(
        0,
        LEAST(
          COALESCE(Characters.maxHitPoint, 0) + COALESCE(SUM(HealthChangeLogs.hitPointChange), 0),
          COALESCE(Characters.maxHitPoint, 0)
        )
      ) AS currentHitPoint,
      COALESCE(Characters.maxHitPoint, 0) AS maxHitPoint
FROM Characters_Encounters JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
LEFT JOIN Turns ON Characters_Encounters.idCharacterEncounter = Turns.idCharacterEncounter
LEFT JOIN HealthChangeLogs ON HealthChangeLogs.idTurns = Turns.idTurns
GROUP BY
      Characters_Encounters.idCharacterEncounter,
      Characters.displayName,
      Encounters.nameOfLocation,
      Characters_Encounters.initiativeOrder,
      Characters_Encounters.initiativeRoll,
      Characters.maxHitPoint
ORDER BY Characters_Encounters.idEncounters, Characters_Encounters.initiativeOrder;

-- UPDATE ---------------------------------------------
-- DROP DOWN FOR UPDATE, i.e, get a single data for Update form of Character_Encounters
  SELECT Characters_Encounters.idCharacterEncounter,
  CONCAT(Characters.displayName, ' at ', Encounters.nameOfLocation, ' (ID: ', Characters_Encounters.idCharacterEncounter, ')') AS character_encounter  
  FROM Characters_Encounters
  JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
  JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
  ORDER BY Characters_Encounters.idCharacterEncounter;

UPDATE Characters_Encounters
SET idCharacters = :idCharactersInput,
idEncounters = :idEncountersInput,
initiativeOrder = :initiativeOrderInput,
initiativeRoll = :initiativeRollInput
WHERE idCharacterEncounter = :ID_selected_from_browse_page;

-- DELETE ---------------------------------------------
DELETE FROM Characters_Encounters
WHERE idCharacterEncounter = :ID_of_the_row_clicked;

    
-- /* -----------------------------------------------------------------------------------
-- 4. Turns CRUD
-- ---------------------------------------------------------------------------------------*/

-- CREATE -----------------------------------------------------------------------------------

-- contains the following query.
-- Query for add a new turn functionality with colon : turn being used to 
-- denote the variables that will have data from the backend programming language

-- DROP DOWN TO ADD A NEW TURN BASED OFF OF CHARACTER_ENCOUNTER BECAUSE TURN NEEDS AN EXISTING CHARACTER_ENCOUNTER
	SELECT  idCharacterEncounter, CONCAT(Characters.displayName, ' - ', Encounters.nameOfLocation, ' (ID: ', idCharacterEncounter, ')') AS displayLabel
	FROM Characters_Encounters
	JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
	JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
	ORDER BY Characters.displayName;
    
INSERT INTO Turns (idCharacterEncounter, actionOrderInRound, roundNumber, actionTaken)
VALUES 
(:idCharacterEncounter, :actionOrderInRound, :roundNumber, :actionTaken);

-- READ -----------------------------------------------------------------------------------
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

-- UPDATE -----------------------------------------------------------------------------------

	-- get a single turn's data for the Update Turn Page
    
    SELECT  Turns.idTurns, CONCAT(Characters.displayName, '-', Encounters.nameOfLocation, ' (ID: ', idTurns, ')')
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

-- DELETE -----------------------------------------------------------------------------------
DELETE FROM Turns
WHERE idTurns = :idTurns_of_the_row_clicked;

-- /* -----------------------------------------------------------------------------------
-- 5. HealthChangeLogs CRUD
-- ---------------------------------------------------------------------------------------*/

-- CREATE -----------------------------------------------------------------------------------
-- contains the following query.
-- Query for add a new HealthChangeLogs functionality with colon : HealthChangeLogs being used to 
-- denote the variables that will have data from the backend programming language

-- DROP DOWN AT ADD A NEW HEALTH LOG ENTRY BECAUSE WE CANNOT ADD A NEW ENTRY WITHOUT AN EXISTING TURN
	SELECT Turns.idTurns, CONCAT(Characters.displayName, ' - ', Encounters.nameOfLocation, ' (Turn ID: ', Turns.idTurns, ')') AS turn_option
	FROM Turns
	JOIN Characters_Encounters ON Turns.idCharacterEncounter = Characters_Encounters.idCharacterEncounter
	JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
	JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
	ORDER BY Turns.idTurns;

INSERT INTO HealthChangeLogs 
(idTurns, hitPointChange, hitPointChangeSource)
VALUES 
(:idTurns, :hitPointChange, :hitPointChangeSource);

-- READ -----------------------------------------------------------------------------------
SELECT idHealthChangeLogs , idTurns, CONCAT(hitPointChange, ' - ', hitPointChangeSource)
FROM HealthChangeLogs
ORDER BY idHealthChangeLogs  ASC;

-- UPDATE ----------------------------------------------------------------------------------- 
	
	-- DROP DOWN TO get a single health log data for the Update HealthChangeLogs Page
	SELECT HealthChangeLogs.idHealthChangeLogs, 
    CONCAT(Characters.displayName, ' - ', Encounters.nameOfLocation, ' (Log ID: ', HealthChangeLogs.idHealthChangeLogs, ')')
	FROM HealthChangeLogs
	JOIN Turns ON HealthChangeLogs.idTurns = Turns.idTurns
	JOIN Characters_Encounters ON Turns.idCharacterEncounter = Characters_Encounters.idCharacterEncounter
	JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
	JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
	ORDER BY HealthChangeLogs.idHealthChangeLogs;

UPDATE HealthChangeLogs
SET
idTurns = :idTurns,
hitPointChange = :hitPointChange,
hitPointChangeSource = :hitPointChangeSource
WHERE idHealthChangeLogs = :healthLog_ID_selected_from_browse_page;

-- DELETE ----------------------------------------------------------------------------------- 
DELETE FROM HealthChangeLogs
WHERE idHealthChangeLogs = :healthLog_ID_selected_from_browse_page;

-- /* -----------------------------------------------------------------------------------
-- 6. StatusEffects CRUD
-- ---------------------------------------------------------------------------------------*/

-- CREATE -----------------------------------------------------------------------------------
-- contains the following query.
-- Query for add a new StatusEffects functionality with colon : StatusEffects being used to 
-- denote the variables that will have data from the backend programming language

INSERT INTO StatusEffects (idTurns, conditionStatus, duration, effectAmount)
VALUES (:idTurns, :conditionStatus, :duration, :effectAmount);

-- READ -----------------------------------------------------------------------------------
SELECT StatusEffects.idStatusEffect, CONCAT(Characters.displayName,' - ', Encounters.nameOfLocation,' - ', Turns.actionTaken), StatusEffects.conditionStatus, StatusEffects.duration, StatusEffects.effectAmount
FROM StatusEffects 
JOIN Turns ON StatusEffects.idTurns = Turns.idTurns
JOIN Characters_Encounters ON Turns.idCharacterEncounter = Characters_Encounters.idCharacterEncounter
JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
ORDER BY StatusEffects.idStatusEffect;

-- UPDATE ----------------------------------------------------------------------------------- 

	-- GET A SINGLE DATA FOR UPDATE FORM
	SELECT StatusEffects.idStatusEffect, CONCAT(Characters.displayName, ' - ', Encounters.nameOfLocation, ' (Status Effect ID: ', StatusEffects.idStatusEffect, ')')
	FROM StatusEffects
	JOIN Turns ON StatusEffects.idTurns = Turns.idTurns
	JOIN Characters_Encounters ON Turns.idCharacterEncounter = Characters_Encounters.idCharacterEncounter
	JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
	JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
	ORDER BY StatusEffects.idStatusEffect;
		
UPDATE StatusEffects
SET idTurns = :idTurnsInput,
conditionStatus = :conditionStatusInput,
duration = :durationInput,
effectAmount = :effectAmountInput
WHERE idStatusEffect = :StatusEffects_ID_from_update_form;

-- DELETE -----------------------------------------------------------------------------------
DELETE FROM StatusEffects
WHERE idStatusEffect = :StatusEffects_ID_selected_from_browse_page;

