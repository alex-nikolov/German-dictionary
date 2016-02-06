require_relative 'word'

module German
  class Verb < Word
    attr_reader :forms, :transitive, :case, :preposition, :separable

    def initialize(database_hash)
      super

      @forms = database_hash['Forms']
      @transitive = database_hash['Transitive']
      @case = database_hash['Used_case']
      @preposition = database_hash['Preposition']
      @separable = database_hash['Separable']
    end

    def add_entry(database)
      words = SQLite3::Database.open(database)
      words.execute "INSERT INTO Verbs VALUES('#{@entry}', '#{@case}',
                                              '#{@preposition}',
                                              '#{@separable}',
                                              '#{@forms}',
                                              '#{@transitive}',
                                              '#{@meaning}', '#{@examples}')"
      words.close if words
    end

    def to_s
      "Entry: #{@entry}\nCase: #{@case}\nPreposition: #{@preposition}" +
        "Separable: #{@separable}\nForms: #{@forms}\n" +
          "Transitive: #{@transitive}\nMeaning: #{@meaning}\n" +
            "Examples: #{examples}"
    end
  end
end