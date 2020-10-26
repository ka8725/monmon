class Configuration
  attr_accessor:main_currency

  def initialize
    @main_currency = :BYN
  end

  def self.instance
    @instance
  end

  def main_currency
    @main_currency
  end
  def change_main_currency(currency)
    @main_currency = currency
  end

  @instance = Configuration.new
  private_class_method :new
end
