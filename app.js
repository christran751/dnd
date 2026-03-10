/*
Citation for the following app.js starter code:
Date: 02/09/2026
Copied from / Adapted from: Starter Code for app.js provided by the course
Source URL: https://canvas.oregonstate.edu/courses/2031764/pages/exploration-web-application-technology-2?module_item_id=26243419
Type: Starter code / application
Author: Oregon State University and Dr. Michael Curry
Notes:
- This file is mainly copied (the Express, Handlebars, and Database setup portions were copied word-for-word), with minor adaptations for project structure and port configuration.
- The read routes and other route handling logic are primarily our own work, using the starter code as a basis.
- Original work (custom routes, logic, database queries) is clearly documented inline.
*/
// ########################################
// ########## SETUP

// Adapted from the provided app.js

// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 1329;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars'); // Import express-handlebars engine
app.engine('.hbs', engine({ extname: '.hbs' })); // Create instance of handlebars
app.set('view engine', '.hbs'); // Use handlebars engine for *.hbs files.

// ########################################
// ########## ROUTE HANDLERS


// EVERYHTING ELSE BELOW IS OF OUR OWN WORK
// HOMEPAGE
app.get('/', async function (req, res) {
    try {
        res.render('index', { title: 'D&D Dashboard' });
    } catch (error) {
        console.error('Error rendering Home page:', error);
        res.status(500).send('Error loading Home page.');
    }
});

// RESET DND DATABASE
/*
Citation for the following app.get RESET-DATABASE starter code:
Date: 03/01/2026
Copied and Adapted from:
Source URL: https://canvas.oregonstate.edu/courses/2031764/assignments/10323339?module_item_id=26243440
Type: Starter code / application
Author: Oregon State University and Dr. Michael Curry
Notes:
- Used as a reference for implementing a route that calls a PL/SQL stored procedure to reset the database.
- Adapted for this D&D project to reset all tables and sample data.
- The only changed made was instead of using two lines to call the query, I just skip the variable and do await db.query('CALL DeleteGaiusBaltar();'); directly
*/

app.post('/reset-database', async (req, res) => {
    try {
        await db.query('CALL resetDatabaseDND();');
        res.redirect('/'); // go back to homepage after reset
    } catch (error) {
        console.error("Error executing PL/SQL:", error);
        res.status(500).send("An error occurred while executing the PL/SQL.");
    }
});


/*
-- Citation for use of AI Tools:
-- Date: 02/22/2026
-- Summary of prompts used to generate route for SELECT or READ
-- To route in app.js for READ or SELECT operation do I need to capture and then render
-- AI Source URL: https://claude.ai/chat/69a43844-fd5b-484a-bb44-8be2776eae5d
-- From there, it tells me
Yes! For any READ/SELECT operation the pattern is always:
app.get('/entity', async function (req, res) {
    try {
        const [rows] = await db.query('CALL get_entity()');  // 1. capture
        const entity = rows[0];                               // 2. unwrap
        res.render('entity', { title: 'Entity', entity });   // 3. render
*/

/*
-- Citation for use of AI Tools:
-- Date: 03/08/2026
-- Summary of prompts used to generate app.post for the entire UPDATE, ADD, and DELETE.
-- For app.post, do I need to capture anything, or is the syntax similiar to app.get
-- AI Source URL: https://claude.ai/chat/69a43844-fd5b-484a-bb44-8be2776eae5d
-- From there it tells me:
-- For app.post the syntax is similar but simpler — the only thing you need to capture is req.body:
    app.post('/your-route', async function (req, res) {
        try {
            const { field1, field2 } = req.body;  // grab form data

            await db.query(`CALL yourStoredProcedure(?, ?)`, [field1, field2]); // call Stored Procedure

            res.redirect('/your-route');
        } catch (error) {
            console.error('Error:', error);
            res.status(500).send('Error executing request.');
        }
    });
*/

// CHRACTER PAGE
app.get('/characters', async function (req, res) {
    try {
        const [rows] = await db.query('CALL get_characters()');

        // Stored procedures return results inside rows[0]
        const characters = rows[0];

        res.render('characters', { title: 'Characters', characters });

    } catch (error) {
        console.error('Error loading Characters page:', error);
        res.status(500).send('Error loading Characters page.');
    }
});

// ADD CHARACTERS
app.post('/characters/add', async (req, res) => {
    try {
        const {displayNameInput, raceInput, characterClassInput, characterRoleInput, characterLevelInput,
            maxHitPointInput, armorClassInput, initiativeBonusInput } = req.body;

        await db.query(
            `CALL add_character(?, ?, ?, ?, ?, ?, ?, ?)`,
            [ displayNameInput, raceInput, characterClassInput, characterRoleInput, characterLevelInput,
            maxHitPointInput, armorClassInput, initiativeBonusInput]
        );

        res.redirect('/characters');

    } catch (err) {
        console.error('Error adding Character:', err);
        res.status(500).send('Error adding Character.');
    }
});

//UPDATE CHARACTERS
app.post('/characters/update', async (req, res) => {
    try {
        const {
            idCharactersInput, displayNameInput, raceInput, characterClassInput, characterRoleInput,
            characterLevelInput, maxHitPointInput, armorClassInput, initiativeBonusInput
        } = req.body;

        await db.query(
            'CALL update_character(?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [idCharactersInput, displayNameInput, raceInput, characterClassInput, characterRoleInput,
            characterLevelInput, maxHitPointInput, armorClassInput, initiativeBonusInput]
        );

        res.redirect('/characters');
    } catch (err) {
        console.error('Error updating Character:', err);
        res.status(500).send('Error updating Character.');
    }
});

// DELETE CHARACTERS
app.post('/characters/delete', async (req, res) => {
    try {
        const { idCharactersInput } = req.body;
        await db.query('CALL delete_character(?)', [idCharactersInput]);
        res.redirect('/characters');
    } catch (err) {
        console.error('Error deleting Character:', err);
        res.status(500).send('Error deleting Character.');
    }
});

// Encounter Page

// Get
app.get('/encounters', async (req, res) => {
    try {
        const [encounters] = await db.query('CALL get_encounters()');
        res.render('encounters', { title: 'Encounters', encounters: encounters[0] });
    } catch (err) {
        console.error('Error loading encounters:', err);
        res.status(500).send('Error loading encounters.');
    }
});


// ADD Encounter
app.post('/encounters/add', async (req, res) => {
    try {

        const { nameOfLocationInput, locationInput } = req.body;

        await db.query(
            'CALL add_encounter(?, ?)',
            [nameOfLocationInput, locationInput]
        );

        res.redirect('/encounters');

    } catch (err) {
        console.error('Error adding encounter:', err);
        res.status(500).send('Error adding encounter.');
    }
});


// UPDATE Encounter
app.post('/encounters/update', async (req, res) => {
    try {

        const { idEncountersInput, nameOfLocationInput, locationInput } = req.body;

        await db.query(
            'CALL update_encounter(?, ?, ?)',
            [idEncountersInput, nameOfLocationInput, locationInput]
        );

        res.redirect('/encounters');

    } catch (err) {
        console.error('Error updating encounter:', err);
        res.status(500).send('Error updating encounter.');
    }
});


// DELETE Encounter
app.post('/encounters/delete', async (req, res) => {
    try {

        const { idEncountersInput } = req.body;

        await db.query(
            'CALL delete_encounter(?)',
            [idEncountersInput]
        );

        res.redirect('/encounters');

    } catch (err) {
        console.error('Error deleting encounter:', err);
        res.status(500).send('Error deleting encounter.');
    }
});
/*
Citation for the following app.get CHARACTERS_ENCOUNTERS code:
Date: 2/24/2026
Copied and Adapted from: Project Step 4 Draft Version: Add RESET stored procedure (SP)
Source URL: https://canvas.oregonstate.edu/courses/2031764/assignments/10323339?module_item_id=26243440
Type: Starter code / application
Author: Oregon State University and Dr. Michael Curry
Notes:
- Added const [characters] and const [encounters] to fetch the data that will populate the dropdowns
- Used Node.js with Express, and res.render() to take a template file, fill it with data from our DND server.
*/

// CHARACTERS_ENCOUNTERS PAGE
app.get('/characters_encounters', async function (req, res) {
    try {
        // Call the stored procedure
        const [characters_encounters] = await db.query(`CALL getCharacterEncounters()`);
        const [characters] = await db.query(`SELECT idCharacters, displayName FROM Characters`);
        const [encounters] = await db.query(`SELECT idEncounters, nameOfLocation FROM Encounters`);

        res.render('characters_encounters', {
            title: 'Character Encounters',
            characters_encounters: characters_encounters[0],
            characters,
            encounters
        });

    } catch (error) {
        console.error('Error loading Character Encounters page:', error);
        res.status(500).send('Error loading Character Encounters page.');
    }
});


// DELETE CHARACTER-ENCOUNTER
app.post('/delete-character-encounter', async (req, res) => {
    try {
        const { idCharacterEncounter } = req.body;

        // Call the stored procedure
        await db.query(`CALL deleteCharacterEncounter(?)`, [idCharacterEncounter]);
        res.redirect('/characters_encounters');
    } catch (err) {
        console.error('Error deleting Character Encounter:', err);
        res.status(500).send('Error deleting Character Encounter.');
    }
});

// ADD CHARACTER_ENCOUNTERS
app.post('/characters_encounters/add', async (req, res) => {
    try {
        const { idCharacter, idEncounter, initiativeOrder, initiativeRoll } = req.body;

        // Call the stored procedure
        await db.query(
            `CALL addCharacterEncounter(?, ?, ?, ?)`,
            [idCharacter, idEncounter, initiativeOrder, initiativeRoll]
        );

        res.redirect('/characters_encounters');
    } catch (err) {
        console.error('Error adding Character Encounter:', err);
        res.status(500).send('Error adding Character Encounter.');
    }
});

//UPDATE CHARACTER_ENCOUNTERS
app.post('/characters_encounters/update', async (req, res) => {
    try {
        const { idCharacterEncounter, initiativeOrder, initiativeRoll } = req.body;

        // Calling stored procedure
        await db.query(
            'CALL updateCharacterEncounter(?, ?, ?)',
            [idCharacterEncounter, initiativeOrder, initiativeRoll]
        );

        res.redirect('/characters_encounters');

    } catch (err) {
        console.error('Error updating Character Encounter:', err);
        res.status(500).send('Error updating Character Encounter.');
    }
});
// Used both AI and Provided Course Material to Learn on how to set up Stored Procedure and set it up and call it in app.js

/*
Citation for the following app.get Turns code:
Date: 2/22/2026
Copied and Adapted from: Project Step 4 Draft Version: Add RESET stored procedure (SP)
Source URL: https://canvas.oregonstate.edu/courses/2031764/assignments/10323339?module_item_id=26243440
Type: Starter code / application
Author: Oregon State University and Dr. Michael Curry
Notes:
- Added const [charEncounters] to fetch the data that will populate the dropdowns
- Used Node.js with Express, and res.render() to take a template file, fill it with data from our DND server.
*/

/*
-- Citation for use of AI Tools:
-- Date: 02/22/2026
-- Summary of prompts used to generate PL/SQL
-- How to convert my old app.get (that is commented below) for Turns into a Stored Procedure and then later call it in app.js?
-- AI Source URL: https://copilot.microsoft.com/
-- From there it provided a basic template for the getTurns Stored Procedure
*/
app.get('/turns', async function (req, res) {
    try {
        // Call the stored procedure
        const [turns] = await db.query("CALL getTurns()");
        // For DROP DOWN
        const [charEncounters] = await db.query("CALL getCharacterEncounters()");
        res.render('turns', {
            title: 'Turns',
            turns: turns[0],
            charEncounters: charEncounters[0]
        });

    } catch (error) {
        console.error('Error loading Turns page:', error);
        res.status(500).send('Error loading Turns page.');
    }
});

// OLD TURN W.OUT USING SP -- KEEPING FOR REFERENCE
// // TURNS PAGE
// app.get('/turns', async function (req, res) {
//     try {
//         const [turns] = await db.query(`
//             SELECT
//             Turns.idTurns,
//             Turns.actionTaken,
//             Turns.actionOrderInRound,
//             Characters.displayName,
//             Encounters.nameOfLocation
//             FROM Turns
//             JOIN Characters_Encounters ON Turns.idCharacterEncounter = Characters_Encounters.idCharacterEncounter
//             JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
//             JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
//             ORDER BY Turns.idTurns
//         `);

//         const [charEncounters] = await db.query(`
//             SELECT
//             Characters_Encounters.idCharacterEncounter,
//             Characters.displayName,
//             Encounters.nameOfLocation
//             FROM Characters_Encounters
//             JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
//             JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
//             ORDER BY Characters_Encounters.idCharacterEncounter
//         `);

//         res.render('turns', { title: 'Turns', turns, charEncounters });
//     } catch (error) {
//         console.error('Error loading Turns page:', error);
//         res.status(500).send('Error loading Turns page.');
//     }
// });


// ADD TURNS
app.post('/turns/add', async (req, res) => {
  try {
    const { idCharacterEncounter, actionTaken, roundNumber, actionOrderInRound } = req.body;

    await db.query(
      'CALL addTurn(?, ?, ?, ?);',
      [idCharacterEncounter, actionTaken, roundNumber, actionOrderInRound]
    );

    res.redirect('/turns');
  } catch (err) {
    console.error(err);
    res.status(500).send("Error adding turn.");
  }
});

// UPDATE TURNS
app.post('/turns/update', async (req, res) => {
    const { idTurns, actionTaken, roundNumber, actionOrderInRound } = req.body;

    try {
        await db.query(
            "CALL updateTurn(?, ?, ?, ?);",
            [idTurns, actionTaken, roundNumber, actionOrderInRound]
        );
        res.redirect('/turns');
    } catch (err) {
        console.error("Error updating turn:", err);
        res.status(500).send("Error updating turn.");
    }
});

// DELETE TURNS
app.post('/turns/delete', async (req, res) => {
    const { idTurns } = req.body;

    try {
        await db.query(
            "CALL deleteTurn(?);",
            [idTurns]
        );
        res.redirect('/turns');
    } catch (err) {
        console.error("Error deleting turn:", err);
        res.status(500).send("Error deleting turn.");
    }
});

// HealthLogs
app.get('/health_logs', async (req, res) => {
  try {
    const [results] = await db.query('CALL get_health_logs()');
    // MySQL returns multiple result sets as results[0], results[1], etc.
    const health_logs = results[0];
    const charEncounters = results[1];

    res.render('health_logs', {
      title: 'Health Logs',
      health_logs,
      charEncounters
    });

  } catch (err) {
    console.error(err);
    res.status(500).send('Error loading Health Logs page');
  }
});

// ADD HEALTH LOG

app.post('/health_logs/add', async (req, res) => {
  try {
    const { idTurns, hitPointChange, hitPointChangeSource } = req.body;
    await db.query('CALL add_health_log(?, ?, ?)',
      [idTurns, hitPointChange, hitPointChangeSource]);

    res.redirect('/health_logs');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error adding Health Log');
  }
});


// UPDATE HEALTH LOG

app.post('/health_logs/update', async (req, res) => {
  try {
    const { idHealthChangeLogs, hitPointChange, hitPointChangeSource } = req.body;

    await db.query('CALL update_health_log(?, ?, ?)',
      [idHealthChangeLogs, hitPointChange, hitPointChangeSource]);

    res.redirect('/health_logs');

  } catch (err) {
    console.error(err);
    res.status(500).send('Error updating Health Log');
  }
});


// DELETE HEALTH LOG
app.post('/health_logs/delete', async (req, res) => {
  try {
    const { idHealthChangeLogs } = req.body;
    await db.query('CALL delete_health_log(?)',
      [idHealthChangeLogs]);
    res.redirect('/health_logs');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error deleting Health Log');
  }
});

// Status Effect

app.get('/status_effects', async function (req, res) {
    try {
        const [rows] = await db.query('CALL get_status_effects()');
        const status_effects = rows[0];

        const [turnRows] = await db.query(`
            SELECT Turns.idTurns, Characters.displayName, Encounters.nameOfLocation
            FROM Turns
            JOIN Characters_Encounters ON Turns.idCharacterEncounter = Characters_Encounters.idCharacterEncounter
            JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
            JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
            ORDER BY Turns.idTurns
        `);

        res.render('status_effects', {
            title: 'Status Effects',
            status_effects: status_effects || [],
            turnsForDropdown: turnRows  // this is what the dropdown needs
        });

    } catch (error) {
        console.error('Error loading Status Effects page:', error);
        res.status(500).send('Error loading Status Effects page.');
    }
});

// ADD STATUS EFFECT
app.post('/status_effects/add', async function (req, res) {
    try {
        const { idTurns, conditionStatus, duration, effectAmount } = req.body;
        await db.query('CALL add_status_effect(?, ?, ?, ?)',
            [idTurns, conditionStatus, duration, effectAmount]
        );
        res.redirect('/status_effects');
    } catch (error) {
        console.error('Error adding Status Effect:', error);
        res.status(500).send('Error adding Status Effect.');
    }
});

// UPDATE STATUS EFFECT
app.post('/status_effects/update', async function (req, res) {
    try {
        const { idStatusEffect, conditionStatus, duration, effectAmount } = req.body;
        await db.query('CALL update_status_effect(?, ?, ?, ?)',
            [idStatusEffect, conditionStatus, duration, effectAmount]
        );
        res.redirect('/status_effects');
    } catch (error) {
        console.error('Error updating Status Effect:', error);
        res.status(500).send('Error updating Status Effect.');
    }
});

// DELETE STATUS EFFECT
app.post('/status_effects/delete', async function (req, res) {
    try {
        const { idStatusEffect } = req.body;
        await db.query('CALL delete_status_effect(?)', [idStatusEffect]);
        res.redirect('/status_effects');
    } catch (error) {
        console.error('Error deleting Status Effect:', error);
        res.status(500).send('Error deleting Status Effect.');
    }
});

// COPIED AND PASTE FROM COURSE MATERIAL
// ########################################
// ########## LISTENER
app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.'
    );
});

