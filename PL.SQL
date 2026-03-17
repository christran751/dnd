DROP PROCEDURE IF EXISTS update_status_effect;
DELIMITER //
CREATE PROCEDURE update_status_effect(
    IN idStatusEffectInput INT,
    IN conditionStatusInput VARCHAR(255),
    IN durationInput INT,
    IN effectAmountInput INT
)
BEGIN
	IF conditionStatusInput NOT IN ('Healthy', 'Buffed', 'Poisoned', 'Stunned', 'Dead') then SET conditionStatusInput = 'Healthy';
    END IF;
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

