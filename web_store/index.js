const express = require('express');

const app = express();

app.use(express.static('static'))

app.get('/', (req, res)  => {
    res.redirect("/index.html")
});

app.listen(3000, () => {
    console.log('Server is running on port 3000');
});