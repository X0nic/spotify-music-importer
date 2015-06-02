require 'colorize'
require 'csv'
require 'spotify-client'

class SpotifyImporter
  def initialize
    @missing = []
  end

  def import(filename)
    collection = CSV.read(filename, :headers => true)

    collection.each_with_index do |row, index|
      record = CollectionRecord.new(row, :clean_album => true, :clean_track => true)
      results = SpotifyMatch.new(client.search(:track, format_query(record)), :clean_album => true, :clean_track => true)
      match = CollectionMatch.new(record, results)

      if results.found_match?
        if match.full_match
          puts results.to_s.green
        elsif match.name_match
          puts results.to_s.yellow
        elsif match.album_match
          puts results.to_s.colorize(:orange)
          puts "Collection Record: #{record}"
        else
          puts results
          puts "Collection Record: #{record}"
        end
      else
        puts "not found - #{record}".red
        @missing << record
      end

    end
  end

  def missing
    @missing
  end

  def format_query(record)
    "track:#{record.name} artist:#{record.artist} album:#{record.album}"
  end

  def client
    Spotify::Client.new
  end

end

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

  def uri
    @results ["tracks"]["items"].first["uri"]
  end

  def to_s
    "Name: #{name} Album: #{album} Artist: #{artist} uri: #{uri}"
  end
end

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
