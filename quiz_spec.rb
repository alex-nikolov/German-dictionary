describe 'Quiz' do
  describe '#initialize' do
    it 'loads entries from a single table' do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['meaning'])
      expect(quiz.words_to_be_guessed.size).to eq 3

      entries = quiz.words_to_be_guessed.map { |word| word.entry }
      expect(entries).to include 'Hund'
      expect(entries).to include 'Katze'
      expect(entries).to include 'Haut'
    end

    it 'loads entries from every table' do
      quiz = German::Quiz.new(['Noun', 'Verb', 'Adjective'], 'quiz_examples.db', ['meaning'])
      expect(quiz.words_to_be_guessed.size).to eq 6

      entries = quiz.words_to_be_guessed.map { |word| word.entry }
      expected_entries = ['Hund', 'Katze', 'Haut', 'schön', 'kalt', 'hübsch']
      expect((expected_entries - entries).empty?).to be true
    end
  end

  describe '#guess' do
    it 'returns expected array when the field is correctly guessed' do
      quiz = German::Quiz.new(['Noun', 'Verb', 'Adjective'], 'quiz_examples.db', ['meaning'])
      guess = quiz.guess(['dog'])
      expect(guess).to eq [[1, 'Correct']]
    end

    it 'returns expected array when the field is incorrectly guessed' do
      quiz = German::Quiz.new(['Noun', 'Verb', 'Adjective'], 'quiz_examples.db', ['meaning'])
      guess = quiz.guess(['god'])
      expect(guess).to eq [[0, 'dog']]
    end

    it 'returns expected array when the field is partially guessed' do
      quiz = German::Quiz.new(['Adjective', 'Noun', 'Verb'], 'quiz_examples.db', ['meaning'])
      guess = quiz.guess(['lovely'])
      expect(guess).to eq [[0.5, 'beautiful, handsome, lovely, great']]
    end

    it 'returns expected array when both fields are correctly guessed' do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['gender', 'plural'])
      guess = quiz.guess(['der', 'Hunde'])
      expect(guess).to eq [[1, 'Correct'], [1, 'Correct']]
    end

    it 'returns expected array when both fields are incorrectly guessed' do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['gender', 'plural'])
      guess = quiz.guess(['die', 'Hunden'])
      expect(guess).to eq [[0, 'der'], [0, 'Hunde']]
    end

    it 'returns expected array when one field is correctly guessed and the other is incorrectly guessed' do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['gender', 'plural'])
      guess = quiz.guess(['der', 'Hunden'])
      expect(guess).to eq [[1, 'Correct'], [0, 'Hunde']]
    end

    it 'returns expected array when one field is incorrectly guessed and the other is partially guessed' do
      quiz = German::Quiz.new(['Adjective'], 'quiz_examples.db', ['comparative', 'meaning'])
      guess = quiz.guess(['schöner', 'beautiful'])
      expect(guess).to eq [[1, 'Correct'], [0.5, 'beautiful, handsome, lovely, great']]
    end
  end

  describe '#score' do
    it 'returns a score of 0 when no guesses are made' do
      quiz = German::Quiz.new(['Noun', 'Verb', 'Adjective'], 'quiz_examples.db', ['meaning'])
      expect(quiz.score).to eq 0
    end
    it 'returns a score of 1 for correct guesses' do
      quiz = German::Quiz.new(['Noun', 'Verb', 'Adjective'], 'quiz_examples.db', ['meaning'])
      guess = quiz.guess(['dog'])
      expect(quiz.score).to eq 100
    end

    it 'returns a score of 0 for incorrect guesses' do
      quiz = German::Quiz.new(['Noun', 'Verb', 'Adjective'], 'quiz_examples.db', ['meaning'])
      guess = quiz.guess(['god'])
      expect(quiz.score).to eq 0
    end

    it 'returns a score of 1 for partial guesses' do
      quiz = German::Quiz.new(['Adjective', 'Noun', 'Verb'], 'quiz_examples.db', ['meaning'])
      guess = quiz.guess(['lovely'])
      expect(quiz.score).to eq 100
    end

    it 'returns a score of 1 when both fields are correclty guessed' do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['gender', 'plural'])
      guess = quiz.guess(['der', 'Hunde'])
      expect(quiz.score).to eq 100
    end

    it 'returns a score of 0 when neither field is correctly guessed' do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['gender', 'plural'])
      guess = quiz.guess(['die', 'Hunden'])
      expect(quiz.score).to eq 0
    end

    it 'returns a score of 0.5 when one of two fields is correctly guessed' do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['gender', 'plural'])
      guess = quiz.guess(['der', 'Hunden'])
      expect(quiz.score).to eq 50
    end
  end

  describe '#empty?' do
    it 'returns true when quiz does not have any remaining words' do
      quiz = German::Quiz.new(['Verb'], 'quiz_examples.db', ['meaning'])
      expect(quiz.empty?).to be true
    end

    it 'returns false when quiz has at least one remaining word' do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['gender', 'plural'])
      expect(quiz.empty?).to be false
    end
  end

  describe '#all_guessed?' do
    it 'returns true when all answers have been guessed' do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['gender', 'plural'])
      guess = quiz.guess(['der', 'Hunde'])
      expect(quiz.all_guessed?(guess)).to be true
    end

    it 'returns false when not all answers have been guessed' do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['gender', 'plural'])
      guess = quiz.guess(['der', 'Hunden'])
      expect(quiz.all_guessed?(guess)).to be false
    end
  end

  describe '#nothing_guessed?' do
    it 'returns true when no answers has been guessed' do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['gender', 'plural'])
      guess = quiz.guess(['die', 'Hunden'])
      expect(quiz.nothing_guessed?(guess)).to be true
    end

    it 'returns false when there are answers that have been guessed' do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['gender', 'plural'])
      guess = quiz.guess(['der', 'Hunden'])
      expect(quiz.nothing_guessed?(guess)).to be false
    end
  end

  describe '#not_guessed_answers' do
    it 'returns expected string when no answer has been guessed' do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['gender', 'plural'])
      guess = quiz.guess(['die', 'Hunden'])
      expect(quiz.not_guessed_answers(guess)).to eq "'der', 'Hunde'"
    end

    it 'returns expected string when some answers have been guessed' do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['gender', 'plural'])
      guess = quiz.guess(['der', 'Hunden'])
      expect(quiz.not_guessed_answers(guess)).to eq "'Hunde'"
    end

    it 'returns an empty string when all the answers have been guessed' do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['gender', 'plural'])
      guess = quiz.guess(['der', 'Hunde'])
      expect(quiz.not_guessed_answers(guess)).to eq ''
    end
  end
end