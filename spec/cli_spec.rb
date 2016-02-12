require 'spec_helper'

cli = German::ConsoleInterface.new('./data/test databases/examples.db', 
                                   './data/test databases/highscores_examples.db')

describe 'CLI' do
  describe '#extract' do
    it 'prints word details for words in the database' do
      expect(STDOUT).to receive(:puts).with("Entry: Hund\nGender: der\nPlural: Hunde\n" +
                                            "Genetive: Hund(e)s\nMeaning: dog\n" +
                                            "Examples: [Vorsicht,] bissiger Hund! - Beware of the dog!")
      cli.extract('Hund')
    end

    it 'displays error message for words not in the database' do
      expect(STDOUT).to receive(:puts).with("Entry not found")
      cli.extract('Kuche')
    end
  end

  describe '#add-word' do
    it 'displays error message for words in the database' do
      expect(STDOUT).to receive(:puts).with("Word 'Hund' already exists")
      cli.add('Hund')
    end
  end

  describe '#help' do
    it 'displays a help message' do
      expect(STDOUT).to receive(:puts).with("The following commands are available:\n" +
                                            "  extract <word> - displays a word from the dictionary\n" +
                                            "  add-word - adds a new word to the dictionary\n" +
                                            "  edit <word> <field> <new_value> - edit an existing entry's field\n" +
                                            "  delete <word> - deletes a word from the dictionary\n" +
                                            "  with-meaning <word> - displays all words that share meaning\n" +
                                            "  quiz mode - enter quiz mode where you can test your knowledge")
      cli.help
    end
  end
end