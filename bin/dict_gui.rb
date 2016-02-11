require_relative '../lib/gui'

Shoes.app(title: "German dictionary", width: 800, height: 600) do
  interface = German::GUI.new(self, 'examples.db', 'highscores.db')
  interface.draw_buttons
end