require 'csv'
params = ARGV[1]
balance = Hash.new(0)
not_supported = Hash.new(0)
SUPPORTED_CURRENCIES = %w[BYN USD RUR EUR].freeze

CSV.foreach(params, headers: true, header_converters: :symbol) do |row|
  puts("#{row[:type]}: #{row[:name]}:  #{row[:currency]}\t - #{row[:amount]}  #{row[:currency]}")
  if SUPPORTED_CURRENCIES.include?(row[:currency])
    balance[row[:currency].to_sym] += row[:amount].to_i
  else
    not_supported[row[:currency].to_sym] += row[:amount].to_i
  end
end

puts('-----------------------------------------')
balance.each do |key, val|
  puts "#{key} \t #{val}"
end
not_supported.each do |key, val|
  puts "#{key} \t Not supported currency!"
end
