# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  describe 'GET #new' do
    it 'renders the login form' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let!(:user) { User.create(email: 'user@example.com', password: 'password') } # Adjust based on your User model

    context 'with valid credentials' do
      it 'redirects to the home page' do
        post :create, params: { email: 'user@example.com', password: 'password' }
        expect(response).to redirect_to('/static_pages/home')
      end
    end

    context 'with invalid credentials' do
      it 'redirects back to the login page with incorrect password' do
        post :create, params: { email: 'user@example.com', password: 'wrongpassword' }
        expect(response).to redirect_to('/login')
      end

      it 'redirects back to the login page with non-existent email' do
        post :create, params: { email: 'nonexistent@example.com', password: 'password' }
        expect(response).to redirect_to('/login')
      end
    end
  end

  describe 'POST #login' do
    let!(:user) { User.create(email: 'user@example.com', password: 'password') }

    context 'when continuing without signing in' do
      it 'sets a session user_email as not signed in and redirects to the dashboard' do
        post :login, params: { commit: 'Continue without signing in' }
        expect(session[:user_email]).to eq('Not Signed In')
        expect(response).to redirect_to(eventdashboard_path)
      end
    end

    context 'with valid credentials' do
      it 'sets the session user_email and redirects to the dashboard' do
        post :login, params: { email: 'user@example.com', password: 'password' }
        expect(session[:user_email]).to eq('user@example.com')
        expect(response).to redirect_to(eventdashboard_path)
      end
    end

    context 'with invalid credentials' do
      it 'renders the login form with an error when the password is incorrect' do
        post :login, params: { email: 'user@example.com', password: 'wrongpassword' }
        expect(session[:user_email]).to be_nil
        expect(flash[:error]).to eq('Invalid email or password')
        expect(response).to render_template('new')
      end

      it 'renders the login form with an error when the email does not exist' do
        post :login, params: { email: 'nonexistent@example.com', password: 'password' }
        expect(session[:user_email]).to be_nil
        expect(flash[:error]).to eq('Invalid email or password')
        expect(response).to render_template('new')
      end
    end 
  end

  describe 'GET #new' do
    it 'renders the login form' do
      get :new
      expect(response).to render_template(:new)
    end
  end


end
