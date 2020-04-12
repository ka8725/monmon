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
rates = { BYN: { USD: 2.4704, RUR: 0.0335, EUR: 2.7043 , BYN: 1 },
        USD: { BYN: 0.4048, RUR:0.0136, EUR: 1.0947, USD: 1},
        RUR: { BYN: 29.8541, RUR: 1, EUR: 80.7358, USD: 73.7515 },
        EUR: { BYN: 0.3698, RUR: 0.0124, EUR: 1, USD: 0.9135 }
        }
main_currency = :USD
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
  total += val * rates[main_currency][key]
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
