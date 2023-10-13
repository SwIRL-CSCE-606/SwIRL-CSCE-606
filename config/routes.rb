Rails.application.routes.draw do
  resources :events
  get 'static_pages/home'
  get 'static_pages/help'
  
  post '/submit_form', to: 'people_list#form'


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'static_pages#main'
  # root :to => redirect('/static_pages/home')
  get 'home' => 'static_pages#home'
  get 'series' => 'static_pages#series_event'
  get 'newEvents' => 'events#new'
  get 'eventsList' => 'events#event_status'
  get 'peopleList' => 'people_list#people_list'

  if Rails.env.development? || Rails.env.test?
    get '/test_email_invitation', to: 'event_remainder_mailer_test#email_invitation', as: 'test_email_invitation'
  end


end