require 'csv'

balance = Hash.new

CSV.foreach("input.csv", headers: true) do |row|
  puts("#{row['Type']}: #{row['Name']}:  #{row['Currency']}\t - #{row['Amount']}  #{row['Currency']}")
  if balance.include?(row['Currency'])
    balance[row['Currency']] += row['Amount'].to_i
  else
    balance[row['Currency']] = row['Amount'].to_i
  end
end
puts('-----------------------------------------')
balance.each do |key, val|
  puts "#{key} \t #{val}"
end
