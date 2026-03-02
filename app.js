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

// CHRACTER PAGE
app.get('/characters', async function (req, res) {
    try {
        const [characters] = await db.query('SELECT * FROM Characters');
        res.render('characters', { title: 'Characters', characters });
    } catch (error) {
        console.error('Error loading Characters page:', error);
        res.status(500).send('Error loading Characters page.');
    }
});

// ENCOUNTER PAGE
app.get('/encounters', async function (req, res) {
    try {
        const [encounters] = await db.query('SELECT * FROM Encounters');
        res.render('encounters', { title: 'Encounters', encounters });
    } catch (error) {
        console.error('Error loading Encounters page:', error);
        res.status(500).send('Error loading Encounters page.');
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


// TURNS PAGE
app.get('/turns', async function (req, res) {
    try {
        const [turns] = await db.query(`
            SELECT
            Turns.idTurns,
            Turns.actionTaken,
            Turns.actionOrderInRound,
            Characters.displayName,
            Encounters.nameOfLocation
            FROM Turns
            JOIN Characters_Encounters ON Turns.idCharacterEncounter = Characters_Encounters.idCharacterEncounter
            JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
            JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
            ORDER BY Turns.idTurns
        `);

        const [charEncounters] = await db.query(`
            SELECT
            Characters_Encounters.idCharacterEncounter,
            Characters.displayName,
            Encounters.nameOfLocation
            FROM Characters_Encounters
            JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
            JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
            ORDER BY Characters_Encounters.idCharacterEncounter
        `);

        res.render('turns', { title: 'Turns', turns, charEncounters });
    } catch (error) {
        console.error('Error loading Turns page:', error);
        res.status(500).send('Error loading Turns page.');
    }
});

//HEALTHLOG
app.get('/health_logs', async (req, res) => {
  try {

    const [health_logs] = await db.query(`
      SELECT
        HealthChangeLogs.idHealthChangeLogs,
        Characters.displayName,
        Encounters.nameOfLocation,
        Turns.roundNumber AS roundNumber,
        HealthChangeLogs.hitPointChange,
        HealthChangeLogs.hitPointChangeSource
      FROM HealthChangeLogs
      JOIN Turns ON HealthChangeLogs.idTurns = Turns.idTurns
      JOIN Characters_Encounters ON Turns.idCharacterEncounter = Characters_Encounters.idCharacterEncounter
      JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
      JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
      ORDER BY HealthChangeLogs.idHealthChangeLogs
    `);
    // DROP DOWN USED FROM DML

    const [charEncounters] = await db.query(`
      SELECT
        Turns.idTurns,
        Characters.displayName,
        Encounters.nameOfLocation
      FROM Turns
      JOIN Characters_Encounters ON Turns.idCharacterEncounter = Characters_Encounters.idCharacterEncounter
      JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
      JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
      ORDER BY Turns.idTurns
    `);

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

    await db.query(`
      INSERT INTO HealthChangeLogs
      (idTurns, hitPointChange, hitPointChangeSource)
      VALUES (?, ?, ?)
    `, [idTurns, hitPointChange, hitPointChangeSource]);

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

    await db.query(`
      UPDATE HealthChangeLogs
      SET hitPointChange = ?, hitPointChangeSource = ?
      WHERE idHealthChangeLogs = ?
    `, [hitPointChange, hitPointChangeSource, idHealthChangeLogs]);

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

    await db.query(`
      DELETE FROM HealthChangeLogs
      WHERE idHealthChangeLogs = ?
    `, [idHealthChangeLogs]);

    res.redirect('/health_logs');

  } catch (err) {
    console.error(err);
    res.status(500).send('Error deleting Health Log');
  }
});

// STATUS EFFECTS PAGE
app.get('/status_effects', async function (req, res) {
    try {
        const [effects] = await db.query(`
            SELECT
            StatusEffects.idStatusEffect,
            StatusEffects.conditionStatus,
            StatusEffects.duration,
            StatusEffects.effectAmount,
            Characters.displayName,
            Encounters.nameOfLocation
            FROM StatusEffects
            JOIN Turns ON StatusEffects.idTurns = Turns.idTurns
            JOIN Characters_Encounters ON Turns.idCharacterEncounter = Characters_Encounters.idCharacterEncounter
            JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
            JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
            ORDER BY StatusEffects.idStatusEffect
        `);
        res.render('status_effects', { title: 'Status Effects', status_effects: effects || [] });
    } catch (error) {
        console.error('Error loading Status Effects page:', error);
        res.status(500).send('Error loading Status Effects page.');
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
