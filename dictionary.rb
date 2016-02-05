require 'io/console'
require 'sqlite3'

require_relative 'noun'
require_relative 'verb'
require_relative 'adjective'

module German
  class Dictionary
    def extract_entry(word)
      words = SQLite3::Database.open 'words.db'
      words.results_as_hash = true

      databases_found = locate_database_for_entry(words, word)

      handle_database_cases(words, word, databases_found)
    end

    def add_entry(word)
      word.add_entry
    end

    private

    def handle_database_cases(words, word, databases_found)
      raise 'Entry not found' if databases_found.length == 0
      raise 'Multiple entries found' if databases_found.length > 1

      extract_entry_from_concrete_database(words, word, databases_found)
    end

    def locate_database_for_entry(words, word)
      ['Nouns', 'Verbs', 'Adjectives'].keep_if do |database|
        words.execute("SELECT 1 FROM #{database}
                       WHERE Entry = '#{word}'").length > 0
      end
    end

    def extract_entry_from_concrete_database(words, word, databases_found)
      statement = words.prepare "SELECT * FROM #{databases_found[0]}
                                 WHERE Entry = '#{word}'"
      run_statement = statement.execute.next

      close_database(words, statement)

      case databases_found[0]
        when 'Nouns' then Noun.new(run_statement)
        when 'Verbs' then Verb.new(run_statement)
        when 'Adjectives' then Adjective.new(run_statement)
      end
    end

    def close_database(database, statement)
      statement.close if statement
      database.close if database
    end
  end
end

# rspec spec.rb --require ./dictionary.rb --colour --format documentation