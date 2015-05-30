#! /usr/bin/env ruby

require 'csv'
require 'optparse'


options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: import.rb [options]"

  opts.on("-f", "--file FILENAME", "The filename to import") do |filename|
    options[:filename] = filename
  end

end.parse!

collection = CSV.read(options[:filename], :headers => true)

collection.each_with_index do |row, index|
  puts "[#{index}] #{row.inspect}"
end
