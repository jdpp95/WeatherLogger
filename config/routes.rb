Rails.application.routes.draw do
  root 'locations#index'

  resources :locations
  resources :stations

  get '/unavailable', to: 'locations#unavailable', as:'service_unavailable'
  get '/locations/:id/update-weather', to: 'locations#update_weather_data', as: 'update_weather_data'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
