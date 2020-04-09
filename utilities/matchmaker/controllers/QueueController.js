class QueueController {
  constructor() {
    this.queue = [];

    setInterval(() => {
      this.queue.length >= 2 ? this.startAvailableMatches() : null;
    }, 3000);
  }

  getCount() {
    return this.queue.length;
  }

  addPlayerToQueue(player) {
    console.log('adding player ', player, ' to the queue');
    this.queue.push(player);
  }

  removePlayerFromQueue(player) {
    console.log('removing player ', player, ' from the queue');
    var index = this.queue.find(player);
    if (index != -1) this.queue.splice(index, 1);
  }

  startAvailableMatches() {
    if (this.queue.length >= 2) {
      console.log('starting all available matches');
      this.queue.forEach((player, index) => {
        // pair up players and send them the info they need
      });
    } else {
      console.log('not enough players to start a match');
    }
  }
}

module.exports = QueueController
