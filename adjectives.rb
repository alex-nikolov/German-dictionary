require_relative 'word'

module German
  class Adjective < Word
    attr_reader :comparative, :superlative

    def initialize(database_hash)
      super

      @comparative = database_hash['Comparative']
      @superlative = database_hash['Superlative']
    end
  end
end