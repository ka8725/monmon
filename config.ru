require 'pg'

def convert_keys(table)
  table.map { |row| row.transform_keys { |key| key.to_sym rescue key } }
end

conn = PG::Connection.open(ENV["DATABASE_URL"])
table = convert_keys(conn.exec('SELECT * from accounts'))

app = -> (env) do
   accounts = table.map do |line|
     tds = line.map { |key, val| "<td>#{val}</td>" }.join
     "<tr>#{tds}</tr>"
   end
   body = "<h1> Status account</h1>
     <table>
         <tr>
           <th>Type</th>
           <th>Name</th>
           <th>Currency</th>
           <th>Amount</th>
         </tr>
         #{accounts.join}
   </table>"
   [ 200, { "Content-Type" => "text/html" }, [body] ]
end

run app