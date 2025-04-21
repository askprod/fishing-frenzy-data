import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]

  connect() {
    this.element.addEventListener("flash:added", () => this.showFlashMessages())
  }

  showFlashMessages() {
    this.messageTargets.forEach((message) => {
      setTimeout(() => this.slideUp(message), 200)
    })
  }

  slideUp(message) {
    message.classList.add("opacity-100", "translate-y-0")

    setTimeout(() => {
      this.slideDown(message)
    }, 5000)
  }

  slideDown(message) {
    message.classList.remove("opacity-100")
    setTimeout(() => {
      message.remove()
    }, 500)
  }
}
