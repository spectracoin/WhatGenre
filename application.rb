require "sinatra"
require 'rspotify'
require 'sinatra/static_assets'

RSpotify.authenticate(ENV['clientid'], ENV['clientsecret'])

get "/" do
  backgroundcolor
  erb :index
end

post "/genre" do
  puts "hoi"
  getgenre params["artist"]
  getartists params["genre"]
  puts @genres.inspect
  backgroundcolor
  erb :genre
end

post "/artist" do
  if !params["artist"].empty?
    getgenre params["artist"]
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

def getartists(genre = "")
  @artists = Array.new
  @genre = genre
  puts @genre
  if @genre.include? ' '
    @genre.tr_s!(' ', '')
  end
  puts @genre
  @output = RSpotify::Artist.search("genre:#{@genre}")
  @output.each do |artist|
    name = artist.name
    @artists.push(name)
  end
  puts "YAAAAAASS"
  puts @artists.inspect
end

def getgenre(artist = "")
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

def backgroundcolor
  colors = {
    "#E50914" => "#282581", "#FF0000" => "#0A0D44", "#00FF8F" => "#0A00A4", "#FFF300" => "#E80000", "#00E8C5" => "#5A009C", "#FF9E00" => "#5A009C", "#FFEC00" => "#FF00A6", "#51FF00" => "#7400BF"}
  @color1, @color2  = colors.to_a.sample
end
