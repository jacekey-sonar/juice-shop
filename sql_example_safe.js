// This is a SAFE and SECURE way to handle user input
const username = req.body.username; // Let's say this is 'admin' --
const password = req.body.password;

const sqlQuery = 'SELECT * FROM users WHERE username = ? AND password = ?';

db.query(sqlQuery, [username, password], (err, results) => {
  // The database treats 'admin' -- as a literal string value,
  // not as executable SQL code.
  if (err) throw err;
  console.log(results);
});
