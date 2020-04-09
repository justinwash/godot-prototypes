const express = require('express');
const app = express();
const port = 3000;

import QueueController from './controllers/QueueController';
const qController = new QueueController();

app.get('/queue', (req, res) => res.json('There are currently ' + qController.getCount() + ' players matchmaking.'));

app.post('/queue', (req, res) => {
  var player = {
    address: req.headers['x-forwarded-for'] || req.connection.remoteAddress,
  };
  var result = qController.addPlayerToQueue(player);
  if (result == 'success') {
    res.json('Added player at ' + player.address + ' to the queue.');
  } else {
    res.json('player at ' + player.address + ' already in queue. (or a scary error happened)');
  }
});

app.delete('/queue', (req, res) => {
  var player = {
    address: req.headers['x-forwarded-for'] || req.connection.remoteAddress,
  };
  var result = qController.removePlayerFromQueue(player);
  if (result == 'success') {
    res.json('Removed player at ' + player.address + ' from the queue.');
  } else {
    res.json('player at ' + player.address + ' not in queue. (or a scary error happened)');
  }
});

app.listen(port, () => console.log(`Example app listening at http://localhost:${port}`));
