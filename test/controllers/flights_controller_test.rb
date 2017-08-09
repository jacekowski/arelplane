require 'test_helper'

class FlightsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @flight = flights(:one)
  end

  test "should get index" do
    get flights_url
    assert_response :success
  end

  test "should get new" do
    get new_flight_url
    assert_response :success
  end

  test "should create flight" do
    assert_difference('Flight.count') do
      post flights_url, params: { flight: { aircraft_id: @flight.aircraft_id, distance: @flight.distance, flight_date: @flight.flight_date, from_id: @flight.from_id, pic: @flight.pic, time_in: @flight.time_in, time_out: @flight.time_out, to_id: @flight.to_id, total_time: @flight.total_time } }
    end

    assert_redirected_to flight_url(Flight.last)
  end

  test "should show flight" do
    get flight_url(@flight)
    assert_response :success
  end

  test "should get edit" do
    get edit_flight_url(@flight)
    assert_response :success
  end

  test "should update flight" do
    patch flight_url(@flight), params: { flight: { aircraft_id: @flight.aircraft_id, distance: @flight.distance, flight_date: @flight.flight_date, from_id: @flight.from_id, pic: @flight.pic, time_in: @flight.time_in, time_out: @flight.time_out, to_id: @flight.to_id, total_time: @flight.total_time } }
    assert_redirected_to flight_url(@flight)
  end

  test "should destroy flight" do
    assert_difference('Flight.count', -1) do
      delete flight_url(@flight)
    end

    assert_redirected_to flights_url
  end
end
