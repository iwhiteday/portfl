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
    puts account_params
    @account.user = User.new

    if @account.save
      sign_in @account
      render json: { account: @account.to_json, msg: 'Account successfully created', redirect_to: @account.user }
    else
      render json: { errors: @account.errors, msg: @account.errors.full_messages.join(', ')}, status: 422
    end
  end

  def edit
    if current_account.id != params[:id].to_i
      redirect_to '/'
    end
  end

  def show
    @account = Account.find(params[:id])
    respond_to do |format|
      format.html {
        redirect_to @account.user
      }
      format.json {
        if current_account == @account || current_account&.user.role.title == 'admin'
          render json: @account
        else
          render json: {}, status: 401
        end
      }
    end
  end

  def update
    if current_account.valid_password?(params[:oldPassword])
      puts 'password correct'
      if current_account.update(password: params[:newPassword])
        render json: {}, status: 200
      else
        render json: {msg: current_account.errors.full_messages.join(', ')}, status: 500
      end
    else
      render json: {msg: 'Old password doesn\'t correct'}, status: 401
    end
  end

  def destroy
    sign_out
    redirect_to '/'
  end

  private

  def account_params
    params.require(:account).permit(:email, :password, :uid, :provider)
  end
end
