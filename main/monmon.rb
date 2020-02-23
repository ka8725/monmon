require 'csv'

hash = Hash.new

CSV.foreach("input.csv", headers: true) do |row|
  puts("#{row['Type']}: #{row['Name']}:  #{row['Currency']}\t - #{row['Amount']}  #{row['Currency']}")
  if hash.include?(row['Currency'])
    hash[row['Currency']] += row['Amount'].to_i
  else
    hash[row['Currency']] = row['Amount'].to_i
  end
end

hash.each do |key, val|
  puts "#{key} \t #{val}"
end
