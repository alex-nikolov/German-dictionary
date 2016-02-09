require_relative 'dictionary'

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
        draw_edit_word_button
      end
    end

    def draw_view_word_button(caller)
      @shoes.button 'View word', width: 0.15, height: 1.0 do
        @shoes.window(title: 'View word', width: 400, height: 300) do
          new_window = German::GUI.new(self, caller.dictionary_database, 
                                             caller.highscore_database)
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

          display_extracted_word
        end
      end
    end

    def display_extracted_word
      @shoes.stack do
        @displayed_word = @shoes.para

        @go.click do
          begin
            extracted_word = @dictionary.extract_entry(@edit_line.text)
          rescue StandardError => e
            @displayed_word.replace e.message
          else
            @displayed_word.replace extracted_word
          end
        end
      end
    end

    def draw_add_word_button(caller)
      @shoes.button 'Add word', width: 0.15, height: 1.0 do
        @shoes.window(title: 'Add word', width: 400, height: 300) do
          new_window = German::GUI.new(self, caller.dictionary_database, 
                                             caller.highscore_database)
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

        @shoes.flow do
          @shoes.para 'Choose part of speech '

          box = @shoes.list_box items: ['Noun', 'Verb', 'Adjective'], width: 100,
                                choose: 'Noun'

          @go = @shoes.button 'Go', align: 'right' do
            handle_different_parts_of_speech(@edit_line.text, box.text)
            #@shoes.close if box.text == 'Noun'
          end
        end
      end
    end

    def handle_different_parts_of_speech(word, part_of_speech)
      if @dictionary.exists_entry? word
        puts "Word '#{word}' already exists"
        return  
      end

      case part_of_speech
        when 'Noun' then add_noun(word)
        when 'Verb' then add_verb(word)
        when 'Adjective' then add_adjective(word)
      end
    end

    def add_noun(word)
      field_names = ['gender', 'plural', 'genetive', 'meaning', 'examples']
      @shoes.stack do
        edit_lines = field_names.map { |f| draw_edit_lines_for_field(f) }

        draw_add_word_button_and_execute(word, edit_lines, field_names)
      end
    end

    def draw_add_word_button_and_execute(word, edit_lines, field_names)
      @shoes.button 'Add word' do
        @field_data = collect_line_data(edit_lines)

        @field_data.unshift(word)

        field_names.map! { |field| field.capitalize }.unshift('Entry')
        field_names = field_names.join(',').gsub('Case', 'Used_case').split(',')

        word_hash = Hash[field_names.zip @field_data]

        new_noun = Noun.new(word_hash)
        add_new_word_and_print_success_message(new_noun)
      end
    end

    def collect_line_data(edit_lines)
      edit_lines.map { |edit_line| edit_line.text }
    end

    def draw_edit_lines_for_field(field_name)
      @shoes.flow do
        @shoes.para "#{field_name.capitalize} "
        @edit_line = @shoes.edit_line(width: 100)
      end

      @edit_line
    end

    def add_new_word_and_print_success_message(new_word)
      @dictionary.add_entry(new_word)
      @shoes.para "Word successfully added"
    end

    def draw_edit_word_button
      @shoes.button 'Edit word', width: 0.15, height: 1.0 do
      end
    end

    def experiment
      @push = @shoes.button "Push me"
      @note = @shoes.para "Nothing pushed so far"
      @push.click {
        @note.replace "Aha! Click!"
      }
    end
  end
end

Shoes.app(title: "German dictionary", width: 800, height: 600) do
  interface = German::GUI.new(self, 'examples.db', 'highscores.db')
  interface.draw_buttons
end

