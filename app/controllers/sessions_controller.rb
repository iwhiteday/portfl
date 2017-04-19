class SessionsController < ApplicationController
  def new
  end

  def create
    account_params = params.require(:account).permit(:email, :password)
    @account = Account.find_by(account_params)
    if @account
      sign_in @account
      render json: {}, status: 200
    else
      render json: {msg: 'Authentication failed'}, status: 500
    end
  end

  def delete
    sign_out
    redirect_to '/'
  end
end
