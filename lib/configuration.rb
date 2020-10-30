require 'singleton'

class Configuration
  include Singleton
  attr_accessor:main_currency
  def initialize
    @main_currency = :BYN
  end
end
