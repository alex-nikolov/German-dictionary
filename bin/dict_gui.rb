require_relative '../lib/gui'

Shoes.app(title: "German dictionary", width: 800, height: 350) do
  interface = German::GUI.new(self, '../data/words.db', '../data/highscores.db')
  interface.draw_buttons
end