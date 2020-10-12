require 'minitest/autorun'
require 'monmon'

describe '#process' do
  before do
    @table = [
      {type: 'CC', name: 'Alfa-bank CC', currency: 'BYN', amount: '500'},
      {type: 'CC', name: 'MyBank CC', currency: 'USD', amount: '600'},
      {type: 'Cash', name: 'In the car', currency: 'EUR', amount: '200'},
      {type: 'Cash', name: 'At home', currency: 'RUR', amount: '1000'},
      {type: 'Cash', name: 'At home', currency: 'UAH', amount: '1000'},
      {type: 'Bank account', name: 'Paritet Bank', currency: 'BYN', amount: '2000'},
      {type: 'Deposit account', name: 'Priorbank', currency: 'BYN', amount: '4000'}
    ]
    @main_currency = :BYN
  end

  it 'calculates total in main currency' do
    result = process(@table, @main_currency)
    assert_equal 6500, result[:currencies][:BYN]
  end
end
