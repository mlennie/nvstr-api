class WeatherSearch

  include HTTParty
  APP_ID = "&appid=f52bce8cfd7d14b56af79d3307d92b88"
  base_uri "api.openweathermap.org/data/2.5/"
  BASE_URL = "http://api.openweathermap.org/data/2.5/"

  def self.update_city city, results
    current = results["main"]["temp"]
    city[:current] = current
    city[:id] = results["id"]
    city[:in_range] = current >= city[:min] && current <= city[:max]
    return city
  end

  def self.search_single_city city
    error_msg = "There was a problem fetching weather: "

    begin
      city_name =  city[:name].to_s.strip.downcase.gsub(/\s/, '+')
      url = "#{BASE_URL}weather?q=#{city_name}#{APP_ID}"
      results = self.get(url)
      return { error: error_msg + results["message"] } if results["cod"] != 200
      return self.update_city city, results
    rescue Exception => e
      msg = error_msg + e.to_s
      Rails.logger.fatal msg
      return { error: msg }
    end

  end

  def self.search_multiple_cities cities

  end

  def self.mock_single
    city = {name: "Los Angeles",min: 70, max: 300,current: nil, in_range: false}
    results = search_single_city city
    binding.pry

  end
end

