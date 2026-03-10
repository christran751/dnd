______________________________________________________________________________________________________________________________________________________________________________________
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
______________________________________________________________________________________________________________________________________________________________________________________

{{!
Citation for the characters handlebar starter code:
Date: 02/12/2026
Source URL: https://canvas.oregonstate.edu/courses/2031764/pages/exploration-web-application-technology-2?module_item_id=26243419
Type: Starter code / application
Author: Oregon State University
Notes:
We used this template for reference
The table structure and form structure for read/create/update/delete were adapted to best match our database, i.e., the delete functionality was adapted to appear as a row-level button within the table instead of a separate form
}}

{{!Adapted from the provided bsg-people.hbs starter code}}
______________________________________________________________________________________________________________________________________________________________________________________

{{!
Citation for the characters_encounters handlebar starter code:
Date: 02/12/2026
Source URL: https://canvas.oregonstate.edu/courses/2031764/pages/exploration-web-application-technology-2?module_item_id=26243419
Type: Starter code / application
Author: Oregon State University
Notes:
We used this template for reference
The table structure and form structure for read/create/update/delete were adapted to best match our database, i.e., the delete functionality was adapted to appear as a row-level button within the table instead of a separate form
}}

{{!Adapted from the provided bsg-people.hbs starter code}}
______________________________________________________________________________________________________________________________________________________________________________________

{{!
Citation for the encounters handlebar starter code:
Date: 02/12/2026
Source URL: https://canvas.oregonstate.edu/courses/2031764/pages/exploration-web-application-technology-2?module_item_id=26243419
Type: Starter code / application
Author: Oregon State University
Notes:
We used this template for reference
The table structure and form structure for read/create/update/delete were adapted to best match our database, i.e., the delete functionality was adapted to appear as a row-level button within the table instead of a separate form
}}

{{!Adapted from the provided bsg-people.hbs starter code}}

______________________________________________________________________________________________________________________________________________________________________________________

{{!
Citation for the health_logs handlebar starter code:
Date: 02/12/2026
Source URL: https://canvas.oregonstate.edu/courses/2031764/pages/exploration-web-application-technology-2?module_item_id=26243419
Type: Starter code / application
Author: Oregon State University
Notes:
We used this template for reference
The table structure and form structure for read/create/update/delete were adapted to best match our database, i.e., the delete functionality was adapted to appear as a row-level button within the table instead of a separate form
}}

{{!Adapted from the provided bsg-people.hbs starter code}}

______________________________________________________________________________________________________________________________________________________________________________________

{{!
Citation for the index handlebar starter code:
Date: 02/12/2026
Source URL: https://canvas.oregonstate.edu/courses/2031764/pages/exploration-web-application-technology-2?module_item_id=26243419
Type: Starter code / application
Author: Oregon State University
Notes:
We used this template for reference
The table structure and form structure for read/create/update/delete were adapted to best match our database, i.e., the delete functionality was adapted to appear as a row-level button within the table instead of a separate form
}}

______________________________________________________________________________________________________________________________________________________________________________________

{{!
Citation for the status_effects handlebar starter code:
Date: 02/12/2026
Source URL: https://canvas.oregonstate.edu/courses/2031764/pages/exploration-web-application-technology-2?module_item_id=26243419
Type: Starter code / application
Author: Oregon State University
Notes:
We used this template for reference
The table structure and form structure for read/create/update/delete were adapted to best match our database, i.e., the delete functionality was adapted to appear as a row-level button within the table instead of a separate form
}}

{{!Adapted from the provided bsg-people.hbs starter code}}

______________________________________________________________________________________________________________________________________________________________________________________

{{!
Citation for the handlebar starter code:
Date: 02/12/2026
Source URL: https://canvas.oregonstate.edu/courses/2031764/pages/exploration-web-application-technology-2?module_item_id=26243419
Type: Starter code / application
Author: Oregon State University
Notes:
We used this template for reference
The table structure and form structure for read/create/update/delete were adapted to best match our database, i.e., the delete functionality was adapted to appear as a row-level button within the table instead of a separate form
}}

{{!Adapted from the provided bsg-people.hbs starter code}}

______________________________________________________________________________________________________________________________________________________________________________________


{{!
Citation for the main handlebar starter code:
Date: 02/12/2026
Source URL: https://canvas.oregonstate.edu/courses/2031764/pages/exploration-web-application-technology-2?module_item_id=26243419
Type: Starter code / application
Author: Oregon State University
Notes:
We used this template for reference
}}

{{!Adapted from the provided main.hbs starter code}}

______________________________________________________________________________________________________________________________________________________________________________________

-- Citation for use of AI Tools:
-- Date: 02/22/2026
-- Summary of prompts used to help build a stored procedure
-- What is the general syntax of a stored procedure
-- AI Source URL: https://claude.ai/chat/8e1f2ef6-3168-4bb4-b182-5e0e633eaa5b
______________________________________________________________________________________________________________________________________________________________________________________

-- Citation for use of AI Tools:
-- Date: 02/22/2026
-- Summary of prompts used to help build a stored procedure
-- What is the general syntax of a stored procedure
-- AI Source URL: https://claude.ai/chat/8e1f2ef6-3168-4bb4-b182-5e0e633eaa5b

______________________________________________________________________________________________________________________________________________________________________________________


-- Citation for use of AI Tools:
-- Date: 02/22/2026
-- Summary of prompts used to generate PL/SQL
-- How to convert my old app.get (that is commented below) for Turns into a Stored Procedure and then later call it in app.js?
-- AI Source URL: https://copilot.microsoft.com/
-- From there it provided a basic template for the getTurns Stored Procedure

______________________________________________________________________________________________________________________________________________________________________________________

Citation for use of AI Tools:
Date: 02/22/2026
Summary of prompts used to generate route for SELECT or READ
To route in app.js for READ or SELECT operation do I need to capture and then render
AI Source URL: https://claude.ai/chat/69a43844-fd5b-484a-bb44-8be2776eae5d
From there, it tells me to: 
  "Yes! For any READ/SELECT operation the pattern is always:
  app.get('/entity', async function (req, res) {
      try {
          const [rows] = await db.query('CALL get_entity()');  // 1. capture
          const entity = rows[0];                               // 2. unwrap
          res.render('entity', { title: 'Entity', entity });   // 3. render"
          
______________________________________________________________________________________________________________________________________________________________________________________
 
Citation for the following app.get Turns code:
Date: 2/22/2026
Copied and Adapted from: Project Step 4 Draft Version: Add RESET stored procedure (SP)
Source URL: https://canvas.oregonstate.edu/courses/2031764/assignments/10323339?module_item_id=26243440
Type: Starter code / application
Author: Oregon State University and Dr. Michael Curry
Notes:
- Added const [charEncounters] to fetch the data that will populate the dropdowns
- Used Node.js with Express, and res.render() to take a template file, fill it with data from our DND server.
______________________________________________________________________________________________________________________________________________________________________________________

Citation for use of AI Tools:
Date: 02/22/2026
Summary of prompts used to generate PL/SQL
How to convert my old app.get (that is commented below) for Turns into a Stored Procedure and then later call it in app.js?
AI Source URL: https://copilot.microsoft.com/
From there it provided a basic template for the getTurns Stored Procedure
______________________________________________________________________________________________________________________________________________________________________________________

Citation for the following app.get CHARACTERS_ENCOUNTERS code:
Date: 2/24/2026
Copied and Adapted from: Project Step 4 Draft Version: Add RESET stored procedure (SP)
Source URL: https://canvas.oregonstate.edu/courses/2031764/assignments/10323339?module_item_id=26243440
Type: Starter code / application
Author: Oregon State University and Dr. Michael Curry
Notes:
- Added const [characters] and const [encounters] to fetch the data that will populate the dropdowns
- Used Node.js with Express, and res.render() to take a template file, fill it with data from our DND server.
______________________________________________________________________________________________________________________________________________________________________________________
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
______________________________________________________________________________________________________________________________________________________________________________________
Citation for use of AI Tools:
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
______________________________________________________________________________________________________________________________________________________________________________________

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
______________________________________________________________________________________________________________________________________________________________________________________

-- Stored Procedure to RESET DDL
-- Citation for use of AI Tools:
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
______________________________________________________________________________________________________________________________________________________________________________________

-- Citation for use of AI Tools:
-- Use to help tweak sample data because before Players, i.e., Aaragorn and Gandalf were attacking each other.
-- Date: 3/06/2026
-- Prompt Used to Generated Code:
-- Can you update my INSERT schema only to make my data feel more DnD-inspired by adding a few monster NPCs, and make sure players can only attack NPCs, not each other.
-- Source URL: https://claude.ai/chat/97cc5a49-2ab4-4117-8ab4-fd0fb407fa9c
______________________________________________________________________________________________________________________________________________________________________________________

Citation for use of AI Tools:
Date: 03/08/2026
Summary of prompts used to generate app.post for the entire UPDATE, ADD, and DELETE.
For app.post, do I need to capture anything, or is the syntax similiar to app.get
AI Source URL: https://claude.ai/chat/69a43844-fd5b-484a-bb44-8be2776eae5d
From there it tells me:
  "For app.post the syntax is similar but simpler — the only thing you need to capture is req.body:
      app.post('/your-route', async function (req, res) {
          try {
              const { field1, field2 } = req.body;  // grab form data
              await db.query(`CALL yourStoredProcedure(?, ?)`, [field1, field2]); // call Stored Procedure
              res.redirect('/your-route');
          } catch (error) {
              console.error('Error:', error);
              res.status(500).send('Error executing request.');
          }
      });"
______________________________________________________________________________________________________________________________________________________________________________________

-- Citation for use of AI Tools:
-- Date: 03/09/2026
-- Summary of prompts used to help build a stored procedure for get health log entry
-- For HealthLog is it better to have a separate dropdown STORED PROCEDURE or have it in get_health_logs?
-- AI Source URL: https://claude.ai/chat/8e1f2ef6-3168-4bb4-b182-5e0e633eaa5b
______________________________________________________________________________________________________________________________________________________________________________________

-- Citation for use of AI Tools:
-- Date: 03/09/2026
-- Summary of prompts used to help build a stored procedure for get health log entry
-- For HealthLog is it better to have a separate dropdown STORED PROCEDURE or have it in get_health_logs?
-- AI Source URL: https://claude.ai/chat/8e1f2ef6-3168-4bb4-b182-5e0e633eaa5b
______________________________________________________________________________________________________________________________________________________________________________________
