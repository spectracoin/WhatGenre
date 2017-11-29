<h1 align="center">
  WhatGenre
</h1>
This web application uses the [Spotify API](https://developer.spotify.com/) to find an artist's genre and generates a playlist with top-tracks by artists with the same genre.

![Screenshot](/docs/screenshot2.png)

[See more screenshots](#more-screenshots)

## Getting Started

1. Download the [ZIP file](https://github.com/khendrikse/whatgenre/archive/master.zip)
2. Unzip the ZIP file
3. Make sure you install all neccesary prerequisites (see below)

### Prerequisites

This app uses the following:
* [ruby](https://www.ruby-lang.org/en/documentation/installation/) version: 2.3.1
* [sinatra](https://rubygems.org/gems/sinatra)
* [rspotify](https://rubygems.org/gems/rspotify)
* [rack](https://rubygems.org/gems/rack) version: ~> 2.0, >= 2.0.3
* [sinatra-static-assets](https://rubygems.org/gems/sinatra-static-assets) version: ~> 1.0, >= 1.0.4
* [http](https://rubygems.org/gems/http)
* [json](https://rubygems.org/gems/json)

### Getting started

This app uses a Client ID and Secret Key. These are used as environment variables. To get these and to be able to use the Web API, the first thing you will need is a Spotify user account (Premium or Free). To get one, simply sign up at [www.spotify.com](www.spotify.com).

When you have a user account, go to the [My Applications](https://developer.spotify.com/my-applications) page at the [Spotify Developer website](https://developer.spotify.com) and, if necessary, log in. Accept the latest Developer Terms of Use to complete the set-up of your account.

Follow [this Spotify tutorial](https://developer.spotify.com/web-api/tutorial/) to get your Client ID and Secret Key.

## Built With

* [Spotify API](https://developer.spotify.com/web-api/) - The API used.
* [Sinatra](https://rubygems.org/gems/sinatra) - The DSL used.
* [Ruby](https://www.ruby-lang.org/en/documentation/installation/) - The language used.
* [rspotify](https://rubygems.org/gems/rspotify) - A ruby wrapper for the Spotify Web API.

## More screenshots
![Screenshot](/docs/screenshot1.png)
![Screenshot](/docs/screenshot2.png)
![Screenshot](/docs/screenshot3.png)
![Screenshot](/docs/screenshot4.png)
