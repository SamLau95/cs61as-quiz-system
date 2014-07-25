# Controller for users
class UsersController < ApplicationController
  load_and_authorize_resource
  
  def edit
    user = User.find params[:id]
    @edit_form = EditUserForm.new user
  end

  def update
    user = User.find params[:id]
    @edit_form = EditUserForm.new user
    if @edit_form.validate_and_save params[:user]
      user.update_with_password(user_params)
      user.update_attributes(user_params)
      if user.has_info?
        flash[:success] = 'Updated profile!'
        user.update_attribute(:added_info, true)
      end
      sign_in(user, bypass: true)
      redirect_to after_sign_in_path_for(user)
    else
      flash[:error] = "You're missing some fields!"
      render 'edit'
    end
  end

  private

  def user_params
    params.required(:user).permit!
  end
end
