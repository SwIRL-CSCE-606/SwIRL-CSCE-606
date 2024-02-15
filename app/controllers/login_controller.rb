# app/controllers/your_controller_name_controller.rb

class LoginController < ApplicationController
    def new
      # This is the action that will render the login form
    end

    def create
      email = params[:email]
      password = params[:password]
  
      # Fetch user from the database based on the email
      user = User.find_by(email: email)
  
      if user && user.password == password
        logger.debug "Login successful"
        redirect_to '/static_pages/home' # Redirect to your desired page
      else
        redirect_to '/login' # Redirect to login page or show error message
      end
    end
  end
  
  