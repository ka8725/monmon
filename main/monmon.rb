require 'csv'

balance = Hash.new(0)
not_sup = Hash.new(0)
CURRENCY = %w[BYN USD RUR EUR]

CSV.foreach('input.csv', headers: true, header_converters: :symbol) do |row|
  puts("#{row[:type]}: #{row[:name]}:  #{row[:currency]}\t - #{row[:amount]}  #{row[:currency]}")
  if CURRENCY.include?(row[:currency])
    balance[row[:currency].to_sym] += row[:amount].to_i
  else
    not_sup[row[:currency].to_sym] += row[:amount].to_i
  end
end

puts('-----------------------------------------')
balance.each do |key, val|
  puts "#{key} \t #{val}"
end
not_sup.each do |key, val|
  puts "#{key} \t Not supported currency!"
end
