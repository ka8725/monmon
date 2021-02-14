require 'pg'
require './lib/monmon'
require './lib/configuration'

def redirect
  [302, {'Location' => "/"}, []]
end 

def convert_keys(table)
  table.map { |row| row.transform_keys { |key| key.to_sym rescue key } }
end

def is_digit?(value)
  val = value.split(//)
  val.each do |item|
    code = item.ord
    if 48 <= code && code <= 57 == false
      return false
    end
  end
end

def validation(input)
  flag = true
  if not SUPPORTED_CURRENCIES.include?(input["currency"])
    flag = false
  end

  if input["type"].length == 0  || input["name"].length == 0
    flag = false
  end

  if not is_digit?(input["amount"])
    flag = false
  end
  flag
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
      body = "<form action=\"/accounts\" method=\"POST\">
      <table>
          <caption><b>Create accounts</b></caption>
          <tr>
              <th>Type</th>
              <th>Name</th>
              <th>Currency</th>
              <th>Amount</th>
          </tr>
          <tr>
              <td><input type=\"text\" name=\"type\" placeholder=\"Type\"></td>
              <td><input type=\"text\" name=\"name\" placeholder=\"Name\"></td>
              <td><input type=\"text\" name=\"currency\" placeholder=\"Currency\"></td>
              <td><input type=\"text\" name=\"amount\" placeholder=\"Amount\"></td>
          </tr>
      </table>
      <button>Save</button>
      </table>      
      </form>"
      [ 200, { "Content-Type" => "text/html" }, [body] ]
    else
      [ 404, { "Content-Type" => "text/html" }, ["<h1>404 Not Found</h1>"] ]
    end
  elsif env["REQUEST_METHOD"] == "POST"
    req = Rack::Request.new(env)
    case env["REQUEST_PATH"]
    when "/accounts"
      if validation(req.POST)
        conn.exec("INSERT INTO accounts(type, name, currency, amount) VALUES ('#{req.POST["type"]}', '#{req.POST["name"]}', '#{req.POST["currency"]}', '#{req.POST["amount"].to_i}')")
        redirect
      else
        abort "Filling Error"
      end
      [ 200, { "Content-Type" => "text/html" }, [""] ]
    else
      [ 404, { "Content-Type" => "text/html" }, ["<h1>404 Not Found</h1>"] ]
    end  
  end
end

run app
