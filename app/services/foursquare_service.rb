class FoursquareService
  # This extracts all the interaction with FourSquare's api out of our controllers

  def authenticate!(client_id, client_secret, code)
    resp = Faraday.get("https://foursquare.com/oauth2/access_token") do |req|
      req.params['client_id'] = client_id
      req.params['client_secret'] = client_secret
      req.params['grant_type'] = 'authorization_code'
      req.params['redirect_uri'] = "http://localhost:3000/auth"
      req.params['code'] = code
    end
    body = JSON.parse(resp.body)
    body["access_token"]
  end

  def friends(token)
    # Here we go as far as to return just the part of the JSON response that we need to build a friends list, 
    # rather than forcing the controller or view to know how to pull the right data. 
    # Since the method is named friends, it makes sense that it would just return a representation of the friends.
    # Then in our controller, we can update the friends action to use the service object
    resp = Faraday.get("https://api.foursquare.com/v2/users/self/friends") do |req|
      req.params['oauth_token'] = token
      req.params['v'] = '20160201'
    end
    JSON.parse(resp.body)["response"]["friends"]["items"]
  end

  def get_venues_by_location(client_id, client_secret, location)
    resp = Faraday.get 'https://api.foursquare.com/v2/venues/search' do |req|
      req.params['client_id'] = client_id
      req.params['client_secret'] = client_secret
      req.params['v'] = '20160201'
      req.params['near'] = location
      req.params['query'] = 'coffee shop'
    end

    body = JSON.parse(resp.body)
    if resp.success?
      venues = body["response"]["venues"]
    else
      error = body["meta"]["errorDetail"]
    end

  end
end
