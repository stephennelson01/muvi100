import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { nextUrl: String }
  static targets = ["sentinel"]

  connect() {
    if (!("IntersectionObserver" in window)) return
    this.observer = new IntersectionObserver(entries => {
      entries.forEach(e => { if (e.isIntersecting) this.loadMore() })
    })
    if (this.hasSentinelTarget) this.observer.observe(this.sentinelTarget)
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
  }

  async loadMore() {
    if (!this.nextUrlValue) return
    const url = this.nextUrlValue
    this.nextUrlValue = "" // prevent double fetch

    const res = await fetch(url, { headers: { "X-Requested-With": "XMLHttpRequest" } })
    const html = await res.text()

    const temp = document.createElement("div")
    temp.innerHTML = html

    const cards = temp.querySelectorAll("[data-card]")
    cards.forEach(c => this.element.appendChild(c))

    const newNext = temp.querySelector("[data-next-url]")?.dataset.nextUrl
    if (newNext) {
      this.nextUrlValue = newNext
    } else if (this.hasSentinelTarget) {
      this.sentinelTarget.remove()
    }
  }
}
