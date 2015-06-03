#! /usr/bin/env ruby

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'optparse'
require 'spotify_importer'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: import.rb [options]"

  opts.on("-f", "--file FILENAME", "The filename to import") do |filename|
    options[:filename] = filename
  end

  opts.on("-m", "--missing MISSING.json", "The output filename of bad matches") do |missing|
    options[:missing] = missing
  end

  opts.on("-l", "--limit LIMIT", "Limit the number of lines to import") do |limit|
    options[:limit] = limit.to_i
  end

  opts.on("-s", "--skip SKIP", "Skip the first X lines of import") do |skip|
    options[:skip] = skip.to_i
  end

end.parse!

importer = SpotifyImporter.new
importer.import(options[:filename], options)

if options[:missing]
  File.open(options[:missing], 'w') do |f|
    puts "Writing to file #{options[:missing]}"
    f.write(JSON.pretty_generate(importer.missing))
  end
end
