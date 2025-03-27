import consumer from "channels/consumer"

consumer.subscriptions.create("StatusCheckerChannel", {
  connected() {
    console.log("Connected to status_checker_channel")
  },

  disconnected() {
    console.log("Disconnected from status_checker_channel")
  },

  received(data) {
    let responseStatus = data.status
    let statusLabel = document.getElementById("server-status-label");
    let tooltip = document.getElementById("server-status-tooltip");
    let statusDetails = this.getStatusDetails(responseStatus);

    Array.from(statusLabel.classList).forEach(className => {
      if (className.startsWith('bg-')) {
        statusLabel.classList.remove(className);
      }
    });

    Array.from(tooltip.classList).forEach(className => {
      if (className.startsWith('bg-')) {
        tooltip.classList.remove(className);
      }
    });

    statusLabel.classList.add(statusDetails.color);
    tooltip.classList.add(statusDetails.color);
    tooltip.textContent = statusDetails.label;
  },

  getStatusDetails(status) {
    const defaults = { label: "UNKNOWN", color: "bg-gray-500" };
    const colorsMapping = { 
      up: { label: "UP", color: "bg-green-500" }, 
      maintenance: { label: "MAINTENANCE", color: "bg-amber-200" }, 
      error: { label: "ERROR", color: "bg-red-500" }
    };
    
    return colorsMapping[status] || defaults;
  }
});
