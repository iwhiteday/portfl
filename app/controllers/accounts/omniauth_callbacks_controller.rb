class Accounts::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @account = Account.from_omniauth(request.env["omniauth.auth"])

    if @account.persisted?
      sign_in @account
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      if @account.password.blank?
        redirect_to edit_account_path(@account)
      else
        redirect_to '/'
      end
    end
  end
end