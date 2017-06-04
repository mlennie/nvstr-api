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

