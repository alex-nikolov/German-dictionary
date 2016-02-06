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
  end
end

German::ConsoleInterface.new('examples.db')
#input = gets.chomp
#puts 5 if input == '3'