Rails.application.routes.draw do
  resources :events do
    member do
      get 'yes_response', to: 'events#yes_response'
      get 'no_response', to: 'events#no_response'
      get 'yes_response_series', to: 'events#yes_response_series'
      get 'no_response_series', to: 'events#no_response_series'
    end
    resource :event_info
  end

  root 'signin#new'
  get 'static_pages/home'
  get 'static_pages/help'
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root 'static_pages#main'
  get 'signin', to: 'signin#new'

  # root :to => redirect('/static_pages/home')
  get 'home' => 'static_pages#home'
  get 'series' => 'events#series_event'
  get 'newEvents' => 'events#new'
  get 'eventsList' => 'events#event_status'
  get 'peopleList' => 'people_list#people_list'
  get 'eventdashboard' => 'events#eventdashboard'

  get 'invite_attendees/:id' => 'events#invite_attendees', as: "invite_attendees"
  get 'send_reminders_to_attendees/:id' => 'events#send_reminders_to_attendees', as: 'send_reminders_to_attendees'
  # get '/login' => 'login#new'
  # post '/login' => 'login#create'
  # get '/signin' => 'Signin#new'
  # post '/signin' => 'Signin#create'
  get '/signin', to: 'signin#new'
  post '/signin', to: 'signin#create'
  get "/redirect", to: "calendars#redirect", as: 'redirect'
  get "/callback", to: "calendars#callback", as: 'callback'
  post 'create_event/:id', to: 'calendars#create_event', as: 'create_event'

  #get 'events/:id/email_invitation' => 'events#email_invitation', as: :email_invitation


  #get 'eventsList' => 'events#index'

  #for login
  # post '/check_login', to: 'login_controller#check_login'

end