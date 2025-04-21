import ChannelSubscriptionController from "controllers/channel_subscription_controller"
import Loader from "loader"; // Import the Loader class

export default class extends ChannelSubscriptionController {
  _connected() {
    this.player_id = this.params.player_id;
    this.cardContainer = document.getElementById(`${this.player_id}-container`);
    this.cardGrids = document.getElementById(`${this.player_id}-grids`);
    this.loader = new Loader(this.cardContainer)
  }

  _received(data) {
    if(data.type == "refresh_card_request") {
      this.requestedCardRefresh()
    }

    if(data.type == "refresh_card_success") {
      this.successCardRefresh()
    }

    if(data.type == "refresh_card_failed") {
      this.failedCardRefresh()
    }
  }

  requestedCardRefresh() {
    this.loader.show();
  }

  successCardRefresh() {
    fetch(`/players/${this.player_id}/stats-grid`)
      .then((response) => response.text())
      .then((html) => {
        this.cardGrids.innerHTML = html;
        this.loader.hide();
      })
  }

  failedCardRefresh() {

  }
}
