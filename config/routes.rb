Rails.application.routes.draw do
  resources :bookings
  devise_for :users
  get 'home/index'
  # devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  default_url_options :host => "localhost"
  root 'home#index'

  get '/available_booking' => "bookings#available" , :as => "available_booking"
end
