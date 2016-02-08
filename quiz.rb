require 'sqlite3'

require_relative 'noun'
require_relative 'verb'
require_relative 'adjective'

module German
  class Quiz
<<<<<<< HEAD
    attr_accessor :words_to_be_guessed
=======
    attr_accessor :words_to_be_guessed, :current_word
>>>>>>> cli

    def initialize(parts_of_speech, database, fields_to_be_guessed)
      @database = database
      @words_to_be_guessed = load_words_from_database(parts_of_speech)

      @current_word = @words_to_be_guessed[0] if @words_to_be_guessed.size > 0
      @fields_to_be_guessed = fields_to_be_guessed
      @right_answers = 0
      @total_answers = 0
    end

    def guess(suggestions)
      suggestions_with_fields = suggestions.zip @fields_to_be_guessed
<<<<<<< HEAD
=======

>>>>>>> cli
      suggestion_correctness = suggestions_with_fields.map do |pair|
        correct_answer = @current_word.method(pair.last).call
        evaluate_correctness_of_suggestion(pair, correct_answer)
      end
<<<<<<< HEAD
      update_score(suggestion_correctness)
      @current_word = @words_to_be_guessed.shuffle.pop
=======

      update_score(suggestion_correctness)
      pick_new_current_word
>>>>>>> cli

      suggestion_correctness
    end

    def score
<<<<<<< HEAD
      @total_answers == 0 ? 0 : @right_answers / @total_answers
=======
      if @total_answers == 0
        0
      else
        (@right_answers / @total_answers.to_f * 100).round(2)
      end
    end

    def empty?
      @words_to_be_guessed.empty?
    end

    def correct_answer?(answer)
      answer == 'Correct'
>>>>>>> cli
    end

    private

<<<<<<< HEAD
=======
    def pick_new_current_word
      if @total_answers == 1
        @words_to_be_guessed.shift
        @words_to_be_guessed.shuffle!
      end

      @current_word = @words_to_be_guessed.shift
    end

>>>>>>> cli
    def update_score(suggestion_correctness)
      right_answers = 0
      total_answers = suggestion_correctness.size

      suggestion_correctness.each do |correctness|
<<<<<<< HEAD
        right_answers += 1 unless correctness == 0
=======
        right_answers += 1 unless correctness.first == 0
>>>>>>> cli
      end

      @right_answers += right_answers / total_answers.to_f
      @total_answers += 1
    end

    def evaluate_correctness_of_suggestion(suggestion_with_field, correct_answer)
      if suggestion_with_field.first == correct_answer
<<<<<<< HEAD
        1
      elsif /\b#{suggestion_with_field.first}\b/ =~ correct_answer
        correct_answer
      else
        0
=======
        [1, 'Correct']
      elsif /\b#{suggestion_with_field.first}\b/ =~ correct_answer
        [0.5, correct_answer]
      else
        [0, correct_answer]
>>>>>>> cli
      end
    end

    def load_words_from_database(parts_of_speech)
      words = SQLite3::Database.open @database
      words.results_as_hash = true

      loaded_words = map_words_to_parts_of_speech(words, parts_of_speech)

      words.close if words
      loaded_words
    end

    def map_words_to_parts_of_speech(database, parts_of_speech)
      loaded_words = []

      parts_of_speech.map do |part_of_speech|
        run_statement = database.execute "SELECT * From #{part_of_speech}s"
        current_class = Object.const_get('German::' + part_of_speech)

        run_statement.each { |row| loaded_words << current_class.new(row) }
      end

      loaded_words
    end
  end
end

# rspec quiz_spec.rb --require ./quiz.rb --colour --format documentation