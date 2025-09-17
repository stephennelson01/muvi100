class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in_and_redirect @user, event: :authentication
  rescue => e
    redirect_to root_path, alert: "Google sign-in failed."
  end

  def failure
    redirect_to root_path, alert: "Google sign-in failed."
  end
end
