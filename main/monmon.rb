require 'csv'
require 'optparse'
require 'minitest/autorun'

#TEST
#------------------------------------
class TetsMonmon < MiniTest::Test
  def test_process
    table = [{:type=>"CC", :name=>"Alfa-bank CC", :currency=>"BYN", :amount=>"500"},
    {:type=>"CC", :name=>"MyBank CC", :currency=>"USD", :amount=>"600"},
    {:type=>"Cash", :name=>"In the car", :currency=>"EUR", :amount=>"200"},
    {:type=>"Cash", :name=>"At home", :currency=>"RUR", :amount=>"1000"},
    {:type=>"Cash", :name=>"At home", :currency=>"UAH", :amount=>"1000"},
    {:type=>"Bank account", :name=>"Paritet Bank", :currency=>"BYN", :amount=>"2000"},
    {:type=>"Deposit account", :name=>"Priorbank", :currency=>"BYN", :amount=>"4000"}]

    rates =  { BYN: { USD: 0.4081, RUR: 30.1132, EUR: 0.3727 , BYN: 1 },
      USD: { BYN: 2.4506, RUR: 73.7932, EUR: 0.9133, USD: 1 },
      RUR: { BYN: 0.0332, EUR: 0.0124, USD: 0.0136, RUR: 1 },
      EUR: { BYN: 2.6832, RUR:80.7974, USD: 1.0949, EUR: 1 }}

    main_currency = :BYN
    not_supported = {:UAH=>1000}
    balance = {:BYN=>6500, :USD=>600, :EUR=>200, :RUR=>1000}

    result =  process(table, balance,not_supported,rates, main_currency)
    asert_equal 6500, result[:BYN]
  end
end
#------------------------------------

# FUNCTION --------------------------
def process(table, balance,not_supported,rates, main_currency)
  result = Hash.new(0)
  total = 0
  table.each do |t|
  if SUPPORTED_CURRENCIES.include?(t[:currency])
      balance[t[:currency].to_sym] += t[:amount].to_i
      result[t[:currency].to_sym] += t[:amount].to_i
    else
      not_supported[t[:currency].to_sym] += t[:amount].to_i
      result[t[:currency].to_sym] = "Not supported currency!"
    end
  end
  balance.each do |key, val|
    total += val * rates[key][main_currency]
  end
  result[:total] = total
  return result
end

def print(result, main_currency)
  puts('-----------------------------------------')
  result.each do |key, val|
    if key != :total
      puts "#{key} \t #{val}"
    end
  end
  puts('-----------------------------------------')
  puts("Total in main currency: #{result[:total]} #{main_currency}")
  puts('-----------------------------------------')
end
 #------------------------------------


options = {file: "input.csv"}
OptionParser.new do |opts|
  opts.banner = "Monmon can calculate the sum of all income and a certain currency.\nUsage:   monmon.rb [options]:"
  opts.on("-f name", "--file=name", "Input file in CSV format") do |v|
    options[:file] = v
  end
  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

balance = Hash.new(0)
result = Hash.new(0)
not_supported = Hash.new(0)
SUPPORTED_CURRENCIES = %w[BYN USD RUR EUR].freeze
rates = { BYN: { USD: 0.4081, RUR: 30.1132, EUR: 0.3727 , BYN: 1 },
USD: { BYN: 2.4506, RUR: 73.7932, EUR: 0.9133, USD: 1},
RUR: { BYN: 0.0332, EUR: 0.0124, USD: 0.0136, RUR: 1 },
EUR: { BYN: 2.6832, RUR:80.7974, USD: 1.0949, EUR: 1 }
}
main_currency = :BYN
table = Array.new
i = 0
CSV.foreach(options[:file], headers: true, header_converters: :symbol) do |row|
    puts("#{row[:type]}: #{row[:name]}:  #{row[:currency]}\t - #{row[:amount]}  #{row[:currency]}")
    table[i] = {type: row[:type], name: row[:name], currency: row[:currency], amount: row[:amount]}
    i = i+1
end

result = process(table, balance,not_supported,rates,main_currency)
print(result, main_currency)
