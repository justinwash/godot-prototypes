const express = require('express');
const app = express();
const port = 3000;

import QueueController from './controllers/QueueController';
const qController = new QueueController();

qController.startTimer();

app.get('/queue', (req, res) => res.json('There are currently ' + qController.getCount() + ' players matchmaking.'));

app.post('/queue', (req, res) => {
  var result = qController.addPlayerToQueue(req, res);
});

app.delete('/queue', (req, res) => {
  var result = qController.removePlayerFromQueue(req, res);
});

app.listen(port, () => console.log(`Example app listening at http://localhost:${port}`));
