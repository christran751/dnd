const cells = document.querySelectorAll('td[data-field="hitPointChange"]');
for (const cell of cells) {
  const value = parseInt(cell.textContent.trim(), 10);
  cell.style.color = value < 0 ? "red" : "green";
}

// The EDIT BUTTON

// Original Work
document.querySelectorAll('.edit_button').forEach(btn => {
  btn.addEventListener('click', function () {
    const row = this.closest('tr');

    row.dataset.original = JSON.stringify(
      [...row.querySelectorAll('.editable')].map(td => td.innerText)
// End of Original Work
    );


    /*
    -- Citation for use of AI Tools:
    -- Date: 03/11/2026
    -- Summary of prompts used
    -- Prompt Used: Is there a way to make only the editable rows highlightable?
    -- AI Source URL: https://claude.ai/new
    -- It gave this code template:
              row.querySelectorAll('selector').forEach(element => {
                  element.contentEditable = 'true'
                // code to do something with each element
              });
    */

    // Adapted from the template code provided by Claude AI

    row.querySelectorAll('.editable').forEach(td => {
      td.contentEditable = 'true';
      // can't think of any color.
      td.style.backgroundColor = '#FFEFD5';
      td.style.outline = '2px solid #FF9800';
    });
    // End of Adaption from Claude AI

    this.style.display = 'none';
    row.querySelector('.save_button').style.display = 'inline';   // Change from inline to inline-block as suggested
    row.querySelector('.cancel_button').style.display = 'inline'; // because its lets the button sit next to each other
  });
});


/*
-- Citation for use of AI Tools:
-- Date: 03/11/2026
-- Summary of prompts used
-- Prompt Used: I made my update button inline alongside table row, and add javascript for an Edit,Cancel, and Save button, but I cannot save these changes after clicking 'save'.
-- Can only cancel the attempted update/edit.
-- Anything wrong with my code (copy and paste both my handlebar form and script.js)
-- AI Source URL: https://claude.ai/new
-- From there, it tells me to:
--    Change up my hbs by addting data-field attributes (data-field="name of column") to each rows with the class=editable
--    Update my Save handle in script.js to include the editable fields and the row ID
--    in order to successfully send all updated values to the server so the correct database record can be updated.
--    Change button to be inline-block from inline.
*/


// Save
document.querySelectorAll('.save_button').forEach(btn => {
  btn.addEventListener('click', function () {

    // Start of Original Work
    const row = this.closest('tr');
    const cells = row.querySelectorAll('.editable');
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = this.dataset.update;
    // End of Original Work

     // Adapted from the template code provided by Claude AI
    cells.forEach(td => {
      const input = document.createElement('input');
      input.type = 'hidden';
      input.name = td.dataset.field;
      input.value = td.innerText.trim();
      form.appendChild(input);
    });
    const idFieldName = this.dataset.idfield;
    const idValue = row.querySelector(`input[name="${idFieldName}"]`).value;
    const idInput = document.createElement('input');
    idInput.type = 'hidden';
    idInput.name = idFieldName;
    idInput.value = idValue;
    // End of Adaption from Claude AI

    // Original Work
    form.appendChild(idInput);
    document.body.appendChild(form);
    form.submit();
  });
});

// OLD SAVE
// document.querySelectorAll('.save_button').forEach(btn => {
//   btn.addEventListener('click', function () {
//     const row = this.closest('tr');
//     const cells = row.querySelectorAll('.editable');
//     const form = document.createElement('form');
//     form.method = 'POST';
//     form.action = this.dataset.update;
//     form.appendChild(idInput);
//     document.body.appendChild(form);
//     form.submit();
//   });
// });

// CANCEL BUTTON
document.querySelectorAll('.cancel_button').forEach(btn => {
  btn.addEventListener('click', function () {
    const row = this.closest('tr');
    const original = JSON.parse(row.dataset.original);
    row.querySelectorAll('.editable').forEach((td, i) => {
      td.innerText = original[i];
      td.contentEditable = 'false';
      td.style.backgroundColor = '';
      td.style.outline = '';
    });
    row.querySelector('.edit_button').style.display = 'inline-block';
    row.querySelector('.save_button').style.display = 'none';
    this.style.display = 'none';
  });
});
