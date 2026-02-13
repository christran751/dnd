// ########################################
// ########## SETUP

// Express
const express = require('express');
const path = require('path');
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

// ---------------- HOME ----------------
app.get('/', async function (req, res) {
    try {
        res.render('index', { title: 'D&D Dashboard' });
    } catch (error) {
        console.error('Error rendering Home page:', error);
        res.status(500).send('Error loading Home page.');
    }
});

app.get('/characters', async function (req, res) {
    try {
        const [characters] = await db.query('SELECT * FROM Characters');
        res.render('characters', { title: 'Characters', characters });
    } catch (error) {
        console.error('Error loading Characters page:', error);
        res.status(500).send('Error loading Characters page.');
    }
});

// ---------------- ENCOUNTERS ----------------
app.get('/encounters', async function (req, res) {
    try {
        const [encounters] = await db.query('SELECT * FROM Encounters');
        res.render('encounters', { title: 'Encounters', encounters });
    } catch (error) {
        console.error('Error loading Encounters page:', error);
        res.status(500).send('Error loading Encounters page.');
    }
});

// ---------------- CHARACTERS_ENCOUNTERS ----------------
app.get('/characters_encounters', async function (req, res) {
    try {
        const [data] = await db.query(`
            SELECT
            Characters_Encounters.idCharacterEncounter,
            Characters.displayName,
            Encounters.nameOfLocation,
            Characters_Encounters.initiativeOrder,
            Characters_Encounters.initiativeRoll,
            Characters_Encounters.currentHitPoint
            FROM Characters_Encounters
            JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
            JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
            ORDER BY Characters_Encounters.initiativeOrder
        `);
        res.render('characters_encounters', {
            title: 'Character Encounters',
            characters_encounters: data,
        });
    } catch (error) {
        console.error('Error loading Character Encounters page:', error);
        res.status(500).send('Error loading Character Encounters page.');
    }
});

// ---------------- TURNS ----------------
app.get('/turns', async function (req, res) {
    try {
        const [turns] = await db.query(`
            SELECT
            Turns.idTurns,
            Turns.actionTaken,
            Turns.roundNumber,
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

// ---------------- HEALTH LOGS ----------------
app.get('/health_logs', async function (req, res) {
    try {
        // Fetch all health logs
        const [health_logs] = await db.query(`
            SELECT
                HealthChangeLogs.idHealthChangeLogs,
                HealthChangeLogs.hitPointChange,
                HealthChangeLogs.hitPointChangeSource,
                HealthChangeLogs.idTurns,
                Characters.displayName,
                Encounters.nameOfLocation
            FROM HealthChangeLogs
            JOIN Turns ON HealthChangeLogs.idTurns = Turns.idTurns
            JOIN Characters_Encounters ON Turns.idCharacterEncounter = Characters_Encounters.idCharacterEncounter
            JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
            JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
            ORDER BY HealthChangeLogs.idHealthChangeLogs
        `);

        // Add color for frontend
        health_logs.forEach(log => {
            log.color = log.hitPointChange < 0 ? 'red' : 'green';
        });

        // Fetch all character-encounter combos for dropdowns
        const [charEncounters] = await db.query(`
            SELECT
                Characters_Encounters.idCharacterEncounter,
                Characters.displayName,
                Encounters.nameOfLocation,
                Turns.idTurns
            FROM Characters_Encounters
            JOIN Characters ON Characters_Encounters.idCharacters = Characters.idCharacters
            JOIN Encounters ON Characters_Encounters.idEncounters = Encounters.idEncounters
            JOIN Turns ON Characters_Encounters.idCharacterEncounter = Turns.idCharacterEncounter
            ORDER BY Characters_Encounters.idCharacterEncounter
        `);

        res.render('health_logs', {
            title: 'Health Logs',
            health_logs: health_logs || [],
            charEncounters: charEncounters || []
        });

    } catch (error) {
        console.error('Error loading Health Logs page:', error);
        res.status(500).send('Error loading Health Logs page.');
    }
});

// ---------------- STATUS EFFECTS ----------------
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

// ########################################
// ########## LISTENER
app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.'
    );
});
