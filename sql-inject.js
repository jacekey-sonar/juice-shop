app.post('/login', (req, res) => {

  const { username, password } = req.body;

  const query = `SELECT * FROM users WHERE username = '${username}' AND password = '${password}'`;

  connection.query(query, (err, results) => {

    if (err) throw err;

    if (results.length > 0) {

      res.json({ success: true, user: results[0] });

    } else {

      res.status(401).json({ success: false, message: 'Invalid credentials' });

    }

  });

});
