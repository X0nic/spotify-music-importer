require "spotify/music/importer/version"

module Spotify::Music::Importer
  class SpotifyMatch
    def initialize(results, options = {})
      @results = results
      @clean_album = options.delete(:clean_album) { false }
      @clean_track = options.delete(:clean_track) { false }
    end

    def found_match?
      @results['tracks']['items'].count > 0
    end

    def name
      if @clean_track
        TrackNameCleaner.new(@results["tracks"]["items"].first["name"]).clean
      else
        @results["tracks"]["items"].first["name"]
      end
    end

    def artist
      @results["tracks"]['items'].first['artists'].first['name']
    end

    def album
      if @clean_album
        AlbumNameCleaner.new(@results["tracks"]['items'].first['album']['name']).clean
      else
        @results["tracks"]['items'].first['album']['name']
      end
    end

    def id
      @results ["tracks"]["items"].first["id"]
    end

    def to_s
      "Name: #{name} Album: #{album} Artist: #{artist} id: #{id}"
    end
  end
end
