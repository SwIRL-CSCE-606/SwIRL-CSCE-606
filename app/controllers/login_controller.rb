# frozen_string_literal: true

class LoginController < ApplicationController
  def new
    # This is the action that will render the login form
  end

  def create
    email = params[:email]
    password = params[:password]

    # Fetch user from the database based on the email
    user = User.find_by(email:)

    if user&.authenticate(password)
      logger.debug 'Login successful'
      redirect_to '/static_pages/home' # Redirect to your desired page
    else
      render 'new' # Redirect to login page or show error message
    end
  end

  def login
    if params[:commit] == 'Continue without signing in'
      session[:user_email] = 'Not Signed In'
      redirect_to home_path # Redirect to dashboard without logging in
    else
      @user = User.find_by(email: params[:email])
      if @user && @user.authenticate(params[:password])
        session[:user_email] = @user.email
        redirect_to home_path # Redirect to dashboard after successful login

      else
        flash.now[:error] = 'Invalid email or password'
        render 'new' # Render the login page again with an error message
      end
    end
  end    

  def logout
    reset_session  # Clear the session to ensure user is logged out
    redirect_to signin_path, notice: 'You have been successfully logged out.'  # Redirect to login page with a notice
  end
end

  

