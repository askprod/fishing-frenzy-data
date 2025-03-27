import consumer from "channels/consumer"

consumer.subscriptions.create("StatusCheckerChannel", {
  connected() {
    console.log("Connected to status_checker_channel")
  },

  disconnected() {
    console.log("Disconnected from status_checker_channel")
  },

  received(data) {
    let status = data.status
    let statusLabel = document.getElementById("server-status-label");

    Array.from(statusLabel.classList).forEach(className => {
      if (className.startsWith('bg-')) {
        statusLabel.classList.remove(className);
      }
    });

    statusLabel.classList.add(this.getStatusDetails(status));
  },

  getStatusDetails(status) {
    const colorsMapping = { up: "bg-green-500", maintenance: "bg-yellow-200", error: "bg-red-500" };
    return colorsMapping[status] || "bg-gray-500";
  }
});
