class AccountsController < ApplicationController
  def new
    @account = Account.new
    respond_to do |format|
      format.html
      format.json {
        render json: @account
      }
    end
  end

  def create
    @account = Account.new(account_params)
    @account.user = User.new

    if @account.save
      sign_in @account
      render json: { account: @account.to_json, msg: 'Account successfully created', redirect_to: @account.user }
    else
      render json: { errors: @account.errors, msg: @account.errors.full_messages.join(', ')}, status: 422
    end
  end

  def edit
  end

  def show
    @account = Account.find(params[:id])
    respond_to do |format|
      format.html {
        redirect_to @account.user
      }
      format.json {
        render json: @account
      }
    end
  end

  def update
    current_account.email ||= account_params[:email]
    current_account.password = account_params[:password]
    if current_account.save
      render json: {}, status: 200
    else
      render json: {}, status: 500
    end
  end

  def destroy
    sign_out
    redirect_to '/'
  end

  private

  def account_params
    params.require(:account).permit(:email, :password)
  end
end
