module WeatherSearchHelpers

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

end

