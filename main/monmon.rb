require 'csv'

balance = Hash.new(0)
support_currency = ['BYN', 'USD', 'RUR', 'EUR']

CSV.foreach('input.csv', headers: true, header_converters: :symbol) do |row|
  puts("#{row[:type]}: #{row[:name]}:  #{row[:currency]}\t - #{row[:amount]}  #{row[:currency]}")
  balance[row[:currency].to_sym] += row[:amount].to_i
end

puts('-----------------------------------------')
balance.each do |key, val|
  if support_currency.include?(key.to_s)
    puts "#{key} \t #{val}"
  else
    puts "#{key} \t Not supported currency!"
  end
end
