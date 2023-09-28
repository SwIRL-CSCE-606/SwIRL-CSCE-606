Rails.application.routes.draw do
  resources :events
  get 'static_pages/home'
  get 'static_pages/help'
  # config/routes.rb
  post '/submit_form', to: 'people_list#form'


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'static_pages#main'
  # root :to => redirect('/static_pages/home')
  get 'home' => 'static_pages#home'
  get 'singular' => 'static_pages#singular_event'
  get 'series' => 'static_pages#series_event'
end
