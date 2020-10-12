require 'csv'
require 'optparse'
require 'net/http'
require 'json'

url = "https://api.exchangerate.host/latest?base=BYN"
uri = URI(url)
response = Net::HTTP.get(uri)
RATES = JSON.parse(response)
SUPPORTED_CURRENCIES = %w[BYN USD RUB EUR].freeze

def process(table, main_currency)
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
    total += val / RATES["rates"].fetch(key.to_s)
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
  puts("Total in main currency: #{result[:total].round(2)} #{RATES["base"]}")
  puts('-----------------------------------------')
end
