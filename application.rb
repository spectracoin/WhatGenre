require "sinatra"
require 'rspotify'
require 'sinatra/static_assets'

RSpotify.authenticate(ENV['clientid'], ENV['clientsecret'])

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
