import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["track"]
  static values  = { interval: Number }

  connect() {
    this.index = 0
    this.count = this.trackTarget.children.length
    this.start()
  }

  disconnect() { this.stop() }

  start() {
    this.stop()
    const ms = this.intervalValue || 5000
    this.timer = setInterval(() => this.next(), ms)
  }
  stop()  { if (this.timer) clearInterval(this.timer) }

  next() { this.go(this.index + 1) }
  prev() { this.go(this.index - 1) }

  go(i) {
    if (!this.count) return
    this.index = (i + this.count) % this.count
    const x = -this.index * this.element.clientWidth
    this.trackTarget.style.transform = `translateX(${x}px)`
  }
}
