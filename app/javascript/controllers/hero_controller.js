import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide"]
  static values = { index: Number }

  connect() {
    this.indexValue = 0
    this.showSlide(this.indexValue)
  }

  next() {
    this.indexValue = (this.indexValue + 1) % this.slideTargets.length
    this.showSlide(this.indexValue)
  }

  prev() {
    this.indexValue =
      (this.indexValue - 1 + this.slideTargets.length) % this.slideTargets.length
    this.showSlide(this.indexValue)
  }

  showSlide(index) {
    this.slideTargets.forEach((el, i) => {
      el.style.opacity = i === index ? "1" : "0"
      el.style.zIndex = i === index ? "1" : "0"
      el.style.transition = "opacity 0.7s ease-in-out"
    })
  }
}
