require "spotify/music/importer/version"

module Spotify::Music::Importer
  class AlbumNameCleaner
    def initialize(album_name)
      @album_name = album_name
    end

    def clean
      cleaned_album = @album_name

      extraneous_album_info.each do |album_info|
        cleaned_album = cleaned_album.gsub(album_info, '').strip
      end

      cleaned_album
    end

    def extraneous_album_info
      [
        '(Special Edition)',
        '(Deluxe Edition)',
        '(Deluxe Edition Remastered)',
        '(Remastered)',
        '(Canadian Version)',
        '(Non EU Version)',
        '(UK Version)',
        '(Brazilian Version)'
      ]
    end
  end
end
