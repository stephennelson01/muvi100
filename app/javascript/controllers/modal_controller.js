import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "paneSignIn", "paneSignUp", "tabSignIn", "tabSignUp"]

  connect() {
    this.isOpen = false
  }

  // Openers bound to header buttons
  openSignIn = () => { this.open(); this.showPane("signin") }
  openSignUp = () => { this.open(); this.showPane("signup") }

  // Tab buttons inside modal
  showSignIn = (e) => { e?.preventDefault(); this.showPane("signin") }
  showSignUp  = (e) => { e?.preventDefault(); this.showPane("signup") }

  open() {
    if (this.isOpen) return
    this.overlayTarget.classList.add("!opacity-100", "!pointer-events-auto")
    document.body.classList.add("overflow-hidden")
    this.isOpen = true
  }

  close = (e) => {
    e?.preventDefault()
    this.overlayTarget.classList.remove("!opacity-100", "!pointer-events-auto")
    document.body.classList.remove("overflow-hidden")
    this.isOpen = false
  }

  showPane(which) {
    const signInActive = which === "signin"

    // panes
    this.paneSignInTarget.classList.toggle("hidden", !signInActive)
    this.paneSignUpTarget.classList.toggle("hidden", signInActive)

    // tabs styling
    this.tabSignInTarget.classList.toggle("bg-white/10", signInActive)
    this.tabSignInTarget.classList.toggle("text-white", signInActive)
    this.tabSignInTarget.classList.toggle("text-neutral-200", !signInActive)

    this.tabSignUpTarget.classList.toggle("bg-white/10", !signInActive)
    this.tabSignUpTarget.classList.toggle("text-white", !signInActive)
    this.tabSignUpTarget.classList.toggle("text-neutral-200", signInActive)
  }
}
