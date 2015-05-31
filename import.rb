#! /usr/bin/env ruby

require 'csv'
require 'optparse'
require 'spotify-client'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: import.rb [options]"

  opts.on("-f", "--file FILENAME", "The filename to import") do |filename|
    options[:filename] = filename
  end

end.parse!

def format_query(row)
  "track:#{row["Name"]} artist:#{row["Artist"]} album:#{row["Album"]}"
end

# results = client.search(:track, 'track:21 Guns artist:Green Day album:21st Century Breakdown')
# results ["tracks"]["items"].first["name"]
def client
  Spotify::Client.new
end

collection = CSV.read(options[:filename], :headers => true)

collection.each_with_index do |row, index|
  puts "[#{index}] #{format_query(row)}"
  # require 'pry' ; binding.pry
  results = client.search(:track, format_query(row))
  if results['tracks']['items'].count > 0
    puts "#{results["tracks"]["items"].first["name"]} - #{results ["tracks"]["items"].first["uri"]}"
  else
    puts 'not found'
  end
  # require 'pry' ; binding.pry
end

