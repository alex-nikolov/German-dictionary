require_relative 'word'

module German
  class Adjective < Word
    attr_reader :comparative, :superlative

    def initialize(database_hash)
      super

      @comparative = database_hash['Comparative']
      @superlative = database_hash['Superlative']
    end

    def add_entry(database)
      words = SQLite3::Database.open(database)
      words.execute "INSERT INTO Adjectives VALUES('#{@entry}',
                                                   '#{@comparative}',
                                                   '#{@superlative}',
                                                   '#{@meaning}',
                                                   '#{@examples}')"
      words.close if words
    end

    def to_s
      "Entry: #{@entry}\nComparative: #{@comparative}\n" +
        "Superlative: #{@superlative}\nMeaning: #{@meaning}\n" +
          "Examples: #{examples}"
    end

    def fields
      ['Entry', 'Comparative', 'Superlative', 'Meaning', 'Examples']
    end
  end
end