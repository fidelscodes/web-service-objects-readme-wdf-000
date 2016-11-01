class SearchesController < ApplicationController

  def search
  end

  def friends
    foursquare = FoursquareService.new
    @friends = foursquare.friends(session[:token])
  end

  def foursquare
    foursquare = FoursquareService.new
    resp = foursquare.get_venues_by_location(
      ENV['FOURSQUARE_CLIENT_ID'],
      ENV['FOURSQUARE_SECRET'],
      params[:zipcode]
    )

    resp.class == Array ? @venues = resp : @error = resp
    render 'search'

  rescue Faraday::TimeoutError
    @error = "There was a timeout. Please try again."
    render 'search'
  end
end
