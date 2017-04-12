class Accounts::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @account = Account.from_omniauth(request.env["omniauth.auth"])
    redirect_to account_new_path
  end
end