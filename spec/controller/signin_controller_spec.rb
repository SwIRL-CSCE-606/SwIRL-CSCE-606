require 'rails_helper'

RSpec.describe SigninController, type: :controller do
  describe 'GET #new' do
    it 'renders the login form' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let(:user) { User.create(email: 'test@example.com', password: 'password123') }

    context 'with valid credentials' do
      it 'logs the user in and redirects to the home page' do
        post :create, params: { email: user.email, password: 'password123' }
        expect(response).to redirect_to('/static_pages/home')
      end
    end

    context 'with invalid credentials' do
      it 'redirects to the login page' do
        post :create, params: { email: user.email, password: 'wrongpassword' }
        expect(response).to redirect_to('/signin')
      end
    end

    context 'with non-existent email' do
        it 'redirects to the login page with a user not found message' do
          post :create, params: { email: 'nonexistent@example.com', password: 'password123' }
          expect(response).to redirect_to('/signin')
          # Add an expectation for the flash message if your application sets one
        end
      end

    context 'with missing credentials' do
        it 'redirects to the login page when email is missing' do
            post :create, params: { password: 'password123' }
            expect(response).to redirect_to('/signin')
        end

        it 'redirects to the login page when password is missing' do
            post :create, params: { email: 'test@example.com' }
            expect(response).to redirect_to('/signin')
        end
    end
  end
end
