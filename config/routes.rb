Rails.application.routes.draw do
  root 'locations#index'

  resources :locations
  resources :stations

  get '/unavailable', to: 'locations#unavailable', as:'service_unavailable'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
