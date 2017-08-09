require 'test_helper'

class LocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @location = locations(:one)
  end

  test "should get index" do
    get locations_url
    assert_response :success
  end

  test "should get new" do
    get new_location_url
    assert_response :success
  end

  test "should create location" do
    assert_difference('Location.count') do
      post locations_url, params: { location: { continent: @location.continent, elevation: @location.elevation, gps_code: @location.gps_code, home_link: @location.home_link, iata_code: @location.iata_code, identifier: @location.identifier, iso_country: @location.iso_country, iso_region: @location.iso_region, keywords: @location.keywords, latitude: @location.latitude, local_code: @location.local_code, longitude: @location.longitude, municipality: @location.municipality, name: @location.name, scheduled_service: @location.scheduled_service, type: @location.type, wikipedia_link: @location.wikipedia_link } }
    end

    assert_redirected_to location_url(Location.last)
  end

  test "should show location" do
    get location_url(@location)
    assert_response :success
  end

  test "should get edit" do
    get edit_location_url(@location)
    assert_response :success
  end

  test "should update location" do
    patch location_url(@location), params: { location: { continent: @location.continent, elevation: @location.elevation, gps_code: @location.gps_code, home_link: @location.home_link, iata_code: @location.iata_code, identifier: @location.identifier, iso_country: @location.iso_country, iso_region: @location.iso_region, keywords: @location.keywords, latitude: @location.latitude, local_code: @location.local_code, longitude: @location.longitude, municipality: @location.municipality, name: @location.name, scheduled_service: @location.scheduled_service, type: @location.type, wikipedia_link: @location.wikipedia_link } }
    assert_redirected_to location_url(@location)
  end

  test "should destroy location" do
    assert_difference('Location.count', -1) do
      delete location_url(@location)
    end

    assert_redirected_to locations_url
  end
end
