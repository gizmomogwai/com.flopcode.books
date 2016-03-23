class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :destroy]
  before_filter :admin_user, except: [:show]
  respond_to :html


  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    check_user {
      respond_with @user
    }
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    check_user {
      respond_with @user
    }
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notive: 'User was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    @user = User.find(params[:id])
    check_user {
      if @user.update(user_params)
        redirect_to @user, notice: 'User was successfully updated.'
      else
        render :edit
      end
    }
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.' 
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :account)
  end
end
