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

        case user_input
          when 'help' then help
          when /extract\s+(.+)/ then extract(user_input.split(' ')[1])
          when /add-word\s+(.+)/ then add(user_input.split(' ')[1])
          when /edit\s+(.+)/ then edit(user_input.split(' ')[1])
          when /delete\s+(.+)/ then delete(user_input.split('delete')[1])
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
      word_hash = new_noun_hash(word)

      new_noun = Noun.new(word_hash)
      @dictionary.add_entry(new_noun)
      puts "Entry '#{word}' successfully added"
    end

    def add_verb(word)
      word_hash = new_verb_hash(word)

      new_verb = Verb.new(word_hash)
      @dictionary.add_entry(new_verb)
      puts "Entry '#{word}' successfully added"
    end

    def add_adjective(word)
      word_hash = new_adjective_hash(word)

      new_adjective = Adjective.new(word_hash)
      @dictionary.add_entry(new_adjective)
      puts "Entry '#{word}' successfully added"
    end

    private

    def new_noun_hash(word)
      field_data = ['gender', 'plural', 'genetive'].map do |field|
        enter_field(field)
      end

      common_fields = enter_meaning_and_examples

      { 'Entry' => word, 'Gender' => field_data[0],
        'Plural' => field_data[1], 'Genetive' => field_data[2],
      }.merge(common_fields)
    end

    def new_verb_hash(word)
      verb_fields = ['case', 'preposition', 'separable', 'forms', 'transitive']
      field_data = verb_fields.map { |field| enter_field(field) }
      common_fields = enter_meaning_and_examples

      { 'Entry' => word, 'Used_case' => field_data[0],
        'Preposition' => field_data[1], 'Separable' => field_data[2],
        'Forms' => field_data[3], 'Transitive' => field_data[4],
      }.merge(common_fields)

    end

    def new_adjective_hash(word)
      field_data = ['comparative', 'superlative'].map { |f| enter_field(f) }
      common_fields = enter_meaning_and_examples

      { 'Entry' => word, 'Comparative' => field_data[0],
        'Superlative' => field_data[1]
      }.merge(common_fields)
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