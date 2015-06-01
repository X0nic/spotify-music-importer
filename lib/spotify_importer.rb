require 'colorize'
require 'csv'
require 'spotify-client'

class SpotifyImporter
  def import(filename)
    collection = CSV.read(filename, :headers => true)

    collection.each_with_index do |row, index|
      results = client.search(:track, format_query(row))

      if results['tracks']['items'].count > 0
        info = "#{results["tracks"]["items"].first["name"]} - #{results ["tracks"]["items"].first["uri"]}"

        if full_match(results, row)
          puts info.green
        elsif name_match(results, row)
          puts info.yellow
        elsif album_match(results, row)
          puts info.colorize(:orange)
        else
          puts info
        end
      else
        puts "not found - #{row["Name"]} - #{row["Artist"]}".red
      end

    end
  end

  def full_match(results, row)
    name_match(results, row) && album_match(results, row)
  end

  def name_match(results, row)
    results["tracks"]["items"].first["name"] == row["Name"]
  end

  def album_match(results, row)
    # require 'pry' ; binding.pry
    results["tracks"]["items"].first["album"]["name"] == row["Album"]
  end

  def format_query(row)
    "track:#{row["Name"]} artist:#{row["Artist"]} album:#{row["Album"]}"
  end

  def client
    Spotify::Client.new
  end

end
