require_relative 'word'

module German
  class Noun < Word
    attr_reader :gender, :plural, :genetive

    def initialize(database_hash)
      super

      @gender = database_hash['Gender']
      @plural = database_hash['Plural']
      @genetive = database_hash['Genetive']
    end

    def add_entry(database)
      words = SQLite3::Database.open(database)
      words.execute "INSERT INTO Nouns VALUES('#{@entry}',
                                              '#{@gender}',
                                              '#{@plural}',
                                              '#{@genetive}',
                                              '#{@meaning}',
                                              '#{@examples}')"
      words.close if words
    end

    def to_s
      "Entry: #{@entry}\nGender: #{@gender}\nPlural: #{@plural}\n" + 
        "Genetive: #{genetive}\nMeaning: #{@meaning}\nExamples: #{examples}"
    end
  end
end