require 'io/console'

require_relative 'dictionary'

module German
  class ConsoleInterface
    def initialize(database)
      @dictionary = Dictionary.new(database)
    end
  end
end