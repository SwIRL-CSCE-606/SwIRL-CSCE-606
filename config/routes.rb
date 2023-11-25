Rails.application.routes.draw do
  resources :events do
    member do
      get 'yes_response', to: 'events#yes_response'
      get 'no_response', to: 'events#no_response'
      get 'yes_response_series', to: 'event#yes_response_series'
      get 'no_response_series', to: 'event#no_response_series'
    end
    resource :event_info
  end

  get 'static_pages/home'
  get 'static_pages/help'
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'static_pages#main'
  # root :to => redirect('/static_pages/home')
  get 'home' => 'static_pages#home'
  get 'series' => 'events#series_event'
  get 'newEvents' => 'events#new'
  get 'eventsList' => 'events#event_status'
  get 'peopleList' => 'people_list#people_list'
  get 'eventdashboard' => 'events#eventdashboard'

  get 'invite_attendees/:id' => 'events#invite_attendees', as: "invite_attendees"
  get 'send_reminders_to_attendees/:id' => 'events#send_reminders_to_attendees', as: 'send_reminders_to_attendees'

  #get 'events/:id/email_invitation' => 'events#email_invitation', as: :email_invitation


  #get 'eventsList' => 'events#index'

end