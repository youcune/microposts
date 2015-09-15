class UsersController < ApplicationController
  
  def show
   @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def edit
   @user = User.find(params[:id])  
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(profile_params)
      redirect_to root_path , notice: 'プロフィールを編集しました'
    else
      render 'edit'
    end
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def profile_params
    params.require(:user).permit(:name, :email, :description, :location)
  end
end