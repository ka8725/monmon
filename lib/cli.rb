require 'monmon'

options = {file: 'input.csv'}
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

main_currency = :BYN
table = Array.new
i = 0
CSV.foreach(options[:file], headers: true, header_converters: :symbol) do |row|
  puts("#{row[:type]}: #{row[:name]}:  #{row[:currency]}\t - #{row[:amount]}  #{row[:currency]}")
  table[i] = {type: row[:type], name: row[:name], currency: row[:currency], amount: row[:amount]}
  i = i+1
end

result = process(table)
print(result)
