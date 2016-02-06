require 'sqlite3'

require_relative 'noun'
require_relative 'verb'
require_relative 'adjective'

module German
  class Dictionary
    def initialize(database)
      @database = database
    end

    def extract_entry(word)
      words = SQLite3::Database.open @database
      databases_found = locate_database_for_entry(words, word)

      check_if_one_database_found(databases_found)

      words.results_as_hash = true

      extract_entry_from_concrete_database(words, word, databases_found)
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
      #statements[0].each do |run_statement|
      #  words_containing_meaning << Noun.new(run_statement)
      #end

      #statements[1].each do |run_statement|
      #  words_containing_meaning << Verb.new(run_statement)
      #end

      #statements[2].each do |run_statement|
      #  words_containing_meaning << Adjective.new(run_statement)
      #end

      statements.each { |statement| statement.close if statement }
      words.close if words

      similar_meaning_words
    end

    def edit_entry(entry, field, new_value)
      words = SQLite3::Database.open @database
      words.results_as_hash = true

      found = locate_database_for_entry(words, entry)

      check_if_one_database_found(found)
      raise 'Invalid field' unless table_columns(words, found[0]).include? field

      statement = update_field_statement(found, entry, field, new_value, words)
      close_database(words, statement)
    end

    private

    def check_if_one_database_found(databases_found)
      raise 'Entry not found' if databases_found.length == 0
      raise 'Multiple entries found' if databases_found.length > 1  
    end

    def locate_database_for_entry(words, word)
      ['Nouns', 'Verbs', 'Adjectives'].keep_if do |database|
        words.execute("SELECT 1 FROM #{database}
                       WHERE Entry = '#{word}'").length > 0
      end
    end

    def statements_for_each_database(words, meaning)
      ['Nouns', 'Verbs', 'Adjectives'].map do |database|
        statement = words.prepare "SELECT * FROM #{database}
                                   WHERE Meaning LIKE '% #{meaning} %'
                                      OR Meaning LIKE '% #{meaning},%'
                                      OR Meaning LIKE '%#{meaning}'"
        statement.execute
      end
    end

    def update_field_statement(found, entry, field, new_value, database)
      statement = database.prepare "UPDATE #{found[0]}
                                    SET #{field} = '#{new_value}'
                                    WHERE Entry = '#{entry}'"
      statement.execute
    end
    #WHERE ',' || Meaning || ',' like '%,#{meaning}%'"

    #WHERE Meaning LIKE
    #OR Meaning LIKE '%#{meaning}'
    #OR Meaning LIKE '#{meaning}%'"
    def table_columns(database, table_name)
      statement = database.prepare "SELECT * FROM #{table_name} LIMIT 1"

      columns = statement.columns
      statement.close if statement
      columns
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