require "sinatra"
require 'rspotify'
require 'sinatra/static_assets'
require "sinatra/reloader" if development?
require 'uri'
require 'net/http'
require 'json'

RSpotify.authenticate(ENV['clientid'], ENV['clientsecret'])

# asks user to authenticate then redirects back to /callback
get "/auth" do
  redirect "https://accounts.spotify.com/authorize/?client_id=#{ENV['clientid']}&response_type=code&redirect_uri=http%3A%2F%2Flocalhost:4567%2Fcallback&scope=playlist-modify-public%20playlist-modify-private&state=34fFs29kd09"
end

# gets /callback
get "/callback" do
  # takes code from url params
  code = params["code"]

  # requests token from spotify using the users code => have to clean!
  uri = URI.parse("https://accounts.spotify.com/api/token")

  response = Net::HTTP.post_form(uri, {'grant_type' => 'authorization_code', 'code' => code, 'redirect_uri' => 'http://localhost:4567/callback', 'client_id' => ENV['clientid'], 'client_secret' => ENV['clientsecret'] })

  # converts JSON into ruby hash
  data = JSON.parse(response.read_body)

  # gets user's data
  url = URI("https://api.spotify.com/v1/me")

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true #this helps with the https

  request = Net::HTTP::Get.new(url)
  request["authorization"] = "Bearer #{data["access_token"]}"
  response = http.request(request)
  puts response.read_body
end


def playlist
  uri = URI.parse("https://accounts.spotify.com/api/token")
end

get "/" do
  backgroundcolor
  erb :index
end

post "/genres" do
  if !params["artist"].empty?
    getgenres params["artist"]
    if @check == false
      backgroundcolor
      erb :index
    else
      backgroundcolor
      erb :genres
    end
  else
    backgroundcolor
    erb :index
  end
end

post "/related" do
  getgenres params["artist"]
  relatedartists params["genre"]
  backgroundcolor
  erb :related #was genre
end

def getgenres(artist = "")
  @check = false
  @artist = RSpotify::Artist.search(artist).first
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
    @color1, @color2  = colors.to_a.sample
  end
