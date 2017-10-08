require "sinatra"
require 'rspotify'
require 'sinatra/static_assets'

RSpotify.authenticate(ENV['clientid'], ENV['clientsecret'])

get "/" do
  backgroundcolor
  erb :index
end

get "/genre/:genre" do
  puts "hoi"
  genre = params['genre']
  artist = RSpotify::Artist.search("genre:#{genre}")
  puts artist.inspect
end

def backgroundcolor
  colors = {
    "#E50914" => "#282581", "#FF0000" => "#0A0D44", "#00FF8F" => "#0A00A4", "#FFF300" => "#E80000", "#00E8C5" => "#5A009C", "#FF9E00" => "#5A009C", "#FFEC00" => "#FF00A6", "#51FF00" => "#7400BF"}
  @color1, @color2  = colors.to_a.sample
end

def getartist(artist = "")
  @input = artist
  @image = "image1.jpg"
  unless @input.empty?
    @artist = RSpotify::Artist.search(@input).first
    @check = false
    unless @artist.nil? || @artist.genres.empty?
      @check = true
      @genres = @artist.genres
        unless @artist.images.empty?
          @image = @artist.images.first["url"]
        end
    end
  end
end

post "/artist" do
  if !params["artist"].empty?
    getartist params["artist"]
    if @check == false
      @tryagain = true
      backgroundcolor
      erb :index
    else
      backgroundcolor
      erb :artist
    end
  else
    backgroundcolor
    erb :index
  end
end
