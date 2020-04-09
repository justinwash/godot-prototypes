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

  addPlayerToQueue(player) {
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
      return 'fail';
    } else {
      console.log('adding player at ' + player.address + ' to the queue');
      this.queue.push(player);
      return 'success';
    }
  }

  removePlayerFromQueue(player) {
    var index = this.queue.findIndex((p) => {
      return p.address == player.address;
    });
    var isInQueue = index != -1;

    if (isInQueue) {
      console.log('removing player at ' + player.address + ' from queue');
      this.queue.splice(index, 1);
      return 'success';
    } else {
      console.log('player at ' + player.address + ' not in queue');
      return 'fail';
    }
  }

  startAvailableMatches() {
    if (this.queue.length >= 2) {
      console.log('starting all available matches');
      this.queue.forEach((player, index) => {
        // pair up players and send them the info they need
        return 'success';
      });
    } else {
      console.log('not enough players to start a match');
      return 'fail';
    }
  }
}
