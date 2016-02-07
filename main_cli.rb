require 'io/console'

require_relative 'dictionary'

module German
  class ConsoleInterface
    def initialize(database)
      @dictionary = Dictionary.new(database)

      start
    end

    def start
      puts "Welcome! If you need help with the commands, simply type 'help'"

      loop do
        user_input = gets.chomp

        arguments = user_input.split(' ')
        case user_input
          when 'help' then help
          when /extract\s+(.+)/ then extract(arguments[1])
          when /add-word\s+(.+)/ then add(arguments[1])
          when /edit\s+(.+)/ then edit(arguments[1..-1])
          when /delete\s+(.+)/ then delete(arguments[1])
          when 'q' then break
          else 
            puts "Command '#{user_input}' not recognized."
            puts "If you need help, type 'help'"
        end
      end
    end

    def help
      puts 'The following commands are available:'
      puts '  extract <word> - displays a word from the dictionary'
      puts '  add-word - starts the process of adding a new word to the dictionary'
      puts "  edit <word> <field> <new_value> - edit an existing entry's field"
      puts '  delete <word> - deletes a word from the dictionary'
    end

    def extract(word)
      extracted_word = @dictionary.extract_entry(word)
    rescue StandardError => e
      puts e.message
    else
      puts extracted_word.to_s
    end

    def add(word)
      if @dictionary.exists_entry? word
        puts "Word '#{word}' already exists"
        return  
      end

      puts "Enter the word's part of speech (noun, verb or adj)"

      until (user_input = gets.chomp) =~ /(noun|verb|adj)/
        puts "'#{user_input}' is not a supported part of speech"
      end

      case user_input
        when 'noun' then add_noun(word)
        when 'verb' then add_verb(word)
        when 'adj' then add_adjective(word)
      end
    end

    def add_noun(word)
      word_hash = new_word_hash(word, ['gender', 'plural', 'genetive'])

      new_noun = Noun.new(word_hash)
      add_new_word_and_print_success_message(new_noun)
    end

    def add_verb(word)
      word_hash = new_word_hash(word, ['case', 'preposition', 'separable',
                                       'forms', 'transitive'])

      new_verb = Verb.new(word_hash)
      add_new_word_and_print_success_message(new_verb)
    end

    def add_adjective(word)
      word_hash = new_word_hash(word, ['comparative', 'superlative'])

      new_adjective = Adjective.new(word_hash)
      add_new_word_and_print_success_message(new_adjective)
    end

    def delete(word)
      @dictionary.delete_entry(word)
    rescue StandardError => e
      puts e.message
    else
      puts "Entry '#{word}' successfully deleted"
    end

    def edit(arguments)
      word, field, new_value = arguments
      field.capitalize!
      @dictionary.edit_entry(word, field, new_value)
    rescue StandardError => e
      puts e.message
    else
      puts "Entry '#{word}' successfully edited"
    end

    private

    def add_new_word_and_print_success_message(new_word)
      @dictionary.add_entry(new_word)
      puts "Entry '#{new_word.entry}' successfully added"
    end

    def new_word_hash(word, field_names)
      field_data = field_names.map { |field| enter_field(field) }
      field_data.unshift(word)

      common_fields = enter_meaning_and_examples
      field_names.map! { |field| field.capitalize }.unshift('Entry')
      field_names = field_names.join(',').gsub('Case', 'Used_case').split(',')

      Hash[field_names.zip field_data].merge(common_fields)
    end

    def enter_meaning_and_examples
      meaning = enter_field('meaning')
      examples = enter_field('examples')

      { 'Meaning' => meaning, 'Examples' => examples }
    end

    def enter_field(field_name)
      puts "Enter the word's #{field_name}: "
      field_value = gets.chomp
    end
  end
end

German::ConsoleInterface.new('examples.db')
#input = gets.chomp
#puts 5 if input == '3'