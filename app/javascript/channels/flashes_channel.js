// TODO: use base channel like javascripts/controller/player_channel_controller
import consumer from "channels/consumer"

consumer.subscriptions.create(
  { channel: "FlashesChannel", session_id: js_utils.session_id }, {
    
  connected() {},

  disconnected() {},

  received(data) {
    const { type, message } = data
  
    fetch(`/flashes?flash_type=${encodeURIComponent(type)}&flash_message=${encodeURIComponent(message)}`)
      .then((response) => response.text())
      .then((html) => {
        const container = document.querySelector("#flash");

        if (container) {
          container.innerHTML = html;
          container.dispatchEvent(new CustomEvent("flash:added"));
        }
      })
  }
});
