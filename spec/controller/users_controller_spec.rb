# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #new' do
    it 'assigns a new User to @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new user' do
        expect do
          post :create,
               params: { user: { email: 'user@example.com', password: 'password', password_confirmation: 'password' } }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the root path' do
        post :create,
             params: { user: { email: 'user@example.com', password: 'password', password_confirmation: 'password' } }
        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new user' do
        expect do
          post :create, params: { user: { email: 'user', password: 'password', password_confirmation: 'mismatch' } }
        end.to_not change(User, :count)
      end

      it 're-renders the new method' do
        post :create, params: { user: { email: 'user', password: 'password', password_confirmation: 'mismatch' } }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #check_email' do
    before do
      User.create(email: 'existing@example.com', password: 'password', password_confirmation: 'password')
    end

    it 'returns true if email exists' do
      get :check_email, params: { email: 'existing@example.com' }, format: :json
      expect(response.body).to eq({ exists: true }.to_json)
    end

    it 'returns false if email does not exist' do
      get :check_email, params: { email: 'nonexistent@example.com' }, format: :json
      expect(response.body).to eq({ exists: false }.to_json)
    end
  end
end
