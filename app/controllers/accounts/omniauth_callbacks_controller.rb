class Accounts::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    login('Facebook')
  end

  def vkontakte
    login('Vkontakte')
  end

  def twitter
    login('Twitter')
  end

  private

  def login(kind)
    @account = Account.from_omniauth(request.env["omniauth.auth"])

    if @account.persisted?
      sign_in @account
      set_flash_message(:notice, :success, :kind => kind) if is_navigational_format?
      if @account.password.blank?
        redirect_to edit_account_path(@account)
      else
        redirect_to '/'
      end
    end
  end
end