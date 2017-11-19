require "sinatra"
require 'rspotify'
require 'sinatra/static_assets'
require "sinatra/reloader" if development?
require 'uri'
require 'net/http'
require 'json'
enable :sessions

# Authenticate Spotify API
RSpotify.authenticate(ENV['clientid'], ENV['clientsecret'])

# ---------- ROUTES ---------- #
# Go to page to enter artist
get "/" do
  backgroundcolor
  erb :index
end

# Go to page to see genres related to given artist
post "/genres" do
  if !params["artist"].empty?
      userInput = params["artist"]
      session[:userinput] = userInput
      getgenres(userInput)
    if @check == false
      erb :index
    else
      backgroundcolor
      erb :genres
    end
  else
    erb :index
  end
end

# Go to page to see other artists that have the same genre
post "/related" do
  genreInput = params["genre"]
  session[:genre] = genreInput
  getgenres(session[:artist])
  relatedartists(session[:genre])
  erb :related
end

# Create the playlist
post "/related+playlist" do
  authorize
end

# Go to callback page after user authenticates app
get "/callback" do
  getToken
  getgenres(session[:artist])
  relatedartists(session[:genre])
  erb :related
end

# ---------- METHODS ---------- #
# Asks user to authenticate then redirects back to /callback
def authorize
  redirect "https://accounts.spotify.com/authorize/?client_id=#{ENV['clientid']}&response_type=code&redirect_uri=http%3A%2F%2Flocalhost:4567%2Fcallback&scope=playlist-modify-public%20playlist-modify-private&state=34fFs29kd09"
end

# Sends code from user to Spotify to return acces_token and refresh_token
def getToken
  # Takes code from url params
  code = params["code"]

  # Requests token from spotify using the users code
  uri = URI.parse("https://accounts.spotify.com/api/token")

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true #this helps with the https

  request = Net::HTTP::Post.new(uri)
  request.body = "grant_type=authorization_code&code=#{code}&redirect_uri=http%3A%2F%2Flocalhost:4567%2Fcallback&client_id=#{ENV['clientid']}&client_secret=#{ENV['clientsecret']}"

  response = http.request(request)

  # Converts JSON into ruby hash
  @data = JSON.parse(response.read_body)

  # Calls on user method to get user url for creating a playlist
  user
end

# Asks Spotify for user data using access_token
def user
  # Gets user's data
  uri = URI("https://api.spotify.com/v1/me")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true # This helps with the https
  request = Net::HTTP::Get.new(uri)
  request["authorization"] = "Bearer #{@data["access_token"]}"
  response = http.request(request)

  # Converts JSON into ruby hash
  @userData = JSON.parse(response.read_body)

  # Calls on playlist method to create the playlist
  playlist
end

# Creates a playlist in the users Spotify account
def playlist
  #Posts new playlist to user's profile
  uri = URI.parse("#{@userData["href"]}/playlists")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true #this helps with the https
  request = Net::HTTP::Post.new(uri)
  request["Authorization"] = "Bearer #{@data["access_token"]}"
  request["Content-Type"] = "application/json"
  request.body = "{\"name\":\"A New Playlist\"}"
  response = http.request(request)
end

def getgenres(artist = "")
  @check = false
  @artist = RSpotify::Artist.search(artist).first
  session[:artist] = @artist.name
  session[:id] = @artist.id
  unless @artist.nil? || @artist.genres.empty?
    @check = true
    getimage
  end
end

def relatedartists(genre = "")
  @related = Array.new
  @genre = "\"#{genre}\""
  genreSearch = RSpotify::Artist.search("genre:#{@genre}")
  genreSearch.each do |artist|
    name = artist.name
    @related.push(name)
  end
end

def getimage
  if @artist.images.empty?
    @image = "image1.jpg"
  else
    @image = @artist.images.first["url"]
  end
end

def backgroundcolor
  colors = {
    "#E50914" => "#282581", "#FF0000" => "#0A0D44", "#00FF8F" => "#0A00A4", "#FFF300" => "#E80000", "#00E8C5" => "#5A009C", "#FF9E00" => "#5A009C", "#FFEC00" => "#FF00A6", "#51FF00" => "#7400BF"}
    color1, color2  = colors.to_a.sample
    session[:color1] = color1
    session[:color2] = color2
  end
