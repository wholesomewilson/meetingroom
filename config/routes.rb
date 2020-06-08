Rails.application.routes.draw do
  resources :bookings, only: [:new, :create]
  root 'search#index'
  post 'bookings/cancel' => "bookings#destroy"
  patch 'bookings/transfer' => "bookings#update"
  get 'bookings/transfer_form' => "bookings#edit"
  get 'my_bookings' => 'profiles#show'
  get "/bookings/new" => "bookings#new", :as => 'search_room'
end
