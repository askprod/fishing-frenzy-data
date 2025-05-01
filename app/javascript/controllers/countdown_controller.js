import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["days", "hours", "minutes", "seconds", "secondsWrapper"]
  static values = {
    targetTime: String
  }

  connect() {
    this.targetDate = new Date(this.targetTimeValue)
    this.update()
    this.interval = setInterval(() => this.update(), 1000)
  }

  disconnect() {
    clearInterval(this.interval)
  }

  update() {
    const now = new Date()
    const diff = this.targetDate - now

    if (diff <= 0) {
      this.daysTarget.textContent = "00"
      this.hoursTarget.textContent = "00"
      this.minutesTarget.textContent = "00"
      this.secondsTarget.textContent = "00"
      clearInterval(this.interval)
      return
    }

    const totalSeconds = Math.floor(diff / 1000)
    const seconds = totalSeconds % 60
    const minutes = Math.floor((totalSeconds / 60) % 60)
    const hours = Math.floor((totalSeconds / 3600) % 24)
    const days = Math.floor(totalSeconds / 86400)

    this.daysTarget.textContent = String(days).padStart(2, '0')
    this.hoursTarget.textContent = String(hours).padStart(2, '0')
    this.minutesTarget.textContent = String(minutes).padStart(2, '0')

    if (this.secondsTarget.textContent !== String(seconds).padStart(2, '0')) {
      this.animateSeconds(seconds)
    }
  }

  animateSeconds(seconds) {
    this.secondsWrapperTarget.classList.remove("translate-y-0", "opacity-100")
    this.secondsWrapperTarget.classList.add("-translate-y-5", "opacity-0")
  
    setTimeout(() => {
      this.secondsTarget.textContent = String(seconds).padStart(2, '0')
  
      this.secondsWrapperTarget.classList.remove("-translate-y-5", "opacity-0")
      this.secondsWrapperTarget.classList.add("translate-y-5", "opacity-100")
  
      setTimeout(() => {
        this.secondsWrapperTarget.classList.remove("translate-y-5")
        this.secondsWrapperTarget.classList.add("translate-y-0")
      }, 100)
    }, 200)
  }
}
