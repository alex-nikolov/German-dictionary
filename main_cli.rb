require 'io/console'

require_relative 'dictionary'
require_relative 'quiz'
require_relative 'highscore'

module German
  class ConsoleInterface
    def initialize(dictionary_database, quiz_database)
      @dictionary = Dictionary.new(dictionary_database)
      @quiz_database = quiz_database

      main_menu
    end

    def main_menu(new_start = true)
      if new_start
        puts "Welcome! If you need help with the commands, simply type 'help'"
      end

      loop do
        user_input = gets.chomp
        exit if user_input == 'q'

        arguments = user_input.split(' ')

        menu_cases(user_input, arguments)
      end
    end

    def help
      puts 'The following commands are available:'
      puts '  extract <word> - displays a word from the dictionary'
      puts '  add-word - adds a new word to the dictionary'
      puts "  edit <word> <field> <new_value> - edit an existing entry's field"
      puts '  delete <word> - deletes a word from the dictionary'
      puts '  quiz mode - enter quiz mode where you can test your knowledge'
    end

    def extract(word)
      extracted_word = @dictionary.extract_entry(word)
    rescue DictionaryError => e
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

      handle_different_parts_of_speech(user_input)
    end

    def delete(word)
      @dictionary.delete_entry(word)
    rescue DictionaryError => e
      puts e.message
    else
      puts "Entry '#{word}' successfully deleted"
    end

    def edit(arguments)
      word, field, new_value = arguments
      field.capitalize!
      @dictionary.edit_entry(word, field, new_value)
    rescue DictionaryError => e
      puts e.message
    else
      puts "Entry '#{word}' successfully edited"
    end

    def quiz_meaning
      quiz(['Noun', 'Adjective', 'Verb'], ['meaning'], 'Meanings')
    end

    def quiz_nouns
      quiz(['Noun'], ['gender', 'plural'], 'Nouns')
    end

    private

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

    def quiz(parts_of_speech, tested_fields, quiz_name)
      quiz = Quiz.new(parts_of_speech, @dictionary.database, tested_fields)

      until quiz.empty?
        suggestions = tested_fields.map do |field|
          user_input_in_quiz(quiz, field)
        end
        
        break if suggestions.include? 'q'

        guess_correctness = quiz.guess(suggestions)
        handle_guess_correctness(quiz, guess_correctness)
      end

      display_score(quiz)
      configure_highscore(quiz.score, quiz_name)
    end

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

    def menu_cases(user_input, arguments)
      case user_input
        when 'help' then help
        when /extract\s+(.+)/ then extract(arguments[1])
        when /add-word\s+(.+)/ then add(arguments[1])
        when /edit\s+(.+)/ then edit(arguments[1..-1])
        when /delete\s+(.+)/ then delete(arguments[1])
        when 'quiz mode' then quiz_mode
        else invalid_command(user_input)
      end
    end

    def quiz_mode
      quiz_help

      loop do
        user_input = gets.chomp
        if user_input == 'q'
          puts 'Switching back to main menu'
          main_menu(false)
        end

        arguments = user_input.split(' ')

        quiz_menu_cases(user_input, arguments)
      end
    end

    def quiz_menu_cases(user_input, arguments)
      case user_input
        when 'help' then quiz_help
        when 'quiz meanings' then quiz_meaning
        when 'quiz nouns' then quiz_nouns
        when /highscore(.+)top/ then top_highscores(arguments[1])
        when /highscore(.+)all/ then all_highscores(arguments[1])
        when 'q' then main_menu(false)
        else invalid_command(user_input)
      end
    end

    def quiz_help
      from_quiz = 'from a particular quiz'

      puts 'The following commands are supported:'
      puts '  quiz meaning - test your knowledge on word meanings'
      puts '  quiz nouns - test your knowledge on noun genders and plurals'
      puts '  highscore <name> top - view the top 5 highscores' + from_quiz
      puts '  highscore <name> all - view all scores' + from_quiz
    end

    def top_highscores(quiz_name)
      capitalized = quiz_name.capitalize
      puts Highscore.top_five_highscores_to_s(@quiz_database, capitalized)
    end

    def all_highscores(quiz_name)
      puts Highscore.highscores_to_s(@quiz_database, quiz_name.capitalize)
    end

    def invalid_command(command)
      puts "Command '#{command}' not recognized."
      puts "If you need help, type 'help'"
    end

    def handle_different_parts_of_speech(user_input)
      case user_input
        when 'noun' then add_noun(word)
        when 'verb' then add_verb(word)
        when 'adj' then add_adjective(word)
      end
    end

    def user_input_in_quiz(quiz, field)
      puts "Enter supposed #{field} of #{quiz.current_word.entry}"
      user_input = gets.chomp
    end

    def display_score(quiz)
      puts "Quiz finished. Your score is #{quiz.score}%"
    end

    def handle_guess_correctness(quiz, guess_correctness)
      everything_guessed = quiz.all_guessed?(guess_correctness)
      nothing_guessed = quiz.nothing_guessed?(guess_correctness)
      answers = quiz.not_guessed_answers(guess_correctness)

      if everything_guessed
        puts 'Correct!'
      elsif nothing_guessed
        puts "Sorry, that's not it, the answers are #{answers}"
      else
        puts "Almost, it's actually #{answers}"
      end
    end

    def configure_highscore(score, quiz_name)
      puts 'Enter name for new score'
      name = gets.chomp

      new_score = Highscore.new(score, @quiz_database, name, quiz_name)
      new_score.write_to_table

      puts 'Score successfully added'
    end
  end
end

German::ConsoleInterface.new('examples.db', 'highscores.db')
#input = gets.chomp
#puts 5 if input == '3'