require 'csv'

CSV.foreach("input.csv", headers: true) do |row|
  puts("#{row['Type']}: #{row['Name']}:  #{row['Currency']}\t - #{row['Amount']}  #{row['Currency']}")
end

totalBYN = 0
totalUSD = 0
totalEUR = 0
table = CSV.parse(File.read("input.csv"), headers: true)
for currency in 0..5
  case table[currency][2].strip()
  when "BYN"
    totalBYN += table[currency][3].to_i
  when "EUR"
    totalUSD += table[currency][3].to_i
  when "USD"
    totalEUR += table[currency][3].to_i
  end
end
puts("--------------------------------------------------")
puts ("Total BYN"+"\t"+totalBYN.to_s)
puts ("Total USD"+"\t"+totalUSD.to_s)
puts ("Total EUR"+"\t"+totalEUR.to_s)
