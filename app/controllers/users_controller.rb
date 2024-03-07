# app/controllers/users_controller.rb
class UsersController < ApplicationController
    def new
      @user = User.new
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        # Redirect to a success page or any other desired action after successful sign-up
        redirect_to root_path, notice: 'User was successfully created.'
      else
        # If there are validation errors, render the sign-up form again with error messages
        render :new
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
  