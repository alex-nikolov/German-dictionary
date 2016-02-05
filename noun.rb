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

    def add_entry
      words = SQLite3::Database.open 'words.db'
      words.execute 'INSERT INTO Nouns VALUES(#{entry},
                                              #{gender},
                                              #{plural},
                                              #{genetive},
                                              #{meaning},
                                              #{examples})'

      words.close if words
    end
  end
end