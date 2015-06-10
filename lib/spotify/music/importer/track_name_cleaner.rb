require "spotify/music/importer/version"

module Spotify::Music::Importer
  class TrackNameCleaner
    def initialize(track_name)
      @track_name = track_name
    end

    def clean
      cleaned_track = @track_name

      extraneous_track_info.each do |track_info|
        cleaned_track = cleaned_track.gsub(track_info, '').strip
      end

      cleaned_track
    end

    def extraneous_track_info
      [
        '- Remastered',
        '- Single',
        '(Clean Album Version) (Clean)',
        '(Album Version)',
        '(Amended Album Version)',
        '(Explicit Album Version)'
      ]
    end
  end
end
