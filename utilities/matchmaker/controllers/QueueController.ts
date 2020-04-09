import Player from '../models/Player';
import { v4 as uuid } from 'uuid';
import axios from 'axios';
const WebSocket = require('ws');

export default class QueueController {
  queue: any[] = [];

  startTimer() {
    setInterval(() => {
      this.queue.length >= 2 ? this.startAvailableMatches() : null;
    }, 3000);
  }

  getCount() {
    return this.queue.length;
  }

  addPlayerToQueue(req, res) {
    var player: Player = {
      id: uuid(),
      address: req.headers['x-forwarded-for'] || req.connection.remoteAddress,
      host: false,
    };

    if (this.queue.length >= 0) {
      var isInQueue =
        this.queue.find((p) => {
          return p.address == player.address;
        }) == undefined
          ? false
          : true;
    } else {
      isInQueue = false;
    }

    if (isInQueue) {
      console.log('player already queued.');
      res.json({
        message: 'Player already in queue.',
        player: player,
      });
    } else {
      console.log('adding player ' + player.id + ' to the queue.');
      this.queue.push(player);
      res.json({
        message: 'Added player to the queue.',
        player: player,
      });
    }
  }

  removePlayerFromQueue(req, res) {
    let address = req.headers['x-forwarded-for'] || req.connection.remoteAddress;

    let index = this.queue.findIndex((p) => {
      return p.address == address;
    });
    let isInQueue = index != -1;

    if (isInQueue) {
      let player = this.queue[index];
      console.log('removing player ' + player.id + ' from queue.');
      this.queue.splice(index, 1);
      res.json({
        message: 'Removed player ' + player.id + ' from the queue.',
        player: player,
      });
    } else {
      console.log('player with address ' + address + ' not in queue.');
      res.json('player with address ' + address + ' not in queue.');
    }
  }

  startAvailableMatches() {
    try {
      if (this.queue.length >= 2) {
        console.log('starting all available matches');
        this.queue.forEach((player, index) => {
          player.host = true;
          let player2 = this.queue[index + 1];

          const p1ws = new WebSocket(`ws://[${player.address}]:1414`);

          p1ws.on('open', function open() {
            p1ws.send(
              JSON.stringify({
                message: 'start the game',
                data: {
                  player: player,
                  opponent: player2,
                },
              })
            );
          });

          this.queue.splice(index, 2);
        });
      } else {
        console.log('not enough players to start a match');
        return 'fail';
      }
    } catch (err) {
      console.log('error starting matches', err);
    }
  }
}
