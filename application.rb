require "sinatra"
require 'rspotify'
require 'sinatra/static_assets'

RSpotify.authenticate(ENV['clientid'], ENV['clientsecret'])
$input = ""

get "/" do
  #  if $input.empty?
  #    $image = "image1.jpg"
  #  end
  backgroundcolor
  erb :index
end

def backgroundcolor
  @colors = [{"#E50914" => "#282581"}, {"#FF0000" => "#0A0D44"}, {"#00FF8F" => "#0A00A4"}, {"#FFF300" => "#E80000"}, {"#00E8C5" => "#5A009C"}, {"#FF9E00" => "#5A009C"}, {"#FFEC00" => "#FF00A6"}, {"#51FF00" => "#7400BF"}]
  @sample = @colors.sample
  @color1, @color2 = @sample.first
end

post "/" do
  $input = params["artist"]
  if $input.empty?
    redirect back
  else
    $search = RSpotify::Artist.search($input)
    $artist = $search.first
    $genres = $artist.genres
    $image = $artist.images.first["url"]
    redirect back
  end
end
