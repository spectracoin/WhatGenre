require "sinatra"
require 'rspotify'
require 'sinatra/static_assets'

# Authentification for Spotify API.
RSpotify.authenticate(ENV['clientid'], ENV['clientsecret'])

get "/" do
  backgroundcolor
  erb :index
end

post "/genres" do
  if !params["artist"].empty?
    getgenres params["artist"]
    if @check == false
      @tryagain = true
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
  @image = "image1.jpg"
  @artistInput = artist
  puts @artistInput
  unless @artistInput.empty?
    artistInfo = RSpotify::Artist.search(@artistInput).first
    puts artistInfo
    @id = artistInfo.id
    puts @id
    @check = false
    unless artistInfo.nil? || artistInfo.genres.empty?
      puts  "went through"
      @check = true
      @genres = artistInfo.genres
        unless artistInfo.images.empty?
          @image = artistInfo.images.first["url"]
        end
    end
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

def backgroundcolor
  colors = {
    "#E50914" => "#282581", "#FF0000" => "#0A0D44", "#00FF8F" => "#0A00A4", "#FFF300" => "#E80000", "#00E8C5" => "#5A009C", "#FF9E00" => "#5A009C", "#FFEC00" => "#FF00A6", "#51FF00" => "#7400BF"}
  @color1, @color2  = colors.to_a.sample
end
