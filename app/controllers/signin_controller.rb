class SigninController < ApplicationController
    def new
      # Render the login form
    end
  
    def create
      email = params[:email]
      password = params[:password]
  
      # Fetch user from the database based on the email
      user = User.find_by(email: email)
  
      if user && user.password == password
        logger.debug "Login successful"
        redirect_to '/static_pages/home' # Redirect to home page
      else
        redirect_to '/signin' # Redirect to login page or show error message
      end
    end
  end
  