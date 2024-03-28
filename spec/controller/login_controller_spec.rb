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
end
