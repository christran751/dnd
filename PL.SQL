
-- Turns Stored Procedure ----------------------------------------------------------------------------------------------------------------------------------------------

-- Citation for use of AI Tools:
-- Date: 02/22/2026
-- Summary of prompts used to generate PL/SQL
-- How to convert my old app.get (that is commented below) for Turns into a Stored Procedure and then later call it in app.js?
-- AI Source URL: https://copilot.microsoft.com/
-- From there it provided a basic template for the getTurns Stored Procedure

DROP PROCEDURE IF EXISTS getTurns;
DELIMITER // 
CREATE PROCEDURE getTurns()
BEGIN
    SELECT
        Turns.idTurns,
        Turns.actionTaken,
        Turns.actionOrderInRound,
        Characters.displayName,
        Encounters.nameOfLocation
    FROM Turns
    JOIN Characters_Encounters 
        ON Turns.idCharacterEncounter = Characters_Encounters.idCharacterEncounter
    JOIN Characters 
        ON Characters_Encounters.idCharacters = Characters.idCharacters
    JOIN Encounters 
        ON Characters_Encounters.idEncounters = Encounters.idEncounters
    ORDER BY Turns.idTurns;
END //

DELIMITER ;



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
/* Citation for use of AI Tools:
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
    INSERT INTO Characters_Encounters
        (idCharacters, idEncounters, initiativeOrder, initiativeRoll)
    VALUES
        (idCharacterInput, idEncounterInput, initiativeOrderInput, initiativeRollInput);
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
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------


