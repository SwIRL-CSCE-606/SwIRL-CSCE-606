    #spec/features/user_story_3.rb
    require 'rails_helper'

    RSpec.feature 'Add People to the event' do
      scenario 'Add People to the event page' do
        visit root_path('/static_pages/home')
        click_on 'Organizer Button'
        expect(page).to have_content('Singular Event')
        expect(page).to have_content('Series Event')
        click_on 'Singular Event Button'
        expect(page).to have_content('Add People')
        click_on 'Add People'
        expect(page).to have_content('Email')
      end
    
    
      scenario 'Add People to the Singular Event' do
        visit people_list_page_path('/people_list')
        fill_in 'Email', with: 'testemail@gmail.com'
        expect(page).to have_content('Confirmation Message')
      end
    
      scenario 'The details of the person added to the page should be saved in the database' do
        visit people_list_page_path('//people_list')
        RSpec.describe User, type: :model do
            it "creates a new user in the database" do
        user = User.new(name: "Test", email: "testemail@gmail.com")
        expect(user.save).to be_truthy
            end
        end
     end

    
      scenario 'User fills out email field on the webpage' do
        visit people_list_page_path('/people_list')
        fill_in 'email', with: 'testemail@gmail.com'
        click_button 'Submit' 
        expect(find_field('email').value).to eq('testemail@gmail.com')
        end
    end




    
    
    
    
    
    
    
    
    