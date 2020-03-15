require 'csv'

balance = Hash.new(0)
CURRENCY = %w[BYN USD RUR EUR]

CSV.foreach('input.csv', headers: true, header_converters: :symbol) do |row|
  puts("#{row[:type]}: #{row[:name]}:  #{row[:currency]}\t - #{row[:amount]}  #{row[:currency]}")
  if CURRENCY.include?(row[:currency])
    balance[row[:currency].to_sym] += row[:amount].to_i
  else
    balance[row[:currency].to_sym] = "Not supported currency!"
  end
end

puts('-----------------------------------------')
balance.each do |key, val|
  if CURRENCY.include?(key.to_s)
    puts "#{key} \t #{val}"
  else
    puts "#{key} \t #{val}"
  end
end
