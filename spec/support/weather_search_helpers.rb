module WeatherSearchHelpers

  def call_update_city in_range=true
    temp = in_range ? 33 : 55
    city = {"min" => 22,"max" => 44}
    search_results = {"main" => {"temp" => temp}, "id" => 123}
    expected_results = {"min" => 22,"max" => 44, "current" => temp,
                        "external_id" => 123, "in_range" => in_range}
    results = WeatherSearch.update_city city, search_results
    expect(results).to eq(expected_results)
  end
  def update_city_returns_city
    call_update_city
  end
  def update_city_is_in_range
    call_update_city true
  end
  def update_city_is_not_in_range
    call_update_city false
  end
  def update_cities_calls_update_city_for_each
    search_results = {"list" => ["one","two"]}
    cities = ["city_one", "city_two"]
    allow(WeatherSearch).to receive(:update_city)
    expect(WeatherSearch).to receive(:update_city).once.with("city_one","one")
    expect(WeatherSearch).to receive(:update_city).once.with("city_two","two")
    WeatherSearch.update_cities cities, search_results
  end

  def make_request_calls_get
    allow(WeatherSearch).to receive(:update_city)
    allow(WeatherSearch).to receive(:get)
    expect(WeatherSearch).to receive(:get).with("url")
    WeatherSearch.make_request "url","city"
  end
  def make_request_returns_error_when_result_message
    error_msg = "There was a problem fetching weather: "
    allow(WeatherSearch).to receive(:update_city)
    allow(WeatherSearch).to receive(:get).and_return({"message" => "error"})
    result = WeatherSearch.make_request "url","city"
    expect(result).to eq({error: error_msg + "error"})
  end
  def make_request_returns_update_cities_when_should
    allow(WeatherSearch).to receive(:get).and_return({})
    allow(WeatherSearch).to receive(:update_cities).and_return("expected_result")
    expect(WeatherSearch).to receive(:update_cities)
    expect(WeatherSearch).not_to receive(:update_city)
    result = WeatherSearch.make_request "url","city", false
    expect(result).to eq("expected_result")
  end
  def make_request_returns_update_city_when_should
    allow(WeatherSearch).to receive(:get).and_return({})
    allow(WeatherSearch).to receive(:update_city).and_return("expected_result")
    expect(WeatherSearch).not_to receive(:update_cities)
    expect(WeatherSearch).to receive(:update_city)
    result = WeatherSearch.make_request "url","city", true
    expect(result).to eq("expected_result")
  end
  def make_request_calls_logger
    error_msg = "There was a problem fetching weather: "
    allow(WeatherSearch).to receive(:get).and_return({})
    allow(WeatherSearch).to receive(:update_city).and_return("expected_result")
    allow(WeatherSearch).to receive(:update_cities).and_raise("error")
    expect(Rails.logger).to receive(:fatal).with(error_msg + "error")
    WeatherSearch.make_request "url","city"
  end
  def make_request_returns_error_when_exception
    error_msg = "There was a problem fetching weather: error"
    allow(WeatherSearch).to receive(:get).and_return({})
    allow(WeatherSearch).to receive(:update_city).and_return("expected_result")
    allow(WeatherSearch).to receive(:update_cities).and_raise("error")
    result = WeatherSearch.make_request "url","city"
    expect(result).to eq({error: error_msg})
  end
  def search_city_calls_make_request
    city = {name: " lOs AnGEles   "}
    url = "#{WeatherSearch::BASE_URL}weather?q=los+angeles#{WeatherSearch::APP_ID}"
    allow(WeatherSearch).to receive(:make_request).and_return("results")
    expect(WeatherSearch).to receive(:make_request).with(url,city,"single")
    result = WeatherSearch.search_city city
    expect(result).to eq("results")
  end
  def search_cities_calls_make_request
    cities = [{"external_id" => 1},{"external_id" => 2}]
    url = "#{WeatherSearch::BASE_URL}group?id=1,2#{WeatherSearch::APP_ID}"
    allow(WeatherSearch).to receive(:make_request).and_return("results")
    expect(WeatherSearch).to receive(:make_request).with(url, cities)
    result = WeatherSearch.search_cities cities
    expect(result).to eq("results")
  end

=begin
  def setup_get error=false
    url = "/pricing/records.json"

    query = {
      api_key: "abc123key",
      start_date: "11-03-2017",
      end_date: "11-04-2017"
    }

    options = { query: query }

    allow(Time).to receive(:now).and_return(Time.local(2017, 04, 11))
    if error
      allow(ProductSearch).to receive(:get).once.and_raise("error")
    else
      expect(ProductSearch).to receive(:get).with(url, options)
                                          .and_return({productRecords: "results"})
    end
  end

  def product_search_get_products_calls_get_products
    setup_get
    ProductSearch.get_products
  end

  def product_search_get_products_returns_product_records
    setup_get
    expect(ProductSearch.get_products).to eq("results")
  end

  def product_search_get_products_catches_error
    setup_get error: true
    expect(Rails.logger).to receive(:fatal).with("There was a problem fetching products: error")
    expect(ProductSearch.get_products).to eq([])
  end

  def product_search_parse_price_parses_price
    expect(ProductSearch.parse_price "$12.35").to eq(1235)
  end

  def past_price_create_new_creates_past_price
    expect(ProductSearch.parse_price nil).to be_nil
  end

=end
end

