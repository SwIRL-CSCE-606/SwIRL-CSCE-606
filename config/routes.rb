Rails.application.routes.draw do
  resources :events
  get 'static_pages/home'
  get 'static_pages/help'
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'static_pages#main'
  # root :to => redirect('/static_pages/home')
  get 'home' => 'static_pages#home'
  get 'series' => 'static_pages#series_event'
  get 'newEvents' => 'events#new'
  get 'eventsList' => 'events#event_status'
  get 'peopleList' => 'people_list#people_list'

  get 'events/:id/email_invitation' => 'events#email_invitation', as: :email_invitation

  #get 'eventsList' => 'events#index'

end