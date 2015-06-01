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


end.parse!

SpotifyImporter.new.import(options[:filename])
