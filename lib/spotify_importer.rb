require 'colorize'
require 'csv'
require 'spotify-client'

class SpotifyImporter
  def import(filename)
    collection = CSV.read(filename, :headers => true)

    collection.each_with_index do |row, index|
      record = CollectionRecord.new(row)
      results = SpotifyMatch.new(client.search(:track, format_query(record)))

      if results.found_match?
        if full_match(results, record)
          puts results.to_s.green
        elsif name_match(results, record)
          puts results.to_s.yellow
        elsif album_match(results, record)
          puts results.to_s.colorize(:orange)
        else
          puts results
        end
      else
        puts "not found - #{record.name} - #{record.artist}".red
      end

    end
  end

  def full_match(results, record)
    name_match(results, record) && album_match(results, record)
  end

  def name_match(results, record)
    results.name == record.name
  end

  def album_match(results, record)
    # require 'pry' ; binding.pry
    results.album == record.album
  end

  def format_query(record)
    "track:#{record.name} artist:#{record.artist} album:#{record.album}"
  end

  def client
    Spotify::Client.new
  end

end

class CollectionRecord
  def initialize(row)
    @row = row
  end

  def name
    @row['Name']
  end

  def artist
    @row['Artist']
  end

  def album
    @row['Album']
  end

end

class SpotifyMatch
  def initialize(results)
    @results = results
  end

  def found_match?
    @results['tracks']['items'].count > 0
  end

  def name
    @results["tracks"]["items"].first["name"]
  end

  def artist
    @results["tracks"]['items'].first['artists'].first['name']
  end

  def album
    @results["tracks"]['items'].first['album']['name']
  end

  def uri
    @results ["tracks"]["items"].first["uri"]
  end

  def to_s
    "#{name} - #{album} - #{artist} = #{uri}"
  end
end
