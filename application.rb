require "sinatra"
require 'rspotify'
require 'sinatra/static_assets'

RSpotify.authenticate(ENV['clientid'], ENV['clientsecret'])

get "/" do
  getartist
end

def backgroundcolor
  colors = {
    "#E50914" => "#282581", "#FF0000" => "#0A0D44", "#00FF8F" => "#0A00A4", "#FFF300" => "#E80000", "#00E8C5" => "#5A009C", "#FF9E00" => "#5A009C", "#FFEC00" => "#FF00A6", "#51FF00" => "#7400BF"}
  @color1, @color2  = colors.to_a.sample
end

def getartist(artist = "")
  @input = artist
  if @input.empty?
     @image = "image1.jpg"
  else
    begin
      @search = RSpotify::Artist.search(@input)
      @artist = @search.first
      @genres = @artist.genres
    rescue
      puts "NOOOOOOO"
      @check = false
      @image = "image1.jpg"
    else
      puts "yasss"
      @check = true
      @image = @artist.images.first["url"]
      puts @check.inspect
    end
  end
  backgroundcolor
  erb :index
end

post "/" do
  getartist params["artist"]
end
