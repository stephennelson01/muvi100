import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { endpoint: String, page: Number }
  static targets = ["container", "spinner"]

  connect() {
    this.onScroll = this.loadMore.bind(this)
    window.addEventListener("scroll", this.onScroll)
    this.loading = false
  }
  disconnect() { window.removeEventListener("scroll", this.onScroll) }

  async loadMore() {
    if (this.loading) return
    const nearBottom = window.innerHeight + window.scrollY >= document.body.offsetHeight - 400
    if (!nearBottom) return
    this.loading = true
    this.spinnerTarget.classList.remove("hidden")
    try {
      const next = this.pageValue + 1
      const url = new URL(window.location.href)
      url.searchParams.set("page", next)
      const res = await fetch(url, { headers: { "Turbo-Frame": "false" } })
      const html = await res.text()
      const parser = new DOMParser().parseFromString(html, "text/html")
      const newCards = parser.querySelectorAll("[data-infinite-scroll-target='container'] > *")
      newCards.forEach(el => this.containerTarget.appendChild(el))
      this.pageValue = next
    } catch (e) { console.error(e) }
    finally {
      this.spinnerTarget.classList.add("hidden")
      this.loading = false
    }
  }
}
