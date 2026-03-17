/*
-- Citation 1 for use of AI Tools:
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

/*
-- Citation 2 for use of AI Tools:
-- Date: 03/11/2026
-- Summary of prompts used
-- Prompt Used: I made my update button inline alongside table row, and add javascript for an Edit, Cancel, and Save button, but I cannot save these changes after clicking 'save'.
-- Can only cancel the attempted update/edit.
-- Is there anything wrong with my code (copy and paste both my handlebar form and script.js)
-- AI Source URL: https://claude.ai/new
-- From there, it tells me to:
--    Change up my hbs by adding the data-field attributes (data-field="name of column") to each rows that has the class=editable
--    Update my Save handle in script.js to include the editable fields and the row ID in order to successfully send all updated values to the server so the correct database record can be updated.
--    Reccomend that I change the button to be inline-block instead of inline.
*/


// Make -hp change red, and +hp change green

const healthCells = document.querySelectorAll('td[data-field="hitPointChange"]');

for (let i = 0; i < healthCells.length; i++) {
  const value = parseInt(healthCells[i].textContent.trim());
  if (value < 0) {
    healthCells[i].style.color = "red";
  } else {
    healthCells[i].style.color = "green";
  }
}

const statusCells = document.querySelectorAll('td[data-field="conditionStatus"]');

for (let i = 0; i < statusCells.length; i++) {
  const value = statusCells[i].textContent.trim();
  if (value === 'Healthy') {
    statusCells[i].style.color = 'green';
  } else if (value === 'Buffed') {
    statusCells[i].style.color = 'blue';
  } else if (value === 'Poisoned') {
    statusCells[i].style.color = 'purple';
  } else if (value === 'Stunned') {
    statusCells[i].style.color = 'goldenrod';
  } else if (value === 'Dead') {
    statusCells[i].style.color = 'red';
  }
}



// Original Work
document.querySelectorAll('.edit_button').forEach(btn => {
  btn.addEventListener('click', function () {
    const row = this.closest('tr');

    row.dataset.original = JSON.stringify(
      [...row.querySelectorAll('.editable')].map(td => td.innerText)
// End of Original Work
    );

    // Adapted from the template code provided by Claude AI (see Citation 1)

    row.querySelectorAll('.editable').forEach(td => {
      td.contentEditable = 'true';
      // can't think of any color.
      td.style.backgroundColor = '#FFF8E1';
      td.style.outline = '2px solid #8B6914';
    });
    // End  Claude 1

    this.style.display = 'none';
    row.querySelector('.save_button').style.display = 'inline';   // Change from inline to inline-block as suggested
    row.querySelector('.cancel_button').style.display = 'inline'; // because its lets the button sit next to each other
  });
});

// Save (see citation # 2)
document.querySelectorAll('.save_button').forEach(btn => {
  btn.addEventListener('click', function () {

    // Start of Original Work
    const row = this.closest('tr');
    const cells = row.querySelectorAll('.editable');
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = this.dataset.update;
    // End of Original Work

     // Adapted from the template code provided by Claude AI (Citation 2)_
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
    // End (Citation 2)

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








