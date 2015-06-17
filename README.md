# Spotify Music Importer

If you want to import your library of music into spotify, this will help. It uses CSV right now, as most library exports are in that format.

## Installation

    $ gem install spotify-music-importer

## Usage

```sh
bundle exec spotify-music-importer import -f CSV_FILE -t SPOTIFY_ACCESS_TOKEN
```


## Example CSV

```csv
Name,Artist,Album,Track Number
""40"","U2","War (Remastered)","10"
"The (After) Life Of The Party","Fall Out Boy","Infinity On High","9"
"...but home is nowhere","AFI","Sing The Sorrow","12"
"1000 Oceans","Tokio Hotel","Scream (Canadian Version)","13"
"15 Minutes","The Strokes","First Impressions Of Earth","11"
"17","The Smashing Pumpkins","Adore","16"
"17","Kings Of Leon","Only By The Night","7"
"1979","Good Charlotte","Cardiology","12"
"21 Guns","Green Day","21st Century Breakdown","16"
"21st Century Breakdown","Green Day","21st Century Breakdown","2"
"21st Century (Digital Boy)","Bad Religion","All Ages","14"
"21st Century Breakdown","Green Day","21st Century Breakdown","1"
"21st Century (Digital Boy)","Bad Religion","Stranger Than Fiction","15"
"21st Century Breakdown","Green Day","21st Century Breakdown","2"
```

## Contributing

1. Fork it ( https://github.com/x0nic/spotify-music-importer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
