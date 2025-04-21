import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  static values = { name: String, json: String }

  connect() {
    this.params = this.jsonValue ? JSON.parse(this.jsonValue) : {}
    this.channelClass = `${this.nameValue.charAt(0).toUpperCase()}${this.nameValue.slice(1)}Channel`
    this.subscriptionParams = { channel: this.channelClass, ...this.params }

    this.subscription = consumer.subscriptions.create(this.subscriptionParams, {
      connected: this._connected.bind(this),
      disconnected: this._disconnected.bind(this),
      received: this._received.bind(this),
    })
  }

  disconnect() {
    if (this.subscription) {
      consumer.subscriptions.remove(this.subscription)
    }
  }

  _connected() {}
  _disconnected() {}
  _received(data) {}
}
