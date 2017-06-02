class WeatherSearch

  include HTTParty
  APP_ID = "&appid=f52bce8cfd7d14b56af79d3307d92b88"
  base_uri "api.openweathermap.org/data/2.5/"
  BASE_URL = "http://api.openweathermap.org/data/2.5/"

  def self.update_city city, results
    current = results["main"]["temp"]
    city[:current] = current
    city[:external_id] = results["id"]
    city[:in_range] = current >= city[:min].to_f && current <= city[:max].to_f
    return city
  end

  def self.update_cities cities, results
    i = -1
    cities.map { |c| self.update_city(c, results["list"][i+=1]) }
  end

  def self.make_request url, city_or_cities, single=false
    error_msg = "There was a problem fetching weather: "

    begin
      results = self.get(url)
      return { error: error_msg + results["message"] } if results["message"]
      return self.update_cities(city_or_cities, results) unless single
      return self.update_city(city_or_cities, results) if single
    rescue Exception => e
      msg = error_msg + e.to_s
      Rails.logger.fatal msg
      return { error: msg }
    end

  end

  def self.search_city city
    city_name =  city[:name].to_s.strip.downcase.gsub(/\s/, '+')
    url = "#{BASE_URL}weather?q=#{city_name}#{APP_ID}"
    self.make_request url, city, "single"
  end

  def self.search_cities cities
    binding.pry
    ids = cities.map{|c| c["external_id"]}.join(",")
    url = "#{BASE_URL}group?id=#{ids}#{APP_ID}"
    self.make_request url, cities
  end

  def self.mock_single
    city = { name: "Los Angeles", min: 70, max: 300, current: "",
            in_range: false, external_id: 5368361 }
    results = self.search_city city
    binding.pry

  end
  def self.mock_multiple
    city_one = { name: "Los Angeles", min: 70, max: 300, current: "",
            in_range: false, external_id: 5368361 }
    city_two = { name: "Vancouver", min: 70, max: 300, current: "",
            in_range: false, external_id: 6173331 }
    results = self.search_cities [city_one, city_two]
    binding.pry

  end

end

