require 'rails_helper'

RSpec.describe WeatherSearch, type: :model do

  describe "update_city" do
    it "returns city with correct data"
    it "raises exception with correct message when error"
  end

  describe "update_cities" do
    it "calls update_city on each city"
  end

  describe "make_request" do
    it "calls get with correct url"
    it "returns error with correct message if results have message"
    it "calls and returns update_cities with correct data when not single"
    it "does not call update_cities with correct data when single"
    it "calls and returns update_city with correct data if single"
    it "does not call update_city with correct data if not single"
    it "calls Rails.logger.fatal with correct message when exception"
    it "returns correct error when exception"
  end

  describe "search_city" do
    it "formats city_name correctly"
    it "calls and returns make_request with correct params"
  end

  describe "search_cities" do
    it "calls and returns make_request with correct params"
  end

end
