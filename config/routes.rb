Rails.application.routes.draw do
  root to: 'distance#index'

  get '/search' => 'distance#search'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
