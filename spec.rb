describe 'Dictionary' do
  describe '#extract_entry' do
    it 'loads nouns from database' do
      dictionary = German::Dictionary.new
      hund = dictionary.extract_entry 'Hund'

      expect(hund.entry).to eq 'Hund'
    end

    it 'loads verbs from database' do
      dictionary = German::Dictionary.new
      anschauen = dictionary.extract_entry 'anschauen'

      expect(anschauen.entry).to eq 'anschauen'
    end

    it 'loads adjectives from database' do
      dictionary = German::Dictionary.new
      schön = dictionary.extract_entry 'schön'

      expect(schön.entry).to eq 'schön'
    end
  end

  describe '#add_entry' do
    it 'adds nouns to the database' do
      dictionary = German::Dictionary.new
      hund = Noun.new({"entry" => "Hund",
                       ""})

      expect(hund.entry).to eq 'Hund'
    end

    it 'loads verbs from database' do
      dictionary = German::Dictionary.new
      anschauen = dictionary.extract_entry 'anschauen'

      expect(anschauen.entry).to eq 'anschauen'
    end

    it 'loads adjectives from database' do
      dictionary = German::Dictionary.new
      schön = dictionary.extract_entry 'schön'

      expect(schön.entry).to eq 'schön'
    end
  end
end

describe 'Hash test' do
  it 'jfsjfja' do
    h = { 1 => 45, 24 => 92 }
    expect(h).to include 1
  end
end

=begin
    expect(hund.meaning).to include 'Куче'
    expect(hund.gender).to eq 'der'
    expect(hund.plural).to eq 'Hunde'
    expect(hund.genetive).to eq 'Hund(e)s'
=end