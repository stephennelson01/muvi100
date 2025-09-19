import { Controller } from "@hotwired/stimulus"

// Handles opening/closing and swapping modal content
export default class extends Controller {
  static targets = ["overlay", "frame", "title"]

  static values = { content: String }

  open(event) {
    event.preventDefault()
    this.overlayTarget.classList.remove("hidden")
    this.swap()
  }

  close(event) {
    event.preventDefault()
    this.overlayTarget.classList.add("hidden")
  }

  swap(event) {
    let type = event?.target?.dataset?.modalContentValue || this.contentValue || "signup"
    if (type === "signin") {
      this.titleTarget.innerText = "Sign In"
      this.frameTarget.src = "/users/sign_in"
    } else {
      this.titleTarget.innerText = "Sign Up"
      this.frameTarget.src = "/users/sign_up"
    }
  }
}
