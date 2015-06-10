require "spotify/music/importer/spotify_library"
require "spotify/music/importer/collection_record"

require 'colorize'
require 'csv'
require 'spotify-client'


module Spotify
  module Music
    module Importer
      class Cli
        def initialize
        end

        def import(filename, options)
          @options = options
          @library = SpotifyLibrary.new(client)
          limit = options.delete(:limit) { nil }
          skip  = options.delete(:skip) { 0 }

          collection = CSV.read(filename, :headers => true)
          collection.each_with_index do |row, index|
            next if skip && skip > index+1
            break if limit && index+1 > limit+skip

            record = CollectionRecord.new(row, :clean_album => true, :clean_track => true)
            results = SpotifyMatch.new(client.search(:track, format_query(record)), :clean_album => true, :clean_track => true)
            @library.find_and_add_to_library(record, results, index)
          end
        end

        def missing
          @library.missing
        end

        def format_query(record)
          "track:#{record.name} artist:#{record.artist} album:#{record.album}"
        end

        def client
          @client ||= begin
                        if @options[:access_token]
                          Spotify::Client.new({:raise_errors => true}.merge(@options))
                        else
                          Spotify::Client.new(:raise_errors => true)
                        end
                      end
        end

      end
    end
  end
end
