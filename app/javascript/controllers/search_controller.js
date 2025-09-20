// app/javascript/controllers/search_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]
  connect() {
    this.timer = null
    this.inputTarget.addEventListener("input", () => {
      clearTimeout(this.timer)
      this.timer = setTimeout(() => this.element.submit(), 400)
    })
  }
  disconnect() {
    clearTimeout(this.timer)
  }
}
