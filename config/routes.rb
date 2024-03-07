# Rails.application.routes.draw do
#   resources :events do
#     member do
#       get 'yes_response', to: 'events#yes_response'
#       get 'no_response', to: 'events#no_response'
#       get 'yes_response_series', to: 'events#yes_response_series'
#       get 'no_response_series', to: 'events#no_response_series'
#     end
#     resource :event_info
#   end

#   root 'signin#new'
#   get 'static_pages/home'
#   get 'static_pages/help'
  
#   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

#   # Defines the root path route ("/")
#   # root 'static_pages#main'
#   get 'signin', to: 'signin#new'

#   # root :to => redirect('/static_pages/home')
#   get 'home' => 'static_pages#home'
#   get 'series' => 'events#series_event'
#   get 'newEvents' => 'events#new'
#   get 'eventsList' => 'events#event_status'
#   get 'peopleList' => 'people_list#people_list'
#   get 'eventdashboard' => 'events#eventdashboard'
#   get 'signup' => 'users#new'

#   get 'invite_attendees/:id' => 'events#invite_attendees', as: "invite_attendees"
#   get 'send_reminders_to_attendees/:id' => 'events#send_reminders_to_attendees', as: 'send_reminders_to_attendees'
#   # get '/login' => 'login#new'
#   # post '/login' => 'login#create'
#   # get '/signin' => 'Signin#new'
#   # post '/signin' => 'Signin#create'
#   get '/signin', to: 'signin#new'
#   post '/signin', to: 'signin#create'

#   #get 'events/:id/email_invitation' => 'events#email_invitation', as: :email_invitation


#   #get 'eventsList' => 'events#index'

#   #for login
#   # post '/check_login', to: 'login_controller#check_login'

# end






Rails.application.routes.draw do
  # Events routes
  resources :events do
    member do
      get 'yes_response', to: 'events#yes_response'
      get 'no_response', to: 'events#no_response'
      get 'yes_response_series', to: 'events#yes_response_series'
      get 'no_response_series', to: 'events#no_response_series'
    end
    resource :event_info
  end

  # Static pages routes
  get 'static_pages/home'
  get 'static_pages/help'

  # Sign-in routes
  get 'signin', to: 'signin#new'
  post 'signin', to: 'signin#create'

  # Sign-up route
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  # Home route
  root 'signin#new'

  # Other custom routes
  get 'home', to: 'static_pages#home'
  get 'series', to: 'events#series_event'
  get 'newEvents', to: 'events#new'
  get 'eventsList', to: 'events#event_status'
  get 'peopleList', to: 'people_list#people_list'
  get 'eventdashboard', to: 'events#eventdashboard'
  get 'invite_attendees/:id', to: 'events#invite_attendees', as: 'invite_attendees'
  get 'send_reminders_to_attendees/:id', to: 'events#send_reminders_to_attendees', as: 'send_reminders_to_attendees'
end
