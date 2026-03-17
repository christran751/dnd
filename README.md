________________________________________________________________________________________________________________________________________________________________________________________
APP.JS CITATIONS
________________________________________________________________________________________________________________________________________________________________________________________

Citation 1 for the following app.js starter code:

Date: 02/09/2026
Copied from / Adapted from: Starter Code for app.js provided by the course

Source URL: https://canvas.oregonstate.edu/courses/2031764/pages/exploration-web-application-technology-2?module_item_id=26243419

Type: Starter code / application

Author: Oregon State University and Dr. Michael Curry

Notes:

This file is mainly copied (the Express, Handlebars, and Database setup portions were copied word-for-word), with minor adaptations for project structure and port configuration.
The read routes and other route handling logic are primarily our own work, using the starter code as a basis.
Original work (custom routes, logic, database queries) is clearly documented inline.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Citation 2 for use of AI Tools:

Date: 02/22/2026

Summary of prompts used to generate route for SELECT or READ:

To route in app.js for READ or SELECT operation do I need to capture and then render

AI Source URL: https://claude.ai/chat/69a43844-fd5b-484a-bb44-8be2776eae5d

From there, it tells me:

Yes! For any READ/SELECT operation the pattern is always:

    app.get('/entity', async function (req, res) {
    try {
    const [rows] = await db.query('CALL get_entity()');  // 1. capture
    const entity = rows[0];                               // 2. unwrap
    res.render('entity', { title: 'Entity', entity });   // 3. render

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Citation 3 for the following app.get Turns code:

Date: 2/22/2026

Copied and Adapted from: Project Step 4 Draft Version: Add RESET stored procedure (SP)

Source URL: 

https://canvas.oregonstate.edu/courses/2031764/assignments/10323339?module_item_id=26243440

Type: Starter code / application

Author: Oregon State University and Dr. Michael Curry

Notes:

    Added const [charEncounters] to fetch the data that will populate the dropdowns
    Used Node.js with Express, and res.render() to take a template file, fill it with data from our DND server.
    Everything else was copied from source.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Citation 4 for use of AI Tools:

Date: 02/22/2026

Summary of prompts used to generate PL/SQL

How to convert my old app.get (that is commented below) for Turns into a Stored Procedure and then later call it in app.js?

AI Source URL: https://copilot.microsoft.com/

From there it provided a basic template for the getTurns Stored Procedure

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Citation 5 for the following app.get CHARACTERS_ENCOUNTERS code:

Date: 2/24/2026

Copied and Adapted from: Project Step 4 Draft Version: Add RESET stored procedure (SP)

Source URL: https://canvas.oregonstate.edu/courses/2031764/assignments/10323339?module_item_id=26243440

Type: Starter code / application

Author: Oregon State University and Dr. Michael Curry

Notes:

    Added const [characters] and const [encounters] to fetch the data that will populate the dropdowns
    Used Node.js with Express, and res.render() to take a template file, fill it with data from our DND server.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Citation 6 for the following app.get RESET-DATABASE starter code:

Date: 03/01/2026

Copied and Adapted from:

Source URL: https://canvas.oregonstate.edu/courses/2031764/assignments/10323339?module_item_id=26243440

Type: Starter code / application

Author: Oregon State University and Dr. Michael Curry

Notes:

    Used as a reference for implementing a route that calls a PL/SQL stored procedure to reset the database.
    Adapted for this D&D project to reset all tables and sample data.
    The only changed made was instead of using two lines to call the query, I just skip the variable and do await db.query('CALL DeleteGaiusBaltar();'); directly


Citation 7 for use of AI Tools:

Date: 03/08/2026

Summary of prompts used to generate app.post for the entire UPDATE, ADD, and DELETE.

For app.post, do I need to capture anything, or is the syntax similiar to app.get

AI Source URL: https://claude.ai/chat/69a43844-fd5b-484a-bb44-8be2776eae5d

From there it tells me:

    For app.post the syntax is similar but simpler — the only thing you need to capture is req.body: 
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
                
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Citation 8 for use of AI Tools:

Date: 03/16/2026

Summary of prompts used:

How do I fix currentHitPoint so that healing works correctly when HP is at 0, instead of having it start from a negative value?
For example, if the max HP is 60 and the character takes 80 damage, healing with +12 should restore HP properly instead (0 + 12 = 12) of adding to a negative number (-20 + 12).

AI Source URL: https://claude.ai/

From there it tells me:

    It's not possible to implement that specific encounter in SQL.
    Instead of letting SQL do SUM(hitPointChange) all at once, we fetch each individual log entry and process them one by one, clamping after each change.
    The const [healthLogs], const logsByEncounter, and const data = characters_encounters[0].map were generated with AI assistance.
    
At first I tried:
         GREATEST(
            0,
         LEAST(
      COALESCE(Characters.maxHitPoint, 0) + COALESCE(SUM(CASE WHEN HealthChangeLogs.hitPointChange < 0 THEN 0 ELSE HealthChangeLogs.hitPointChange END), 0),
                  COALESCE(Characters.maxHitPoint, 0)
              )
              ) AS currentHitPoint,
          
In the SP, but that this just zero out all the damage.

________________________________________________________________________________________________________________________________________________________________________________________
DDL.SQL Citations
________________________________________________________________________________________________________________________________________________________________________________________

Citation for use of AI Tools:

-- Date: 3/01/2026

-- Prompt Used to Generated Code:

-- Given my DDL I just pasted, for my DDL and Stored Procedure, is my order of drop tables correct, since I have some parent and child table.

-- The correct order it gave me is this:

-- 1. StatusEffects

-- 2. HealthChangeLogs

-- 3. Turns

-- 4. Characters_Encounters

-- 5. Encounters

-- 6. Characters

    -- This order respects all foreign‑key dependencies.
    -- I also didn't ask, but it recommend that I entire reset in a transaction before disabling FK checks.
    -- START TRANSACTION; SET FOREIGN_KEY_CHECKS = 0;
    -- Source URL: https://copilot.microsoft.com/chats/R3jE5zFxMR1atYZKcZagW

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Citation for use of AI Tools:

-- Use to help tweak sample data because before Players, i.e., Aaragorn and Gandalf were attacking each other.

-- Date: 3/06/2026

-- Prompt Used to Generated Code:

-- Can you update my INSERT schema only to make my data feel more DnD-inspired by adding a few monster NPCs, and make sure players can only attack NPCs, not each other.

-- Source URL: https://claude.ai/chat/97cc5a49-2ab4-4117-8ab4-fd0fb407fa9c

