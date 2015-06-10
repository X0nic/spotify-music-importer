require "spotify/music/importer/version"
require "spotify/music/importer/collection_match"

module Spotify::Music::Importer
  class SpotifyLibrary
    def initialize(client)
      @client = client
      @missing = []
    end

    def find_and_add_to_library(record, results, index)
      match = CollectionMatch.new(record, results)

      if results.found_match?
        print "[#{index+1}] "
        if match.full_match
          print results.to_s.green
          add_to_library(results.id)
        elsif match.name_match
          print results.to_s.yellow
          add_to_library(results.id)
        elsif match.album_match
          print results.to_s.colorize(:orange)
          add_to_library(results.id)
          puts "Collection Record: #{record}"
        else
          print results
          add_to_library(results.id)
          puts "Collection Record: #{record}"
        end
      else
        puts "not found - #{record}".red
        @missing << record
      end
    end

    def missing
      @missing
    end

    private

    def add_to_library(track_id)
      if @client.library?(track_id).first
        puts " Ignored #{track_id}"
      else
        print ' Adding '
        @client.add_library_tracks(track_id)
        puts " Added #{track_id}"
      end
    end
  end
end
