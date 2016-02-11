require 'spec_helper'

database = './data/test databases/highscores_examples.db'

describe 'HighScore' do
  first_high_score = German::HighScore.new(100, database, 'James', 'Meanings')
  second_high_score = German::HighScore.new(80, database, 'Rodrigo', 'Meanings')

  describe '#initialize' do
    it 'formats the time correctly' do
      high_score = German::HighScore.new(100, database, 'James', 'Meanings')
      time = Time.now
      expect(time.strftime('%F %H:%M:%S')).to eq high_score.time
    end
  end

  describe '#reset' do
    it 'resets high scores in corresponding table' do
      German::HighScore.reset(database, 'Meanings')
      expect(German::HighScore.high_scores_to_s(database, 'Meanings')).to eq ''
    end
  end

  describe '#write_to_table' do
    it 'writes high scores to empty table' do
      first_high_score.write_to_table
      expected_result = "100.0\tJames\t#{first_high_score.time}"
      expect(German::HighScore.high_scores_to_s(database, 'Meanings')).to eq expected_result
    end

    it 'writes high scores to non-empty table' do
      second_high_score.write_to_table
      expected_result = "100.0\tJames\t#{first_high_score.time}\n" +
                        "80.0\tRodrigo\t#{second_high_score.time}"
      expect(German::HighScore.high_scores_to_s(database, 'Meanings')).to eq expected_result
    end
  end

  describe '#self.top_five_high_scores_to_s' do
    it 'returns high_scores as string correctly' do
      expected_result = "100.0\tJames\t#{first_high_score.time}\n" +
                        "80.0\tRodrigo\t#{second_high_score.time}"
      expect(German::HighScore.top_five_high_scores_to_s(database, 'Meanings')).to eq expected_result
    end
  end
end