require 'word.rb'

module German
  class Noun < Word
    def initialize(description)
      @description = description
    end
  end
end