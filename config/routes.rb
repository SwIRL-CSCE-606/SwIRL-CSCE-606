Rails.application.routes.draw do
  get 'static_pages/home'
  get 'static_pages/help'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'static_pages#home'
  # root :to => redirect('/static_pages/home')
  get 'singular' => 'static_pages#singular_event'
  get 'series' => 'static_pages#series_event'
end
