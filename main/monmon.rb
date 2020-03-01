require 'csv'

balance = Hash.new(0)

CSV.foreach("input.csv", :headers => true, :header_converters => :symbol) do |row|
  puts("#{row[:type]}: #{row[:name]}:  #{row[:currency]}\t - #{row[:amount]}  #{row[:currency]}")
  if balance.include?(row[:currency].to_sym)
    balance[row[:currency].to_sym] += row[:amount].to_i
  else
    balance[row[:currency].to_sym] = row[:amount].to_i
  end

end
puts('-----------------------------------------')
balance.each do |key, val|
  puts "#{key} \t #{val}"
end
