USE `cs340_tranchri`;

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- Character_Encounter Stored Procedure 

-- Stored Procedure to get (or read) Chracter_Encounters
-- Citation for use of AI Tools:
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
DROP PROCEDURE IF EXISTS getCharacterEncounters;
DELIMITER //
CREATE PROCEDURE getCharacterEncounters()
BEGIN
    SELECT
      Characters_Encounters.idCharacterEncounter,
      Characters.displayName,
      Encounters.nameOfLocation,
      Characters_Encounters.initiativeOrder,
      Characters_Encounters.initiativeRoll,
      -- Copied from copilot
      GREATEST(
        0,
        LEAST(
          COALESCE(Characters.maxHitPoint, 0) + COALESCE(SUM(HealthChangeLogs.hitPointChange), 0),
          COALESCE(Characters.maxHitPoint, 0)
        )
      ) AS currentHitPoint,
      COALESCE(Characters.maxHitPoint, 0) AS maxHitPoint
      -- end of copy. 
    FROM Characters_Encounters
    JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
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
END //
DELIMITER ;


-- // DELETE CHARACTER-ENCOUNTER
-- app.post('/delete-character-encounter', async (req, res) => {
--   console.log("DELETE HIT!", req.body); // debugging
--   const { idCharacterEncounter } = req.body;

--   await db.query(
--     `DELETE FROM Characters_Encounters WHERE idCharacterEncounter = ?`,
--     [idCharacterEncounter]
--   );

--   res.redirect('/characters_encounters');
-- });

-- Stored Procedure to DELETE Chracter_Encounters
DROP PROCEDURE IF EXISTS deleteCharacterEncounter;
DELIMITER //
CREATE PROCEDURE deleteCharacterEncounter(IN idCharacterEncounterInput INT)
BEGIN
    DELETE FROM Characters_Encounters
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
    -- Since we are inserting into different tables, we need to use a transaction
    INSERT INTO Characters_Encounters
        (idCharacters, idEncounters, initiativeOrder, initiativeRoll)
    VALUES
        (idCharacterInput, idEncounterInput, initiativeOrderInput, initiativeRollInput);
	-- Got from CoPilot (Full citation on README)
    SET newCharacterEncounterID = LAST_INSERT_ID();
    INSERT INTO Turns (idCharacterEncounter, actionOrderInRound, roundNumber, actionTaken)
    VALUES (
        newCharacterEncounterID,
        initiativeOrderInput,
        1,
        'No Action Taken'
    );
    -- END OF COPY
    COMMIT;
END //
DELIMITER ;

-- Stored Procedure to Update Chracter_Encounters
DROP PROCEDURE IF EXISTS updateCharacterEncounter;
DELIMITER //
CREATE PROCEDURE updateCharacterEncounter(
    IN idCharacterEncounterInput INT,  
    IN initiativeOrderInput INT,
    IN initiativeRollInput INT
)
BEGIN
    UPDATE Characters_Encounters
    SET 
        initiativeOrder = initiativeOrderInput,
        initiativeRoll = initiativeRollInput
    WHERE idCharacterEncounter = idCharacterEncounterInput;
END //
DELIMITER ;
