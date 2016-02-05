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



=begin
words.execute "CREATE TABLE IF NOT EXISTS Verbs(Entry STRING PRIMARY KEY,
                                                Case STRING, Preposition STRING,
                                                Separable STRING, Forms STRING,
                                                Transitive STRING,
                                                Meaning STRING, Examples STRING"
words.execute 'INSERT INTO Verbs VALUES("anschauen", "akk", "-", "yes", "regular", "yes",
                                        "поглеждам, look at\nsich (Dat) etw (Akk) ~ - take a look at sth",
                                        "Shau dir das an!")'




words.execute "CREATE TABLE IF NOT EXISTS Adjectives(Entry STRING PRIMARY KEY,
                                                     Comparative STRING, Superlative STRING,
                                                     Meaning STRING, Examples STRING)"
words.execute 'INSERT INTO Adjectives VALUES("schön", "schöner", "am schönsten",
                                             "beautiful, handsome, lovely, great",
                                             "Schön, dass du dabei bist")'
words.execute 'INSERT INTO Adjectives VALUES("kalt", "kälter", "am kältesten",
                                             "cold",
                                             "kalt duschen - взимам студен душ")'

=end