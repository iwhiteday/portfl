class AccountsController < ApplicationController
  def new
    @account = Account.new
  end

  def create
  end

  def edit
  end

  def show
    user = Account.find(params[:id]).user
    redirect_to user
  end

  def update
    current_account.password = params[:account][:password]
    if current_account.save
      redirect_to current_account.user
    else
      render edit
    end
  end

  def destroy
    sign_out
    redirect_to '/'
  end
end
