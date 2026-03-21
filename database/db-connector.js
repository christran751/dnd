// /*
// Citation for the following db-connector.js code:
// Date: 02/09/2026
// Copied from / Adapted from: Starter Code for app.js provided by the course
// Source URL: https://canvas.oregonstate.edu/courses/2031764/pages/exploration-web-application-technology-2?module_item_id=26243419
// Type: Starter code / application
// Author: Oregon State University and Dr. Michael Curry
// */


// Get an instance of mysql we can use in the app
let mysql = require('mysql2')

// Create a 'connection pool' using the provided credentials
const pool = mysql.createPool({
    waitForConnections: true,
    connectionLimit   : 10,
    host              : 'classmysql.engr.oregonstate.edu',
    user              : 'xxxx',
    password          : 'xxxx',
    database          : 'xxxx'
}).promise(); // This makes it so we can use async / await rather than callbacks

// Export it for use in our application
module.exports = pool;

let mysql = require('mysql2')


