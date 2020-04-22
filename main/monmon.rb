require 'csv'
require 'optparse'

options = {file: "input.csv"}
OptionParser.new do |opts|
  opts.banner = "Monmon can calculate the sum of all income and a certain currency.\nUsage:   monmon.rb [options]:"
  opts.on("-f name", "--file=name", "Input file in CSV format") do |v|
    options[:file] = v
  end
  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

balance = Hash.new(0)
not_supported = Hash.new(0)
SUPPORTED_CURRENCIES = %w[BYN USD RUR EUR].freeze
rates = { BYN: { USD: 0.4081, RUR: 30.1132, EUR: 0.3727 , BYN: 1 },
        USD: { BYN: 2.4506, RUR: 73.7932, EUR: 0.9133, USD: 1},
        RUR: { BYN: 0.0332, EUR: 0.0124, USD: 0.0136, RUR: 1 },
        EUR: { BYN: 2.6832, RUR:80.7974, USD: 1.0949, EUR: 1 }
        }
main_currency = :BYN
total = 0

CSV.foreach(options[:file], headers: true, header_converters: :symbol) do |row|
  puts("#{row[:type]}: #{row[:name]}:  #{row[:currency]}\t - #{row[:amount]}  #{row[:currency]}")
  if SUPPORTED_CURRENCIES.include?(row[:currency])
    balance[row[:currency].to_sym] += row[:amount].to_i
  else
    not_supported[row[:currency].to_sym] += row[:amount].to_i
  end
end

balance.each do |key, val|
  total += val * rates[key][main_currency]
end

puts('-----------------------------------------')
balance.each do |key, val|
  puts "#{key} \t #{val}"
end
not_supported.each do |key, val|
  puts "#{key} \t Not supported currency!"
end

puts('-----------------------------------------')
puts("Total in main currency: #{total.round} #{main_currency}")
