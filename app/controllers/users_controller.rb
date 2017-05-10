class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]


  # GET /users
  # GET /users.json
  def index
    if current_account == nil
      redirect_to root_path
    elsif current_account.user.role.title == 'admin'
      respond_to do |format|
        format.html
        format.json {
          @users = User.all
          render json: @users
        }
      end
    else
      redirect_to current_account.user
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      format.html
      format.json {
        render json: @user
      }
    end
  end

  # GET /users/new
  def new
    @user = User.new
    render json: @user
  end

  # GET /users/1/edit
  def edit
    respond_to do |format|
      format.html
      format.json {
        render json: @user
      }
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    local_params = user_params
    @user.update_preferences(params[:user][:preferences])
    if local_params[:sex].to_i > 0
      local_params[:sex] = User.get_sex_value_by_key(local_params[:sex].to_i)
    else
      local_params.delete(:sex)
    end

    if @user.update(local_params)
      render json: { user: @user, msg: 'User successfully updated', redirect_to: 'user_path' }
    else
      render json: { errors: @user.errors, msg: @user.errors.full_messages.join(', ')}, status: 422
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if current_account.user.role.name == 'admin'
      @user.destroy
      render json: {msg: 'User deleted'}
    else
      render json: {msg: 'Unauthorized'}, status: 401
    end
  end

  def search
    respond_to do |format|
      format.html
      format.json {
        @users = User.search(params[:query])
        render json: @users
      }
    end
  end

  def filter
    @users = User.filter(params[:query], params[:searchOptions])
    render json: @users
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :avatar_id, :birth, :weight, :height, :sex, :preferences)
    end
end
