// app/javascript/controllers/infinite_scroll_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sentinel"]

  connect() {
    if (!("IntersectionObserver" in window) || !this.hasSentinelTarget) return
    this.observer = new IntersectionObserver(entries => {
      entries.forEach(e => {
        if (e.isIntersecting) this.loadMore()
      })
    }, { rootMargin: "1200px 0px" })
    this.observer.observe(this.sentinelTarget)
    this.loading = false
  }

  disconnect() {
    if (this.observer && this.hasSentinelTarget) this.observer.unobserve(this.sentinelTarget)
  }

  async loadMore() {
    if (this.loading) return
    const url = this.element.dataset.nextUrl
    if (!url) return
    this.loading = true
    try {
      const res = await fetch(url, { headers: { "Accept": "text/vnd.turbo-stream.html" }})
      if (res.ok) {
        const html = await res.text()
        Turbo.renderStreamMessage(html)
      }
    } finally {
      this.loading = false
    }
  }
}
