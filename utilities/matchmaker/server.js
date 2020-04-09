const express = require('express');
const app = express();
const port = 3000;

const qController = require('./controllers/QueueController')

app.get('/queue', (req, res) => res.send('There are currently ' + qController.getCount() + ' players matchmaking.'));
app.post('/queue', (req, res) => res.send('Should add player to the queue'));

app.listen(port, () => console.log(`Example app listening at http://localhost:${port}`));
