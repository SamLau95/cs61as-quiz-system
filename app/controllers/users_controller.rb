# Controller for users
class UsersController < ApplicationController
  load_and_authorize_resource

  def edit
  end

  def update
    if @user.update_with_password user_params
      flash[:success] = 'Updated profile!'
      redirect_to after_sign_in_path_for @user
    else
      flash[:error] = "You're missing some fields!"
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password,
                                 :password_confirmation, :current_password)
  end
end
