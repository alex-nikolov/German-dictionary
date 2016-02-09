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
        draw_view_word_button(self, dictionary)
        draw_add_word_button
        draw_edit_word_button
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

    def draw_view_word_button(caller, dictionary)
      @shoes.button 'View word', width: 0.15, height: 1.0 do
        @shoes.window(title: 'View word', width: 400, height: 300) do
          new_window = German::GUI.new(self, caller.dictionary_database, 
                                             caller.highscore_database)
          new_window.draw_view_word_button_details
        end
      end
    end

    def draw_add_word_button
      @shoes.button 'Add word', width: 0.15, height: 1.0 do
      end
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

