require 'rails_helper'

RSpec.describe 'Routing', type: :routing do
  describe 'Event routes' do
    it 'routes GET /events/:id/yes_response to the events controller yes_response action' do
      expect(get: '/events/1/yes_response').to route_to(controller: 'events', action: 'yes_response', id: '1')
    end

    it 'routes GET /events/:id/no_response to the events controller no_response action' do
      expect(get: '/events/1/no_response').to route_to(controller: 'events', action: 'no_response', id: '1')
    end

    # Add more tests for other custom routes...
  end

  describe 'StaticPages routes' do
    it 'routes GET /static_pages/home to the static_pages controller home action' do
      expect(get: '/static_pages/home').to route_to(controller: 'static_pages', action: 'home')
    end

    it 'routes GET /static_pages/help to the static_pages controller help action' do
      expect(get: '/static_pages/help').to route_to(controller: 'static_pages', action: 'help')
    end

    # Add more tests for other static pages routes...
  end

  describe 'Signin routes' do
    it 'routes GET /signin to the signin controller new action' do
      expect(get: '/signin').to route_to(controller: 'signin', action: 'new')
    end

    it 'routes POST /signin to the signin controller create action' do
      expect(post: '/signin').to route_to(controller: 'signin', action: 'create')
    end
  end
end