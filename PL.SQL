-- Citation 1 for use of AI Tools:
-- Date: 02/22/2026
-- Summary of prompts used to help build a stored procedure
-- What is the general syntax of a stored procedure and is it all the same for CRUD operations and can you show me an example?
-- Example Provided by AI:
		-- CREATE PROCEDURE AddEmployee(
		--     IN p_name VARCHAR(50),
		--     IN p_salary DECIMAL(10,2)
		-- )
		-- BEGIN
		--     INSERT INTO Employees (Name, Salary)
		--     VALUES (p_name, p_salary);
		-- END;
-- AI Source URL: https://claude.ai/chat/8e1f2ef6-3168-4bb4-b182-5e0e633eaa5b
-- NOTE:
	-- We used the genereal syntax and eexample given to us as a model to create a store procedure for all of our CRUD operations.

-- Citation 2 for use of AI Tools:
-- Date: 02/22/2026
-- Summary of prompts used to generate PL/SQL
-- How to convert my old app.get (that is commented below) for Turns into a Stored Procedure and then later call it in app.js?
-- AI Source URL: https://copilot.microsoft.com/
-- From there it provided a basic template for the getTurns Stored Procedure

-- Citation 3 for use of AI Tools:
-- Date: 2/24/2026
-- Prompt Used to Generated Code
-- Whenever I updated HealthChangeLog, is there a way for it to automatically update the currentHitPoint attribute in Character_Encounter? Also how to
-- ensure that current hit point will not get out of bound, i.e., go above maxHp and not go below 0.
-- It gave me two options.
-- Option A is to use a trigger (which is something, I'm not familiar with), therefore, I chose the latter.
-- Option Two is to first get rid of the currentHitPoint Column from Chracter_Encounter and to instead computed it
-- Copied from /OR/ Adapted from /OR/ Based on (Explain degree of originality)
-- The select portion, the app.get, the dropdown, and render portion I did on my own, but for the part below:
--              GREATEST(
--                0,
--                LEAST(
--                  COALESCE(Characters.maxHitPoint, 0) + COALESCE(SUM(HealthChangeLogs.hitPointChange), 0),
--                 COALESCE(Characters.maxHitPoint, 0)
--                )
--              ) AS currentHitPoint,
-- This portion that is used to calculate the character’s current HP while making sure it stays within valid limits,  I had copied it exactly from copilot.
-- At the time, did not know what GREATEST, LEAST, or even COALESCE did. Had to Google it.
-- It also recommended me to use LEFT JOIN because I needed to include all character encounters, even if they don’t have any turns or health logs yet
-- Source URL: https://copilot.microsoft.com/chats/EKZr5BAnjAV8nsu99jsMW

/* Citation 4 for use of AI Tools:
Date: 2/24/2026
Prompted Used: How do I make it so that update or adding new log to The Character_Encounters table will also automatically update or affect the Turns table
From there, it simply suggested that I either used a Trigger, or to insert or update related rows in Turns in a stored procedure.
Copied from /OR/ Adapted from /OR/ Based on (Explain degree of originality)
It gave me the following code template (to which I used entirely):
	SET newCharacterEncounterID = LAST_INSERT_ID();
		INSERT INTO Turns (idCharacterEncounter, actionOrderInRound, roundNumber, actionTaken)
		VALUES (
			newCharacterEncounterID,
			initiativeOrderInput,
			1,
			'No action yet'
		);
From there, I had to play around with it to see where to put it. It worked best when I put it into the same stored procedure as the character_encounter add and update; as opposed to making a separate store procedure (in which I initially tried doing but with no luck).
Source URL: https://copilot.microsoft.com/chats/VUesq1DBGfUqM7muhFjjE
*/

-- Citation 5 for use of AI Tools:
-- Date: 03/09/2026
-- Summary of prompts used to help build a stored procedure for get health log entry
-- For HealthLog is it better to have a separate dropdown STORED PROCEDURE or have it in get_health_logs?
-- It prompt that its better to just have it within my own SP and not create a new SP since only health log will be using it.
-- AI Source URL: https://claude.ai/chat/8e1f2ef6-3168-4bb4-b182-5e0e633eaa5b

-- All code (SP) written here is based or referenced using AI from Claude, chatgpt, and Copilot 



-- |============================================================ Characters Stored Procedure ===================================================================================|
-- |============================================================================================================================================================================|

-- Based on Citation # 1
DROP PROCEDURE IF EXISTS get_characters;
DELIMITER //
CREATE PROCEDURE get_characters()
BEGIN
    SELECT * FROM Characters
    ORDER BY idCharacters ASC;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS add_character;
DELIMITER //
CREATE PROCEDURE add_character(
    IN displayNameInput VARCHAR(100),
    IN raceInput VARCHAR(100),
    IN characterClassInput VARCHAR(100),
    IN characterRoleInput VARCHAR(100),
    IN characterLevelInput INT,
    IN maxHitPointInput INT,
    IN armorClassInput INT,
    IN initiativeBonusInput INT
)
BEGIN
    INSERT INTO Characters
    (displayName, race, characterClass, characterRole, characterLevel, maxHitPoint, armorClass, initiativeBonus)
    VALUES
    (displayNameInput, raceInput, characterClassInput, characterRoleInput, characterLevelInput, maxHitPointInput, armorClassInput, initiativeBonusInput);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS update_character;
DELIMITER //
CREATE PROCEDURE update_character(
    IN idCharactersInput INT,
    IN displayNameInput VARCHAR(100),
    IN raceInput VARCHAR(100),
    IN characterClassInput VARCHAR(100),
    IN characterRoleInput VARCHAR(100),
    IN characterLevelInput INT,
    IN maxHitPointInput INT,
    IN armorClassInput INT,
    IN initiativeBonusInput INT
)
BEGIN
    UPDATE Characters
    SET
        displayName = displayNameInput,
        race = raceInput,
        characterClass = characterClassInput,
        characterRole = characterRoleInput,
        characterLevel = characterLevelInput,
        maxHitPoint = maxHitPointInput,
        armorClass = armorClassInput,
        initiativeBonus = initiativeBonusInput
    WHERE idCharacters = idCharactersInput;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS delete_character;
DELIMITER //
CREATE PROCEDURE delete_character(
    IN idCharactersInput INT
)
DELETE FROM Characters
WHERE idCharacters = idCharactersInput;
//
DELIMITER ;
-- End of Citation 1

-- |======================================================= END OF Characters Stored Procedures ===============================================================|
-- |===========================================================================================================================================================|
-- |===========================================================================================================================================================|


-- |============================================================ Encounters Stored Procedure ===================================================================================|
-- |============================================================================================================================================================================|

-- Citation 1
DROP PROCEDURE IF EXISTS get_encounters;
DELIMITER //
CREATE PROCEDURE get_encounters()
BEGIN
    SELECT *
    FROM Encounters
    ORDER BY idEncounters ASC;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS add_encounter;
DELIMITER //
CREATE PROCEDURE add_encounter(
    IN nameOfLocationInput VARCHAR(100),
    IN locationInput VARCHAR(255)
)
BEGIN
    INSERT INTO Encounters (nameOfLocation, location)
    VALUES (nameOfLocationInput, locationInput);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS update_encounter;
DELIMITER //
CREATE PROCEDURE update_encounter(
    IN idEncountersInput INT,
    IN nameOfLocationInput VARCHAR(100),
    IN locationInput VARCHAR(255)
)
BEGIN
    UPDATE Encounters
    SET
        nameOfLocation = nameOfLocationInput,
        location = locationInput
    WHERE idEncounters = idEncountersInput;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS delete_encounter;
DELIMITER //
CREATE PROCEDURE delete_encounter(
    IN idEncountersInput INT
)
BEGIN
    DELETE FROM Encounters
    WHERE idEncounters = idEncountersInput;
END //
DELIMITER ;
-- End of Citation 1

-- |======================================================= END OF Encounters Stored Procedures ===============================================================|
-- |===========================================================================================================================================================|
-- |===========================================================================================================================================================|


-- |============================================================ Turns Stored Procedure ===================================================================================|
-- |============================================================================================================================================================================|

-- Citations 1 & 2
DROP PROCEDURE IF EXISTS getTurns;
DELIMITER //
CREATE PROCEDURE getTurns()
BEGIN
    SELECT
        Turns.idTurns,
        Turns.actionTaken,
        Turns.actionOrderInRound,
        Turns.roundNumber,
        Characters.displayName,
        Encounters.nameOfLocation
    FROM Turns
    JOIN CharactersEncounters
        ON Turns.idCharacterEncounter = CharactersEncounters.idCharacterEncounter
    JOIN Characters
        ON CharactersEncounters.idCharacters = Characters.idCharacters
    JOIN Encounters
        ON CharactersEncounters.idEncounters = Encounters.idEncounters
    ORDER BY Turns.idCharacterEncounter ASC, Turns.roundNumber ASC, Turns.actionOrderInRound ASC;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS addTurn;
DELIMITER //
CREATE PROCEDURE addTurn(
    IN idCharacterEncounterInput INT,
    IN actionTakenInput VARCHAR(255),
    IN roundNumberInput INT,
    IN actionOrderInRoundInput INT
)
BEGIN
    INSERT INTO Turns (
        idCharacterEncounter,
        actionTaken,
        roundNumber,
        actionOrderInRound
    )
    VALUES (
        idCharacterEncounterInput,
        actionTakenInput,
        roundNumberInput,
        actionOrderInRoundInput
    );
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS updateTurn;
DELIMITER //
CREATE PROCEDURE updateTurn(
    IN idTurnsInput INT,
    IN actionTakenInput VARCHAR(255),
    IN roundNumberInput INT,
    IN actionOrderInRoundInput INT
)
BEGIN
    UPDATE Turns
    SET
        actionTaken = actionTakenInput,
        roundNumber = roundNumberInput,
        actionOrderInRound = actionOrderInRoundInput
    WHERE idTurns = idTurnsInput;
END //
DELIMITER ;


-- DELETE TURNS
DROP PROCEDURE IF EXISTS deleteTurn;
DELIMITER //
CREATE PROCEDURE deleteTurn(
    IN idTurnsInput INT
)
BEGIN
    DELETE FROM Turns
    WHERE idTurns = idTurnsInput;
END //
DELIMITER ;
-- End of Citations 1 & 2

-- |======================================================= END OF Turns Stored Procedures ====================================================================|
-- |===========================================================================================================================================================|
-- |===========================================================================================================================================================|


-- |============================================= CharactersEncounters Stored Procedure ======================================================================|
-- |===========================================================================================================================================================|

-- Citation 1
DROP PROCEDURE IF EXISTS getCharacterEncounters;
DELIMITER //
CREATE PROCEDURE getCharacterEncounters()
BEGIN
    SELECT
      CharactersEncounters.idCharacterEncounter,
      Characters.displayName,
      Encounters.nameOfLocation,
      CharactersEncounters.initiativeOrder,
      CharactersEncounters.initiativeRoll,
      
      -- See script.js citation # 8
      -- At first tried fixing currentHP not healing starting from 0 with SQL using 
--       GREATEST(
--           0,
--           LEAST(
--             COALESCE(Characters.maxHitPoint, 0) + COALESCE(SUM(CASE WHEN HealthChangeLogs.hitPointChange < 0 THEN 0 ELSE HealthChangeLogs.hitPointChange END), 0),
--             COALESCE(Characters.maxHitPoint, 0)
--           )
--         ) AS currentHitPoint,
--         COALESCE(Characters.maxHitPoint, 0) AS maxHitPoint
	  -- Didn't work. 
      
      -- Copied from copilot Citation 3
      GREATEST(
        0,
        LEAST(
          COALESCE(Characters.maxHitPoint, 0) + COALESCE(SUM(HealthChangeLogs.hitPointChange), 0),
          COALESCE(Characters.maxHitPoint, 0)
        )
      ) AS currentHitPoint,
      COALESCE(Characters.maxHitPoint, 0) AS maxHitPoint
      -- end of copy from copilot Citation 3.
    FROM CharactersEncounters
    JOIN Characters ON CharactersEncounters.idCharacters = Characters.idCharacters
    JOIN Encounters ON CharactersEncounters.idEncounters = Encounters.idEncounters
    LEFT JOIN Turns ON CharactersEncounters.idCharacterEncounter = Turns.idCharacterEncounter
    LEFT JOIN HealthChangeLogs ON HealthChangeLogs.idTurns = Turns.idTurns
    GROUP BY
      CharactersEncounters.idCharacterEncounter,
      Characters.displayName,
      Encounters.nameOfLocation,
      CharactersEncounters.initiativeOrder,
      CharactersEncounters.initiativeRoll,
      Characters.maxHitPoint
    ORDER BY CharactersEncounters.idEncounters, CharactersEncounters.initiativeOrder;
END //
DELIMITER ;


-- // DELETE CHARACTER-ENCOUNTER
-- app.post('/delete-character-encounter', async (req, res) => {
--   console.log("DELETE HIT!", req.body); // debugging
--   const { idCharacterEncounter } = req.body;

--   await db.query(
--     `DELETE FROM CharactersEncounters WHERE idCharacterEncounter = ?`,
--     [idCharacterEncounter]
--   );

--   res.redirect('/CharactersEncounters');
-- });

-- Stored Procedure to DELETE Chracter_Encounters
DROP PROCEDURE IF EXISTS deleteCharacterEncounter;
DELIMITER //
CREATE PROCEDURE deleteCharacterEncounter(IN idCharacterEncounterInput INT)
BEGIN
    DELETE FROM CharactersEncounters
    WHERE idCharacterEncounter = idCharacterEncounterInput;
END //
DELIMITER ;

-- Stored Procedure to ADD Chracter_Encounters
DROP PROCEDURE IF EXISTS addCharacterEncounter;
DELIMITER //
CREATE PROCEDURE addCharacterEncounter(
    IN idCharacterInput INT,
    IN idEncounterInput INT,
    IN initiativeOrderInput INT,
    IN initiativeRollInput INT
)
BEGIN
    DECLARE newCharacterEncounterID INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error! Character Encounters not added' AS Message;
    END;
    START TRANSACTION;

    -- Since we are inserting into different TWO tables, we need to use a transaction
    INSERT INTO CharactersEncounters
        (idCharacters, idEncounters, initiativeOrder, initiativeRoll)
    VALUES
        (idCharacterInput, idEncounterInput, initiativeOrderInput, initiativeRollInput);
	-- Copied from AI citation # 4
    SET newCharacterEncounterID = LAST_INSERT_ID();
    INSERT INTO Turns (idCharacterEncounter, actionOrderInRound, roundNumber, actionTaken)
    VALUES (
        newCharacterEncounterID,
        initiativeOrderInput,
        1,
        'No Action Taken'
    );
    -- END OF COPY citation 4
    COMMIT;
END //
DELIMITER ;
-- End of citation 1


-- Stored Procedure to Update Chracter_Encounters
DROP PROCEDURE IF EXISTS updateCharacterEncounter;
DELIMITER //
CREATE PROCEDURE updateCharacterEncounter(
    IN idCharacterEncounterInput INT,
    IN initiativeOrderInput INT,
    IN initiativeRollInput INT
)
BEGIN
    UPDATE CharactersEncounters
    SET
        initiativeOrder = initiativeOrderInput,
        initiativeRoll = initiativeRollInput
    WHERE idCharacterEncounter = idCharacterEncounterInput;
END //
DELIMITER ;

-- |================================================== END OF CharactersEncounters Stored Procedures =========================================================|
-- |===========================================================================================================================================================|
-- |===========================================================================================================================================================|


-- |===================================================== StatusEffect Stored Procedure =======================================================================|
-- |===========================================================================================================================================================|

DROP PROCEDURE IF EXISTS get_status_effects;
DELIMITER //
CREATE PROCEDURE get_status_effects()
BEGIN
    SELECT
        StatusEffects.idStatusEffect,
        StatusEffects.conditionStatus,
        StatusEffects.duration,
        StatusEffects.effectAmount,
        Characters.displayName,
        Encounters.nameOfLocation
    FROM StatusEffects
    JOIN Turns ON StatusEffects.idTurns = Turns.idTurns
    JOIN CharactersEncounters ON Turns.idCharacterEncounter = CharactersEncounters.idCharacterEncounter
    JOIN Characters ON CharactersEncounters.idCharacters = Characters.idCharacters
    JOIN Encounters ON CharactersEncounters.idEncounters = Encounters.idEncounters
    ORDER BY StatusEffects.idStatusEffect;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS add_status_effect;
DELIMITER //
CREATE PROCEDURE add_status_effect(
    IN idTurnsInput INT,
    IN conditionStatusInput VARCHAR(255),
    IN durationInput INT,
    IN effectAmountInput INT
)
BEGIN
    INSERT INTO StatusEffects (idTurns, conditionStatus, duration, effectAmount)
    VALUES (idTurnsInput, conditionStatusInput, durationInput, effectAmountInput);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS update_status_effect;
DELIMITER //
CREATE PROCEDURE update_status_effect(
    IN idStatusEffectInput INT,
    IN conditionStatusInput VARCHAR(255),
    IN durationInput INT,
    IN effectAmountInput INT
)
BEGIN
    UPDATE StatusEffects
    SET
        conditionStatus = conditionStatusInput,
        duration = durationInput,
        effectAmount = effectAmountInput
    WHERE idStatusEffect = idStatusEffectInput;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS delete_status_effect;
DELIMITER //
CREATE PROCEDURE delete_status_effect(
    IN idStatusEffectInput INT
)
BEGIN
    DELETE FROM StatusEffects
    WHERE idStatusEffect = idStatusEffectInput;
END //
DELIMITER ;

-- |==================================================== END OF StatusEffects Stored Procedures ===============================================================|
-- |===========================================================================================================================================================|
-- |===========================================================================================================================================================|


-- |========================================================= HealthLog Stored Procedure ======================================================================|
-- |===========================================================================================================================================================|

DROP PROCEDURE IF EXISTS get_health_logs;
DELIMITER //

CREATE PROCEDURE get_health_logs()
BEGIN
  SELECT
    HealthChangeLogs.idHealthChangeLogs,
    Characters.displayName,
    Encounters.nameOfLocation,
    Turns.actionTaken,
    Turns.roundNumber,
    HealthChangeLogs.hitPointChange,
    HealthChangeLogs.hitPointChangeSource
  FROM HealthChangeLogs
  JOIN Turns ON HealthChangeLogs.idTurns = Turns.idTurns
  JOIN CharactersEncounters ON Turns.idCharacterEncounter = CharactersEncounters.idCharacterEncounter
  JOIN Characters ON CharactersEncounters.idCharacters = Characters.idCharacters
  JOIN Encounters ON CharactersEncounters.idEncounters = Encounters.idEncounters
  ORDER BY HealthChangeLogs.idHealthChangeLogs;

  SELECT
    Turns.idTurns,
    Characters.displayName,
    Encounters.nameOfLocation
  FROM Turns
  JOIN CharactersEncounters ON Turns.idCharacterEncounter = CharactersEncounters.idCharacterEncounter
  JOIN Characters ON CharactersEncounters.idCharacters = Characters.idCharacters
  JOIN Encounters ON CharactersEncounters.idEncounters = Encounters.idEncounters
  ORDER BY Turns.idTurns;
END //

DELIMITER ;

DROP PROCEDURE IF EXISTS add_health_log;
DELIMITER //
CREATE PROCEDURE add_health_log(
  IN idTurnsInput INT,
  IN hitPointChangeInput INT,
  IN hitPointChangeSourceInput VARCHAR(255)
)
BEGIN
  INSERT INTO HealthChangeLogs (idTurns, hitPointChange, hitPointChangeSource)
  VALUES (idTurnsInput, hitPointChangeInput, hitPointChangeSourceInput);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS update_health_log;
DELIMITER //
CREATE PROCEDURE update_health_log(
  IN idHealthChangeLogsInput INT,
  IN hitPointChangeInput INT,
  IN hitPointChangeSourceInput VARCHAR(255)
)
BEGIN
  UPDATE HealthChangeLogs
  SET hitPointChange = hitPointChangeInput,
      hitPointChangeSource = hitPointChangeSourceInput
  WHERE idHealthChangeLogs = idHealthChangeLogsInput;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS delete_health_log;
DELIMITER //
CREATE PROCEDURE delete_health_log(
  IN idHealthChangeLogsInput INT
)
BEGIN
  DELETE FROM HealthChangeLogs
  WHERE idHealthChangeLogs = idHealthChangeLogsInput;
END //
DELIMITER ;

-- |======================================================== END OF HealthLog Stored Procedures ===============================================================|
-- |===========================================================================================================================================================|
-- |===========================================================================================================================================================|
-- |===========================================================================================================================================================|
