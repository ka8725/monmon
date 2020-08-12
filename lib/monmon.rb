require 'csv'
require 'optparse'
require 'net/http'
require 'json'

url = "https://api.exchangerate.host/latest?base=BYN"
uri = URI(url)
response = Net::HTTP.get(uri)
RATES = JSON.parse(response)

SUPPORTED_CURRENCIES = %w[BYN USD RUB EUR].freeze
=begin
RATES = {
  BYN: { USD: 0.4081, RUR: 30.1132, EUR: 0.3727 , BYN: 1 },
  USD: { BYN: 2.4506, RUR: 73.7932, EUR: 0.9133, USD: 1},
  RUR: { BYN: 0.0332, EUR: 0.0124, USD: 0.0136, RUR: 1 },
  EUR: { BYN: 2.6832, RUR:80.7974, USD: 1.0949, EUR: 1 }
}
=end
def process(table)
  result = Hash.new(0)
  result[:currencies] = Hash.new(0)
  not_supported = Hash.new(0)
  balance = Hash.new(0)
  total = 0
  table.each do |t|
  if SUPPORTED_CURRENCIES.include?(t[:currency])
      balance[t[:currency].to_sym] += t[:amount].to_i
      result[:currencies][t[:currency].to_sym] += t[:amount].to_i
    else
      not_supported[t[:currency].to_sym] += t[:amount].to_i
      result[:currencies][t[:currency].to_sym] = 'Not supported currency!'
    end
  end
  balance.each do |key, val|
    #puts "val #{val.class} / #{RATES["rates"][key].class}"
    total += val / RATES["rates"][key]
  end
  result[:total] = total
  result[:not_supported] = not_supported
  result
end

def print(result)
  # TODO: print not supported
  puts('-----------------------------------------')
  result[:currencies].each do |key, val|
    if key != :total
      puts "#{key} \t #{val}"
    end
  end
  puts('-----------------------------------------')
  puts("Total in main currency: #{result[:total]} #{RATES["base"]}")
  puts('-----------------------------------------')
end
