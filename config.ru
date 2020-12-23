require 'pg'

def convert_keys(table)
  table.map { |row| row.transform_keys { |key| key.to_sym rescue key } }
end

conn = PG::Connection.open(ENV["DATABASE_URL"])
table = convert_keys(conn.exec('SELECT * from accounts'))

app = -> (env) do
  status = "<h1> Status account</h1>
    <table>
        <tr>
          <th>Type</th>
          <th>Name</th>
          <th>Currency</th>
          <th>Amount</th>
        </tr>
        <tr>
          <td>#{table[0][:type]}</td>
          <td>#{table[0][:name]}</td>
          <td>#{table[0][:currency]}</td>
          <td>#{table[0][:amount]}</td>
        </tr>
        <tr>
          <td>#{table[1][:type]}</td>
          <td>#{table[1][:name]}</td>
          <td>#{table[1][:currency]}</td>
          <td>#{table[1][:amount]}</td>
        </tr>
        <tr>
          <td>#{table[2][:type]}</td>
          <td>#{table[2][:name]}</td>
          <td>#{table[2][:currency]}</td>
          <td>#{table[2][:amount]}</td>
        </tr>
        <tr>
          <td>#{table[3][:type]}</td>
          <td>#{table[3][:name]}</td>
          <td>#{table[3][:currency]}</td>
          <td>#{table[3][:amount]}</td>
        </tr>
        <tr>
          <td>#{table[4][:type]}</td>
          <td>#{table[4][:name]}</td>
          <td>#{table[4][:currency]}</td>
          <td>#{table[4][:amount]}</td>
        </tr>
        <tr>
          <td>#{table[5][:type]}</td>
          <td>#{table[5][:name]}</td>
          <td>#{table[5][:currency]}</td>
          <td>#{table[5][:amount]}</td>
        </tr>
        <tr>
          <td>#{table[6][:type]}</td>
          <td>#{table[6][:name]}</td>
          <td>#{table[6][:currency]}</td>
        <td>#{table[6][:amount]}</td>
      </tr>
  </table>"
  [ 200, { "Content-Type" => "text/html" }, [status] ]
end

run app
