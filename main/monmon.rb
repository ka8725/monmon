require 'csv'

totalBYN = 0
totalUSD = 0
totalEUR = 0

CSV.foreach("input.csv", headers: true) do |row|
  puts("#{row['Type']}: #{row['Name']}:  #{row['Currency']}\t - #{row['Amount']}  #{row['Currency']}")
  case row['Currency']
  when "BYN"
    totalBYN += row['Amount'].to_i
  when "EUR"
    totalUSD += row['Amount'].to_i
  when "USD"
    totalEUR += row['Amount'].to_i
  end
end

puts("--------------------------------------------------")
puts ("Total BYN"+"\t"+totalBYN.to_s)
puts ("Total USD"+"\t"+totalUSD.to_s)
puts ("Total EUR"+"\t"+totalEUR.to_s)
