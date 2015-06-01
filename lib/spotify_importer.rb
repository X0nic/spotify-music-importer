require 'colorize'
require 'csv'
require 'spotify-client'

class SpotifyImporter
  def import(filename)
    collection = CSV.read(filename, :headers => true)

    collection.each_with_index do |row, index|
      record = CollectionRecord.new(row)
      results = client.search(:track, format_query(record))

      if results['tracks']['items'].count > 0
        info = "#{results["tracks"]["items"].first["name"]} - #{results["tracks"]['items'].first['artist'['name']]} - #{results ["tracks"]["items"].first["uri"]}"

        if full_match(results, record)
          puts info.green
        elsif name_match(results, record)
          puts info.yellow
        elsif album_match(results, record)
          puts info.colorize(:orange)
        else
          puts info
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
    results["tracks"]["items"].first["name"] == record.name
  end

  def album_match(results, record)
    # require 'pry' ; binding.pry
    results["tracks"]["items"].first["album"]["name"] == record.album
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
