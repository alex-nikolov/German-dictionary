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
      expect(quiz.words_to_be_guessed.size).to eq 7

      entries = quiz.words_to_be_guessed.map { |word| word.entry }
      expected_entries = ['anschauen', 'Hund', 'Katze', 'Haut', 'schön', 'kalt', 'hübsch']
      expect((expected_entries - entries).empty?).to be true
    end
  end

  describe '#guess' do
    it "returns a single element array with '1' as its element when field is correctly guessed" do
      quiz = German::Quiz.new(['Noun', 'Verb', 'Adjective'], 'quiz_examples.db', ['meaning'])
      guess = quiz.guess(['dog'])
<<<<<<< HEAD
      expect(guess).to eq [1]
=======
      expect(guess).to eq [[1, 'Correct']]
>>>>>>> cli
      #expect(quiz.score).to eq 1
    end

    it "returns a single element array with '0' as its element when field is incorrectly guessed" do
      quiz = German::Quiz.new(['Noun', 'Verb', 'Adjective'], 'quiz_examples.db', ['meaning'])
      guess = quiz.guess(['god'])
<<<<<<< HEAD
      expect(guess).to eq [0]
=======
      expect(guess).to eq [[0, 'dog']]
>>>>>>> cli
      #expect(quiz.score).to eq 0
    end

    it "returns a single element array with the correct answer as its element when field is partially guessed" do
      quiz = German::Quiz.new(['Adjective', 'Noun', 'Verb'], 'quiz_examples.db', ['meaning'])
      guess = quiz.guess(['lovely'])
<<<<<<< HEAD
      expect(guess).to eq ['beautiful, handsome, lovely, great']
=======
      expect(guess).to eq [[0.5, 'beautiful, handsome, lovely, great']]
>>>>>>> cli
      #expect(quiz.score).to eq 1
    end

    it "returns a two element array with two 1-s when both fields are correctly guessed" do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['gender', 'plural'])
      guess = quiz.guess(['der', 'Hunde'])
<<<<<<< HEAD
      expect(guess).to eq [1, 1]
=======
      expect(guess).to eq [[1, 'Correct'], [1, 'Correct']]
>>>>>>> cli
      #expect(quiz.score).to eq 1
    end

    it "returns a two element array with two 0-s when both fields are incorrectly guessed" do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['gender', 'plural'])
      guess = quiz.guess(['die', 'Hunden'])
<<<<<<< HEAD
      expect(guess).to eq [0, 0]
=======
      expect(guess).to eq [[0, 'der'], [0, 'Hunde']]
>>>>>>> cli
      #expect(quiz.score).to eq 0
    end

    it "returns the correct two element array with when one field is correctly guessed and the other is incorrectly guessed" do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['gender', 'plural'])
      guess = quiz.guess(['der', 'Hunden'])
<<<<<<< HEAD
      expect(guess).to eq [1, 0]
=======
      expect(guess).to eq [[1, 'Correct'], [0, 'Hunde']]
>>>>>>> cli
      #expect(quiz.score).to eq 0
    end

    it "returns the correct two element array with when one field is incorrectly guessed and the other is partially guessed" do
      quiz = German::Quiz.new(['Adjective'], 'quiz_examples.db', ['comparative', 'meaning'])
      guess = quiz.guess(['schöner', 'beautiful'])
<<<<<<< HEAD
      expect(guess).to eq [1, 'beautiful, handsome, lovely, great']
=======
      expect(guess).to eq [[1, 'Correct'], [0.5, 'beautiful, handsome, lovely, great']]
>>>>>>> cli
      #expect(quiz.score).to eq 0
    end
  end

  describe '#score' do
    it "returns a score of 0 when no guesses are made" do
      quiz = German::Quiz.new(['Noun', 'Verb', 'Adjective'], 'quiz_examples.db', ['meaning'])
      expect(quiz.score).to eq 0
    end
    it "returns a score of 1 for correct guesses" do
      quiz = German::Quiz.new(['Noun', 'Verb', 'Adjective'], 'quiz_examples.db', ['meaning'])
      guess = quiz.guess(['dog'])
<<<<<<< HEAD
      expect(quiz.score).to eq 1
=======
      expect(quiz.score).to eq 100
>>>>>>> cli
    end

    it "returns a score of 0 for incorrect guesses" do
      quiz = German::Quiz.new(['Noun', 'Verb', 'Adjective'], 'quiz_examples.db', ['meaning'])
      guess = quiz.guess(['god'])
      expect(quiz.score).to eq 0
    end

    it "returns a score of 1 for partial guesses" do
      quiz = German::Quiz.new(['Adjective', 'Noun', 'Verb'], 'quiz_examples.db', ['meaning'])
      guess = quiz.guess(['lovely'])
<<<<<<< HEAD
      expect(quiz.score).to eq 1
=======
      expect(quiz.score).to eq 100
>>>>>>> cli
    end

    it "returns a score of 1 when both fields are correclty guessed" do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['gender', 'plural'])
      guess = quiz.guess(['der', 'Hunde'])
<<<<<<< HEAD
      expect(quiz.score).to eq 1
=======
      expect(quiz.score).to eq 100
>>>>>>> cli
    end

    it "returns a score of 0 when neither field is correctly guessed" do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['gender', 'plural'])
      guess = quiz.guess(['die', 'Hunden'])
      expect(quiz.score).to eq 0
    end

    it "returns a score of 0.5 when one of two fields is correctly guessed" do
      quiz = German::Quiz.new(['Noun'], 'quiz_examples.db', ['gender', 'plural'])
      guess = quiz.guess(['der', 'Hunden'])
<<<<<<< HEAD
      expect(quiz.score).to eq 0.5
=======
      expect(quiz.score).to eq 50
>>>>>>> cli
    end
  end
end