describe 'Highscore' do
  describe '#initialize' do
    it 'formats the time correctly' do
      highscore = German::Highscore.new(100, 'highscores_examples.db', 'James', 'Meanings')
      time = Time.now
      expect(time.strftime('%F %H:%M:%S')).to eq highscore.time
    end
  end

  describe '#reset' do
    it 'resets highscores in corresponding table' do
      German::Highscore.reset('highscores_examples.db', 'Meanings')
      expect(German::Highscore.highscores_to_s('highscores_examples.db', 'Meanings')).to eq ''
    end
  end

  describe '#write_to_table' do
    it 'writes highscores to empty and non-empty table' do
      first_highscore = German::Highscore.new(100, 'highscores_examples.db', 'James', 'Meanings')
      first_highscore.write_to_table
      expected_result = "100.0\tJames\t#{first_highscore.time}"
      expect(German::Highscore.highscores_to_s('highscores_examples.db', 'Meanings')).to eq expected_result

      second_highscore = German::Highscore.new(80, 'highscores_examples.db', 'Rodrigo', 'Meanings')
      second_highscore.write_to_table
      expected_result = "100.0\tJames\t#{first_highscore.time}\n" +
                        "80.0\tRodrigo\t#{second_highscore.time}"
      expect(German::Highscore.highscores_to_s('highscores_examples.db', 'Meanings')).to eq expected_result
    end
  end

  describe '#highscores_to_s' do
    it 'returns highscores as string correctly' do
      #expect(German::Highscore.highscores_to_s('highscore_examples.db', 'James')
    end
  end
end