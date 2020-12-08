require 'monmon'
require 'pg'

def convert_keys(table)
  table.map { |row| row.transform_keys { |key| key.to_sym rescue key } }
end

table =[]
options = {file: 'input.csv'}
config = Configuration.instance
OptionParser.new do |opts|
  opts.banner = 'Monmon can calculate the sum of all income and a certain currency. Usage:   monmon.rb [options]:'
  opts.on('-f name', '--file=name', 'Input file in CSV format') do |v|
    if File.exist?(v)
      options[:file] = v
    else
      abort "File is missing: #{v}"
    end
  end
  opts.on('-h', '--help', 'Prints this help') do
    puts opts
    exit
  end
  opts.on('-a name', '--adapter=name', 'Run with datadase or CSV') do |v|
    case v
      when 'DB'
          conn = PG::Connection.open(ENV["DATABASE_URL"])
          table = convert_keys(conn.exec('SELECT * from accounts'))
      when 'CSV'
          if File.exist?(options[:file])
            i = 0
            CSV.foreach(options[:file], headers: true, header_converters: :symbol) do |row|
              table[i] = {type: row[:type], name: row[:name], currency: row[:currency], amount: row[:amount]}
              i +=1
            end
          else
            abort 'No such file: ' + options[:file]
          end
      else
        abort "Parameter usage error!\n Use \"./bin/cli -a DB\" to run with database\n Use \"./bin/cli -a CSV\" to run with CSV file"
      end
  end
  opts.on('-m name', '--main_currency=name', 'Change main currency') do |v|
    if SUPPORTED_CURRENCIES.include?(v)
      config.main_currency = v.to_sym
    else
      abort "Currency not supported. Choose supportes currency #{SUPPORTED_CURRENCIES.inspect}"
    end
  end
end.parse!

result = process(table, config.main_currency)
print(result)
