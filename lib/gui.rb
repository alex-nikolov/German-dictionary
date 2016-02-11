require_relative 'dictionary'
require_relative 'quiz'
require_relative 'highscore'

module German
  class GUI
    attr_reader :dictionary, :dictionary_database, :highscore_database

    def initialize(shoes, dictionary_database, highscore_database)
      @shoes = shoes
      @dictionary = Dictionary.new(dictionary_database)
      @dictionary_database = dictionary_database
      @highscore_database = highscore_database
    end

    def draw_buttons
      @shoes.flow(margin: 20, width: 1.0, height: 0.15, displace_top: 0.03) do
        draw_view_word_button(self)
        draw_add_word_button(self)
        draw_edit_word_button(self)
        draw_delete_word_button(self)
        draw_view_words_with_meaning(self)
      end

      @shoes.flow(margin: 20, width: 1.0, height: 0.15, displace_top: 0.65) do
        draw_quiz_meanings_button(self)
        draw_highscores(self, 'highscores_to_s', 'All highscores')
        draw_highscores(self, 'top_five_highscores_to_s', 'Top 5 highscores')
      end
    end

    def draw_view_word_button(owner)
      @shoes.button 'View word', width: 0.15, height: 1.0 do
        @shoes.window(title: 'View word', width: 400, height: 300) do
          new_window = German::GUI.new(self, owner.dictionary_database, 
                                             owner.highscore_database)
          new_window.draw_view_word_button_details
        end
      end
    end

    def draw_view_word_button_details
      @shoes.stack do
        @shoes.para 'Enter word', align: 'center'

        @shoes.flow do
          @edit_line = @shoes.edit_line(width: 140, align: 'right')

          @go = @shoes.button 'Go', align: 'right'

          @shoes.stack do
            @displayed_word = @shoes.para

            extracted_word_on_click
          end
        end
      end
    end

    def extracted_word_on_click
      @go.click do
        begin
          extracted_word = @dictionary.extract_entry(@edit_line.text)
        rescue DictionaryError => e
          @displayed_word.replace ''
          @shoes.alert(e.message)
        else
          @displayed_word.replace extracted_word
        end
      end
    end

    def draw_add_word_button(owner)
      @shoes.button 'Add word', width: 0.15, height: 1.0 do
        @shoes.window(title: 'Add word', width: 500, height: 400) do
          new_window = German::GUI.new(self, owner.dictionary_database, 
                                             owner.highscore_database)
          new_window.draw_add_word_button_details
        end
      end
    end

    def draw_add_word_button_details
      @shoes.stack do
        @shoes.flow do
          @shoes.para 'Enter new word '

          @edit_line = @shoes.edit_line(width: 140)
        end

        draw_parts_of_speech_list_box
      end
    end

    def draw_parts_of_speech_list_box
      @shoes.flow do
        @shoes.para 'Choose part of speech '

        @box = @shoes.list_box items: ['Noun', 'Verb', 'Adjective'], width: 100,
                               choose: 'Noun'

        @shoes.button 'Go', align: 'right' do
          handle_different_parts_of_speech(@edit_line.text, @box.text)
        end
      end
    end

    def handle_different_parts_of_speech(word, part_of_speech)
      if @dictionary.exists_entry? word
        @shoes.alert "Word '#{word}' already exists" 
      else
        case part_of_speech
          when 'Noun' then add_noun(word)
          when 'Verb' then add_verb(word)
          when 'Adjective' then add_adjective(word)
        end
      end
    end

    def add_noun(word)
      field_names = ['gender', 'plural', 'genetive', 'meaning', 'examples']
      draw_add_word_widgets(word, 'Noun', field_names)
    end

    def add_verb(word)
      field_names = ['case', 'preposition', 'separable', 'forms'] +
                    ['transitive', 'meaning', 'examples']
      draw_add_word_widgets(word, 'Verb', field_names)
    end

    def add_adjective(word)
      field_names = ['comparative', 'superlative', 'meaning', 'examples']
      draw_add_word_widgets(word, 'Adjective', field_names)
    end

    def draw_add_word_widgets(word, part_of_speech, field_names)
      @fields_and_add_word_button = @shoes.stack do
        edit_lines = field_names.map { |f| draw_edit_lines_for_field(f) }

        draw_button_and_execute(word, part_of_speech, edit_lines, field_names)
      end
    end

    def draw_button_and_execute(word, part_of_speech, edit_lines, fields)
      @shoes.button 'Add word' do
        @field_data = collect_line_data(edit_lines)
        @field_data.unshift(word)

        fields.map! { |field| field.capitalize }.unshift('Entry')
        fields = field_names.join(',').gsub('Case', 'Used_case').split(',')

        word_hash = Hash[fields.zip @field_data]

        new_word = Object.const_get('German::' + part_of_speech).new(word_hash)
        add_new_word_and_print_success_message(new_word)
      end
    end

    def collect_line_data(edit_lines)
      edit_lines.map { |edit_line| edit_line.text }
    end

    def draw_edit_lines_for_field(field_name)
      @shoes.flow do
        @shoes.para "#{field_name.capitalize} "
        if ['meaning', 'examples'].include? field_name
          @edit_space = @shoes.edit_box(width: 250, height: 60)
        else
          @edit_space = @shoes.edit_line(width: 100)
        end
      end

      @edit_space
    end

    def add_new_word_and_print_success_message(new_word)
      @dictionary.add_entry(new_word)
      @shoes.alert "Word successfully added"

      @fields_and_add_word_button.clear
      @edit_line.text = ''
    end

    def draw_edit_word_button(owner)
      @shoes.button 'Edit word', width: 0.15, height: 1.0 do
        @shoes.window(title: 'Edit word', width: 400, height: 300) do
          new_window = German::GUI.new(self, owner.dictionary_database, 
                                             owner.highscore_database)
          new_window.draw_edit_word_button_details
        end
      end
    end

    def draw_edit_word_button_details
      @shoes.stack do
        @shoes.para 'Enter word', align: 'center'

        @shoes.flow do
          @edit_line = @shoes.edit_line(width: 0.35, displace_left: 0.25)

          draw_edit_word_go_button
        end
      end
    end

    def draw_edit_word_go_button
      @shoes.button 'Go', width: 0.15, displace_left: 0.25 do
        unless @dictionary.exists_entry?(@edit_line.text)
          @shoes.alert('Entry does not exist')
        else
          @found_word = @dictionary.extract_entry(@edit_line.text)

          draw_part_of_speech_list_box
        end
      end
    end

    def draw_part_of_speech_list_box
      @part_of_speech = @shoes.flow do
        @box = @shoes.list_box items: @found_word.fields, choose: 'Entry',
                               width: 0.35, displace_left: 0.25
        draw_edit_box_and_save_changes_button
      end
    end

    def draw_edit_box_and_save_changes_button
      @shoes.button 'Go', width: 0.15, displace_left: 0.25 do
        @new_value.clear if @new_value

        @new_value = @shoes.stack do
          @edit = @shoes.edit_box @found_word.send("#{@box.text.downcase}"),
                         width: 0.5, displace_left: 0.25

          @shoes.button 'Save changes', width: 0.2, displace_left: 0.4 do
            edit_entry_and_clear
          end
        end
      end
    end

    def edit_entry_and_clear
      @dictionary.edit_entry(@found_word.entry, @box.text, @edit.text)
      @shoes.alert('Changes saved successfully')
      @part_of_speech.clear
      @new_value.clear
    end

    def draw_delete_word_button(owner)
      @shoes.button 'Delete word', width: 0.15, height: 1.0 do
        @shoes.window(title: 'Delete word', width: 300, height: 250) do
          new_window = German::GUI.new(self, owner.dictionary_database, 
                                             owner.highscore_database)
          new_window.draw_delete_word_button_details
        end
      end
    end

    def draw_delete_word_button_details
      @shoes.para 'Enter word', align: 'center'

      @shoes.flow do
        @edit_line = @shoes.edit_line width: 0.35, displace_left: 0.20

        @shoes.button 'Delete', width: 0.25, displace_left: 0.20 do
          delete_word(@edit_line.text)
        end
      end
    end

    def delete_word(word)
      if @dictionary.exists_entry? word
        @dictionary.delete_entry(word)
        @shoes.alert("Word '#{word}' successfully deleted")
      else
        @shoes.alert("Word '#{word}' was not found")
      end

      @edit_line.text = ''
    end

    def draw_quiz_meanings_button(owner)
      @shoes.button 'Test meanings', width: 0.15, height: 1.0 do
        @shoes.window(title: 'Test meanings', width: 600, height: 450) do
          new_window = German::GUI.new(self, owner.dictionary_database, 
                                             owner.highscore_database)
          quiz = German::Quiz.new(['Noun', 'Adjective', 'Verb'], 
                                   owner.dictionary_database, ['meaning'])
          @quiz_name = 'Meanings'
          new_window.draw_quiz_button_details(quiz)
        end
      end
    end

    def draw_quiz_button_details(quiz)
      @shoes.flow displace_top: 0.1 do
        @shoes.button 'Start test', width: 0.3, displace_left: 0.2 do
          start_button_execute(quiz)
        end

        @shoes.button 'End test', width: 0.3, displace_left: 0.2 do
          end_button_execute
        end
      end
    end

    def start_button_execute(quiz)
      @fields_and_check = @shoes.stack displace_top: 0.23 do
        @current_word = @shoes.para quiz.current_word.entry, align: 'center'

        @edit_lines = quiz.fields_to_be_guessed.map do |field|
          draw_edit_lines_for_field(field)
        end

        @shoes.button 'Check', width: 0.2, displace_left: 0.4 do
          check_guess_execute(quiz)
        end
      end
    end

    def check_guess_execute(quiz)
      @suggestions = collect_line_data(@edit_lines)

      guess_correctness = quiz.guess(@suggestions)
      handle_guess_correctness(quiz, guess_correctness)
    end

    def handle_guess_correctness(quiz, guess_correctness)
      everything_guessed = quiz.all_guessed?(guess_correctness)
      nothing_guessed = quiz.nothing_guessed?(guess_correctness)
      answers = quiz.not_guessed_answers(guess_correctness)

      @guess_para = @shoes.stack displace_top: 0.24 do
        display_guess_results(everything_guessed, nothing_guessed, answers)
      end

      @next = @shoes.flow displace_top: 0.26 do
        draw_next_button(quiz)
      end
    end

    def display_guess_results(everything_guessed, nothing_guessed, answers)
      if everything_guessed
        @guess_message = @shoes.para 'Correct!', align: 'center'
      elsif nothing_guessed
        @guess_message = @shoes.para "Sorry, the answers are #{answers}",
                                      align: 'center'
      else
        @guess_message = @shoes.para "Almost, it's actually #{answers}",
                                      align: 'center'
      end
    end

    def draw_next_button(quiz)
      @shoes.button 'Next', width: 0.2, displace_left: 0.4 do
        @next.clear
        @guess_para.clear
        clear_edit_lines

        if quiz.empty?
          draw_buttons_for_writing_new_score(quiz)
        else
          @current_word.text = quiz.current_word.entry
        end
      end
    end

    def draw_buttons_for_writing_new_score(quiz)
      @shoes.stack do
        @current_word.text = "Your score is #{quiz.score}. Enter your name"
        @name = @shoes.edit_line(width: 0.3, displace_left: 0.35)

        @shoes.flow do
          write_new_score(quiz)
        end
      end
    end

    def write_new_score(quiz)
      @shoes.button 'Save', width: 0.2, displace_left: 0.4 do
        new_score = German::Highscore.new(quiz.score, @highscore_database,
                                          @name.text, @quiz_name)
        new_score.write_to_table
        @shoes.alert('Score successfully saved')
      end
    end

    def clear_edit_lines
      @edit_lines.each { |edit_line| edit_line.text = '' }
    end

    def end_button_execute
      
    end

    def draw_highscores(owner, all_ot_top, button_message)
      @shoes.button "#{button_message}", width: 0.15, height: 1.0 do
        @shoes.window(title: "#{button_message}", width: 400, height: 300) do
          new_window = German::GUI.new(self, owner.dictionary_database, 
                                             owner.highscore_database)
          which_highscores = German::Highscore.method("#{all_ot_top}")
          new_window.draw_highscores_details(which_highscores)
        end
      end
    end

    def draw_highscores_details(which_highscores)
      @shoes.flow do
        @box = @shoes.list_box items: ['Meanings', 'Nouns'],
                            choose: 'Meanings', width: 0.4, displace_left: 0.2

        @shoes.button 'Go', width: 0.2, displace_left: 0.2 do
          display_highscores(@box.text, which_highscores)
        end
      end
    end

    def display_highscores(quiz_name, which_highscores)
      @highscores = @shoes.para '' unless @highscores
      @highscores.text = which_highscores.call(@highscore_database, quiz_name)
    end

    def draw_view_words_with_meaning(owner)
      @shoes.button 'Words that share meaning', width: 0.15, height: 1.0 do
        @shoes.window(title: 'Word that share meaning', width: 400, height: 300) do
          new_window = German::GUI.new(self, owner.dictionary_database, 
                                             owner.highscore_database)
          new_window.draw_view_words_with_meaning_details
        end
      end
    end

    def draw_view_words_with_meaning_details
      @shoes.flow do
        @edit_line = @shoes.edit_line width: 0.4, displace_left: 0.2

        @shoes.button 'Go', width: 0.2, displace_left: 0.2 do
          display_words_with_common_meaning(@edit_line.text)
        end
      end
    end

    def display_words_with_common_meaning(meaning)
      @words = @dictionary.extract_entries_with_meaning(meaning)

      @shoes.alert("No words found that mean '#{meaning}'") if @words.empty?

      @displayed_words = @shoes.para '' unless @displayed_words
      @displayed_words.text = @words.each(&:to_s).join("\n\n")
    end
  end
end

Shoes.app(title: "German dictionary", width: 800, height: 600) do
  interface = German::GUI.new(self, 'examples.db', 'highscores.db')
  interface.draw_buttons
end