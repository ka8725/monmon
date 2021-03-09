require 'pg'
require './lib/monmon'
require './lib/configuration'

def redirect
  [302, {'Location' => "/"}, []]
end 

def convert_keys(table)
  table.map { |row| row.transform_keys { |key| key.to_sym rescue key } }
end

conn = PG::Connection.open(ENV["DATABASE_URL"])
table = convert_keys(conn.exec('SELECT * from accounts'))

app = -> (env) do
  if env["REQUEST_METHOD"] == "GET"
    case env["REQUEST_PATH"]
    when "/"
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
    when "/accounts/new"
      currencys = SUPPORTED_CURRENCIES.map do |i|
        "<option value =\"#{i}\">#{i}</option>"
      end
      body = "<form action=\"/accounts\" method=\"POST\">
      <fieldset>
      <center>
      <table>
          <caption><b>Create accounts</b></caption>
          <tr>
              <th>Type</th>
              <th>Name</th>
              <th>Currency</th>
              <th>Amount</th>
          </tr>
          <tr>
              <td><input type=\"text\" name=\"type\" placeholder=\"Type\" required></td>
              <td><input type=\"text\" name=\"name\" placeholder=\"Name\" required></td>
              <td>
                <select name =\"currency\">
                  #{currencys.join}
                </select>
              </td>
              <td><input type=\"number\" name=\"amount\" placeholder=\"Amount\" min=\"1\" required></td>
          </tr>
      </table>
      <button>Save</button>
      </table>
      </center>
      </fieldset>      
      </form>"
      [ 200, { "Content-Type" => "text/html" }, [body] ]
    else
      [ 404, { "Content-Type" => "text/html" }, ["<h1>404 Not Found</h1>"] ]
    end
  elsif env["REQUEST_METHOD"] == "POST"
    req = Rack::Request.new(env)
    case env["REQUEST_PATH"]
    when "/accounts"
      conn.exec("INSERT INTO accounts(type, name, currency, amount) VALUES ('#{req.POST["type"]}', '#{req.POST["name"]}', '#{req.POST["currency"]}', '#{req.POST["amount"].to_i}')")
      redirect
      [ 200, { "Content-Type" => "text/html" }, [""] ]
    else
      [ 404, { "Content-Type" => "text/html" }, ["<h1>404 Not Found</h1>"] ]
    end  
  end
end

run app
