# spec/controllers/static_pages_controller_spec.rb

require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe 'GET #home' do
    it 'renders the home template' do
      get :home
      expect(response).to render_template(:home)
    end
  end

  describe 'GET #help' do
    it 'renders the help template' do
      get :help
      expect(response).to render_template(:help)
    end
  end
end
