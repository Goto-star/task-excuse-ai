Rails.application.routes.draw do
  root "excuse_requests#new"
  resources :excuse_requests, only: [:new, :create, :show, :index, :destroy]

end
