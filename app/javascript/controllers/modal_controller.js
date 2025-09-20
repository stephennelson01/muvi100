// app/javascript/controllers/modal_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "signInFrame", "signUpFrame", "signInTab", "signUpTab"]

  openSignIn() { this.show("signIn") }
  openSignUp() { this.show("signUp") }
  showSignIn() { this.show("signIn") }
  showSignUp() { this.show("signUp") }

  close() {
    if (this.hasContainerTarget) this.containerTarget.classList.add("hidden")
  }

  show(which) {
    if (!this.hasContainerTarget) return
    this.containerTarget.classList.remove("hidden")

    const isIn = which === "signIn"
    if (this.hasSignInFrameTarget) this.signInFrameTarget.classList.toggle("hidden", !isIn)
    if (this.hasSignUpFrameTarget) this.signUpFrameTarget.classList.toggle("hidden", isIn)

    if (this.hasSignInTabTarget) this.signInTabTarget.classList.toggle("text-white", isIn)
    if (this.hasSignUpTabTarget) this.signUpTabTarget.classList.toggle("text-white", !isIn)
  }
}
