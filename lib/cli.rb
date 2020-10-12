require 'monmon'
require 'pg'

def convert_keys(table)
  table.map { |row| row.transform_keys { |key| key.to_sym rescue key } }
end

main_currency = :BYN
table = []

options = {file: 'input.csv'}
OptionParser.new do |opts|
  opts.banner = 'Monmon can calculate the sum of all income and a certain currency.'+"\n"+'Usage:   monmon.rb [options]:'
  opts.on('-f name', '--file=name', 'Input file in CSV format') do |v|
    options[:file] = v
  end
  opts.on('-h', '--help', 'Prints this help') do
    puts opts
    exit
  end
  opts.on('-a name', '--adapter=name', 'Run with datadase or CSV') do |v|
    if v == 'DB'
      conn = PG::Connection.open( dbname: 'monmon', user: 'postgres')
      table = convert_keys(conn.exec('SELECT * from accounts'))
    elsif v == 'CSV'
      i = 0
      CSV.foreach(options[:file], headers: true, header_converters: :symbol) do |row|
        table[i] = {type: row[:type], name: row[:name], currency: row[:currency], amount: row[:amount]}
        i = i+1
      end
    else
      abort 'Parameter usage error!'+"\n"+'Use "./bin/cli -a DB" to run with database'+"\n"+'Use "./bin/cli -a CSV" to run with CSV file'
    end
  end
end.parse!

result = process(table, main_currency)
print(result)
