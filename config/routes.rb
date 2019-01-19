Rails.application.routes.draw do
  root 'locations#index'

  resources :locations
  resources :stations

  get '/unavailable', to: 'locations#unavailable', as:'service_unavailable'
  get '/locations/:id/update-weather', to: 'locations#update_weather_data', as: 'update_weather_data'
  post '/stations/:id/update-temperature', to: 'stations#update_temperature', as: 'update_station_temperature'
  get '/remove_duplicates', to: 'record#remove_duplicates'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
