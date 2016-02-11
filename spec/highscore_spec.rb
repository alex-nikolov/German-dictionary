require 'spec_helper'

database = './data/test databases/highscores_examples.db'

describe 'Highscore' do
  first_highscore = German::Highscore.new(100, database, 'James', 'Meanings')
  second_highscore = German::Highscore.new(80, database, 'Rodrigo', 'Meanings')

  describe '#initialize' do
    it 'formats the time correctly' do
      highscore = German::Highscore.new(100, database, 'James', 'Meanings')
      time = Time.now
      expect(time.strftime('%F %H:%M:%S')).to eq highscore.time
    end
  end

  describe '#reset' do
    it 'resets highscores in corresponding table' do
      German::Highscore.reset(database, 'Meanings')
      expect(German::Highscore.highscores_to_s(database, 'Meanings')).to eq ''
    end
  end

  describe '#write_to_table' do
    it 'writes highscores to empty table' do
      first_highscore.write_to_table
      expected_result = "100.0\tJames\t#{first_highscore.time}"
      expect(German::Highscore.highscores_to_s(database, 'Meanings')).to eq expected_result
    end

    it 'writes highscores to non-empty table' do
      second_highscore.write_to_table
      expected_result = "100.0\tJames\t#{first_highscore.time}\n" +
                        "80.0\tRodrigo\t#{second_highscore.time}"
      expect(German::Highscore.highscores_to_s(database, 'Meanings')).to eq expected_result
    end
  end

  describe '#self.top_five_highscores_to_s' do
    it 'returns highscores as string correctly' do
      expected_result = "100.0\tJames\t#{first_highscore.time}\n" +
                        "80.0\tRodrigo\t#{second_highscore.time}"
      expect(German::Highscore.top_five_highscores_to_s(database, 'Meanings')).to eq expected_result
    end
  end
end