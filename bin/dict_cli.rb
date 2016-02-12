require_relative '../lib/cli'

cli = German::ConsoleInterface.new('../data/words.db', '../data/highscores.db')
cli.main_menu