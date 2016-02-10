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
        draw_edit_word_button(self)
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

    def draw_button_and_execute(word, part_of_speech, edit_lines, field_names)
      @shoes.button 'Add word' do
        @field_data = collect_line_data(edit_lines)
        @field_data.unshift(word)

        field_names.map! { |field| field.capitalize }.unshift('Entry')
        field_names = field_names.join(',').gsub('Case', 'Used_case').split(',')

        word_hash = Hash[field_names.zip @field_data]

        new_noun = Object.const_get('German::' + part_of_speech).new(word_hash)
        add_new_word_and_print_success_message(new_noun)
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
  end
end

Shoes.app(title: "German dictionary", width: 800, height: 600) do
  interface = German::GUI.new(self, 'examples.db', 'highscores.db')
  interface.draw_buttons
end

