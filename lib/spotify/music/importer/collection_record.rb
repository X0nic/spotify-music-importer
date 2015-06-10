require "spotify/music/importer/version"

module Spotify::Music::Importer
  class CollectionRecord
    def initialize(row, options = {})
      @row = row
      @clean_album = options.delete(:clean_album) { false }
      @clean_track = options.delete(:clean_track) { false }
    end

    def name
      if @clean_track
        TrackNameCleaner.new(@row['Name']).clean
      else
        @row['Name']
      end
    end

    def artist
      if @clean_album
        @row['Artist'].gsub('(Special Edition)', '').strip
      else
        @row['Artist']
      end
    end

    def album
      if @clean_album
        AlbumNameCleaner.new(@row['Album']).clean
      else
        @row['Album']
      end
    end

    def to_s
      "Name: #{name} Album: #{album} Artist: #{artist}"
    end

    def to_json(options = {})
      { :name => name, :album => album, :artist => artist }.to_json(options)
    end
  end
end
