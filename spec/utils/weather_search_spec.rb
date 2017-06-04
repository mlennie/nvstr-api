require 'rails_helper'

RSpec.describe WeatherSearch, type: :model do

  describe "update_city" do
    it "returns city with correct data" do
      update_city_returns_city
    end
    it "calculates in_range as true when should" do
      update_city_is_in_range
    end
    it "calculates in_range as false when should" do
      update_city_is_not_in_range
    end
  end

  describe "update_cities" do
    it "calls update_city on each city" do
      update_cities_calls_update_city_for_each
    end
  end

  describe "make_request" do
    it "calls get with correct url" do
      make_request_calls_get
    end
    it "returns error with correct message if results have message" do
      make_request_returns_error_when_result_message
    end
    it "calls and returns update_cities with correct data when not single" do
      make_request_returns_update_cities_when_should
    end
    it "calls and returns update_city with correct data if single" do
      make_request_returns_update_city_when_should
    end
    it "calls Rails.logger.fatal with correct message when exception" do
      make_request_calls_logger
    end
    it "returns correct error when exception" do
      make_request_returns_error_when_exception
    end
  end

  describe "search_city" do
    it "formats city_name and calls and returns make_request with correct params" do
      search_city_calls_make_request
    end
  end

  describe "search_cities" do
    it "calls and returns make_request with correct params" do
      search_cities_calls_make_request
    end
  end

end

