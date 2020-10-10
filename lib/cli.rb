require 'monmon'
require 'pg'

def convert_keys(table)
  result = Array.new
  table.each do |row|
     result << row.transform_keys {|key| key.to_sym rescue key}
  end
  result
end

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

conn = PG::Connection.open( dbname: 'monmon', user: 'postgres')
table = convert_keys(conn.exec("SELECT * from accounts"))

result = process(table)
print(result)
