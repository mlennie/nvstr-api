class CitiesController < ApplicationController

  def update_city
    render json: WeatherSearch.search_city(params[:city])
  end

  def update_cities
    render json: WeatherSearch.search_cities(JSON.parse(params[:cities]))
  end
end
