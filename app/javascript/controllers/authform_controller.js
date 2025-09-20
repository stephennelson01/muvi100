// app/javascript/controllers/authform_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { mode: String }

  connect() {
    // Render compact HTML for sign in/up (no server round-trip)
    this.element.innerHTML = this[this.modeValue === "signup" ? "signupHtml" : "signinHtml"]()
  }

  signinHtml() {
    return `
      <div class="auth-card">
        <h2>Sign in</h2>
        <form action="/users/sign_in" method="post">
          <input type="hidden" name="authenticity_token" value="${this.csrf()}" />
          <label class="auth-label" for="user_email">Email</label>
          <input class="auth-input" type="email" name="user[email]" id="user_email" autocomplete="email" required />

          <label class="auth-label mt-3" for="user_password">Password</label>
          <input class="auth-input" type="password" name="user[password]" id="user_password" autocomplete="current-password" required />

          <button class="btn btn-red mt-4" type="submit">Sign in</button>
        </form>

        <div class="divider"><span>or</span></div>
        ${this.oauthHtml()}
        <p class="auth-foot">No account? <a href="#" data-action="click->modal#showSignUp">Sign up</a></p>
      </div>
    `
  }

  signupHtml() {
    return `
      <div class="auth-card">
        <h2>Create account</h2>
        <form action="/users" method="post">
          <input type="hidden" name="authenticity_token" value="${this.csrf()}" />
          <label class="auth-label" for="reg_email">Email</label>
          <input class="auth-input" type="email" name="user[email]" id="reg_email" autocomplete="email" required />

          <label class="auth-label mt-3" for="reg_password">Password</label>
          <input class="auth-input" type="password" name="user[password]" id="reg_password" autocomplete="new-password" required />

          <label class="auth-label mt-3" for="reg_password_confirmation">Confirm password</label>
          <input class="auth-input" type="password" name="user[password_confirmation]" id="reg_password_confirmation" autocomplete="new-password" required />

          <button class="btn btn-red mt-4" type="submit">Create account</button>
        </form>

        <div class="divider"><span>or</span></div>
        ${this.oauthHtml()}
        <p class="auth-foot">Already have an account? <a href="#" data-action="click->modal#showSignIn">Sign in</a></p>
      </div>
    `
  }

  oauthHtml() {
    // Inline minimal Google button linking to Devise OmniAuth
    return `
      <a class="btn btn-white" href="/users/auth/google_oauth2">
        <svg class="google-icon" viewBox="0 0 48 48"><path fill="#FFC107" d="M43.611,20.083H42V20H24v8h11.303C33.186,31.987,29.028,35,24,35c-6.075,0-11-4.925-11-11 s4.925-11,11-11c2.802,0,5.357,1.055,7.3,2.789l5.657-5.657C33.907,7.14,29.211,5,24,5C12.955,5,4,13.955,4,25 s8.955,20,20,20s20-8.955,20-20C44,23.659,43.862,21.832,43.611,20.083z"/><path fill="#FF3D00" d="M6.306,14.691l6.571,4.817C14.294,16.361,18.824,13,24,13c2.802,0,5.357,1.055,7.3,2.789l5.657-5.657 C33.907,7.14,29.211,5,24,5C16.318,5,9.716,9.44,6.306,14.691z"/><path fill="#4CAF50" d="M24,45c5.005,0,9.646-1.917,13.172-5.045l-6.074-4.981C28.943,36.75,26.595,37.5,24,37.5 c-4.979,0-9.192-3.174-10.701-7.594l-6.535,5.035C9.094,41.137,16.001,45,24,45z"/><path fill="#1976D2" d="M43.611,20.083H42V20H24v8h11.303c-1.203,3.507-4.15,6.162-7.631,7.004l6.074,4.981 C35.367,39.856,44,33.5,44,25C44,23.659,43.862,21.832,43.611,20.083z"/></svg>
        Continue with Google
      </a>
    `
  }

  csrf() {
    const el = document.querySelector("meta[name='csrf-token']")
    return el ? el.content : ""
  }
}
