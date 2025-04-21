// TODO: use base channel like javascripts/controller/player_channel_controller
import consumer from "channels/consumer"

consumer.subscriptions.create("StatusCheckerChannel", {
  connected() {},

  disconnected() {},

  received(data) {
    let responseStatus = data.status
    let statusLabel = document.getElementById("server-status-label");
    let tooltipLabel = document.getElementById("server-status-tooltip");
    let tooltipText = document.getElementById("status");
    let statusDetails = this.getStatusDetails(responseStatus);

    Array.from(statusLabel.classList).forEach(className => {
      if (className.startsWith('bg-')) {
        statusLabel.classList.remove(className);
      }
    });

    Array.from(tooltipLabel.classList).forEach(className => {
      if (className.startsWith('bg-')) {
        tooltipLabel.classList.remove(className);
      }
    });

    tooltipLabel.classList.add(statusDetails.color);
    statusLabel.classList.add(statusDetails.color);
    tooltipText.textContent = statusDetails.label;
  },

  getStatusDetails(status) {
    const defaults = { label: "UNKNOWN", color: "bg-gray-500" };
    const colorsMapping = { 
      up: { label: "UP", color: "bg-green-500" }, 
      unavailable: { label: "UNAVAILABLE", color: "bg-amber-500" }, 
      error: { label: "ERROR", color: "bg-red-500" }
    };
    
    return colorsMapping[status] || defaults;
  }
});
