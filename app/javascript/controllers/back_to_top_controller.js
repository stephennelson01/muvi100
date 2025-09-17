import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["button"]
  connect() {
    this.onScroll = () => {
      if (window.scrollY > 600) this.buttonTarget.classList.remove("hidden")
      else this.buttonTarget.classList.add("hidden")
    }
    window.addEventListener("scroll", this.onScroll)
  }
  disconnect() { window.removeEventListener("scroll", this.onScroll) }
  scroll() { window.scrollTo({ top: 0, behavior: "smooth" }) }
}
