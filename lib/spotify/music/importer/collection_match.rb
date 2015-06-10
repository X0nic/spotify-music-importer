require "spotify/music/importer/version"

module Spotify::Music::Importer
  class CollectionMatch
    def initialize(collection_record, spotify_match)
      @collection_record = collection_record
      @spotify_match = spotify_match
    end

    def full_match
      name_match && album_match
    end

    def name_match
      @collection_record.name == @spotify_match.name
    end

    def album_match
      @collection_record.album == @spotify_match.album
    end
  end
end
