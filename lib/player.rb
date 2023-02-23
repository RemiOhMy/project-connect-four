# frozen-string-literal: true

require_relative 'display'

# Class Player to hold player information
class Player
  attr_accessor :name, :token
  
  def initialize(name, token)
    @name = name
    @token = token
  end
end
