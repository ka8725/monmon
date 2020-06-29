require 'minitest/autorun'
load 'monmon.rb'

class TetsMonmon < MiniTest::Test
  def test_process
    table = [{:type=>"CC", :name=>"Alfa-bank CC", :currency=>"BYN", :amount=>"500"},
    {:type=>"CC", :name=>"MyBank CC", :currency=>"USD", :amount=>"600"},
    {:type=>"Cash", :name=>"In the car", :currency=>"EUR", :amount=>"200"},
    {:type=>"Cash", :name=>"At home", :currency=>"RUR", :amount=>"1000"},
    {:type=>"Cash", :name=>"At home", :currency=>"UAH", :amount=>"1000"},
    {:type=>"Bank account", :name=>"Paritet Bank", :currency=>"BYN", :amount=>"2000"},
    {:type=>"Deposit account", :name=>"Priorbank", :currency=>"BYN", :amount=>"4000"}]

    rates =  { BYN: { USD: 0.4081, RUR: 30.1132, EUR: 0.3727 , BYN: 1 },
      USD: { BYN: 2.4506, RUR: 73.7932, EUR: 0.9133, USD: 1 },
      RUR: { BYN: 0.0332, EUR: 0.0124, USD: 0.0136, RUR: 1 },
      EUR: { BYN: 2.6832, RUR:80.7974, USD: 1.0949, EUR: 1 }}

    main_currency = :BYN
    not_supported = {:UAH=>1000}
    balance = {:BYN=>6500, :USD=>600, :EUR=>200, :RUR=>1000}

    result =  process(table, balance,not_supported,rates, main_currency)
    assert_equal 6500, result[:BYN]
  end
end
