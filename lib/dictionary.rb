require 'sqlite3'

require_relative 'noun'
require_relative 'verb'
require_relative 'adjective'

module German
  class DictionaryError < StandardError
  end

  class Dictionary
    attr_reader :database

    def initialize(database)
      @database = database
    end

    def extract_entry(word)
      words = SQLite3::Database.open @database
      databases_found = locate_database_for_entry(words, word)

      check_if_one_database_found(databases_found)

      words.results_as_hash = true

      extract_entry_from_concrete_database(words, word, databases_found[0])
    end

    def add_entry(word)
      word.add_entry(@database)
    end

    def exists_entry?(word)
      words = SQLite3::Database.open @database
      databases_found = locate_database_for_entry(words, word)

      words.close if words

      not databases_found.empty?
    end

    def delete_entry(word)
      words = SQLite3::Database.open @database
      databases_found = locate_database_for_entry(words, word)

      check_if_one_database_found(databases_found)

      words.execute "DELETE FROM #{databases_found[0]} WHERE Entry = '#{word}'"
    end

    def extract_entries_with_meaning(meaning)
      words = SQLite3::Database.open @database
      words.results_as_hash = true
      statements = statements_for_each_database(words, meaning)

      similar_meaning_words = extract_words_with_similar_meaning(statements)

      statements.each { |statement| statement.close if statement }
      words.close if words

      similar_meaning_words
    end

    def edit_entry(entry, field, new_value)
      @words = SQLite3::Database.open @database

      found = locate_database_for_entry(@words, entry)

      check_if_one_database_found(found)
      unless table_columns(@words, found[0]).include? field
        raise DictionaryError, 'Invalid field'
      end

      statement = update_field_statement(found, entry, field, new_value)
      close_database(@words, statement)
    end

    private

    def check_if_one_database_found(databases_found)
      raise DictionaryError, 'Entry not found' if databases_found.length == 0

      if databases_found.length > 1
        raise DictionaryError, 'Multiple entries found'
      end
    end

    def locate_database_for_entry(words, word)
      ['Nouns', 'Verbs', 'Adjectives'].keep_if do |database|
        words.execute("SELECT * FROM #{database}
                       WHERE Entry = '#{word}'").length > 0
      end
    end

    def statements_for_each_database(words, meaning)
      ['Nouns', 'Verbs', 'Adjectives'].map do |database|
        statement = words.prepare "SELECT * FROM #{database}
                                   WHERE Meaning LIKE '% #{meaning} %'
                                      OR Meaning LIKE '% #{meaning},%'
                                      OR Meaning LIKE '%#{meaning}'
                                      OR Meaning LIKE '%#{meaning},%'"
        statement.execute
      end
    end

    def update_field_statement(found, entry, field, new_value)
      statement = @words.prepare "UPDATE #{found[0]}
                                  SET #{field} = '#{new_value}'
                                  WHERE Entry = '#{entry}'"
      statement.execute
    end

    def table_columns(database, table_name)
      statement = database.prepare "SELECT * FROM #{table_name} LIMIT 1"

      columns = statement.columns
      statement.close if statement
      columns
    end

    def extract_entry_from_concrete_database(words, word, database_found)
      statement = words.prepare "SELECT * FROM #{database_found}
                                 WHERE Entry = '#{word}'"
      run_statement = statement.execute.next

      close_database(words, statement)

      case database_found
        when 'Nouns' then Noun.new(run_statement)
        when 'Verbs' then Verb.new(run_statement)
        when 'Adjectives' then Adjective.new(run_statement)
      end
    end

    def close_database(database, statement)
      statement.close if statement
      database.close if database
    end

    def extract_words_with_similar_meaning(statements)
      words_containing_meaning = []
      statements_with_word = statements.zip(['Noun', 'Verb', 'Adjective'])

      statements_with_word.each do |pair|
        current_class = Object.const_get('German::' + pair.last)
        pair.first.each do |run_statement|
          words_containing_meaning << current_class.new(run_statement)
        end
      end

      words_containing_meaning
    end
  end
end

# rspec spec.rb --require ./dictionary.rb --colour --format documentation