Rails.application.routes.draw do
  post '/city', to: 'cities#update_city'
  post '/cities', to: 'cities#update_cities'
end
