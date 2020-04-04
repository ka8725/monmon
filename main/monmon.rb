require 'csv'
require 'optparse'

options = {file: "input.csv"}
OptionParser.new do |opts|
  opts.on("-f name", "--file=name") do |v|
    options[:file] = v
  end
end.parse!

balance = Hash.new(0)
not_supported = Hash.new(0)
SUPPORTED_CURRENCIES = %w[BYN USD RUR EUR].freeze

rates = {USD: 2.5846, RUR: 0.0336, EUR: 2.7943}
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
  if key==main_currency
    total += val
  else
    total += val * rates[key]
  end
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
