dictionary = German::Dictionary.new('examples.db')

describe 'Dictionary' do
  describe '#extract_entry' do
    it 'loads nouns from database' do
      hund = dictionary.extract_entry 'Hund'

      expect(hund.entry).to eq 'Hund'
    end

    it 'loads verbs from database' do
      anschauen = dictionary.extract_entry 'anschauen'

      expect(anschauen.entry).to eq 'anschauen'
    end

    it 'loads adjectives from database' do
      schön = dictionary.extract_entry 'schön'

      expect(schön.entry).to eq 'schön'
    end

    it 'raises exception when entry was not found' do
      expect { baum = dictionary.extract_entry 'Baum' }.to raise_error(StandardError, /Entry not found/)
    end
  end

  describe '#add_entry' do
    it 'adds nouns to the database' do
      example_noun = German::Noun.new({"Entry" => "example noun",
                               "Meaning" => "meaning",
                               "Gender" => "gender",
                               "Plural" => "plural",
                               "Genetive" => "genetive",
                               "Examples" => "examples",
                              })

      dictionary.add_entry(example_noun)
      expect(dictionary.exists_entry? 'example noun').to be true
    end

    it 'adds verbs to the database' do
      example_verb = German::Verb.new({"Entry" => "example verb",
                                       "Case" => "case",
                                       "Preposition" => "preposition",
                                       "Separable" => "separable",
                                       "Forms" => "forms",
                                       "Transitive" => "transitive",
                                       "Meaning" => "meaning",
                                       "Examples" => "examples",
                                      })

      dictionary.add_entry(example_verb)
      expect(dictionary.exists_entry? 'example verb').to be true
    end

    it 'adds adjectives to the database' do
      example_adjective = German::Verb.new({"Entry" => "example adjective",
                                            "Comparative" => "comparative",
                                            "Superlative" => "superlative",
                                            "Meaning" => "meaning",
                                            "Examples" => "examples",
                                           })

      dictionary.add_entry(example_adjective)
      expect(dictionary.exists_entry? 'example adjective').to be true
    end
  end

  describe '#delete_entry' do
    it 'deletes nouns from the database' do
      dictionary.delete_entry 'example noun'
      expect(dictionary.exists_entry? 'example noun').to be false
    end

    it 'deletes verbs from the database' do
      dictionary.delete_entry 'example verb'
      expect(dictionary.exists_entry? 'example verb').to be false
    end

    it 'deletes adjectives from the database' do
      dictionary.delete_entry 'example adjective'
      expect(dictionary.exists_entry? 'example adjective').to be false
    end
  end

  describe '#extract_entries_with_meaning' do
    it 'extracts entry containing a unique meaning' do
      matching_entries = dictionary.extract_entries_with_meaning('dog')
      expect(matching_entries.size).to eq 1
      expect(matching_entries[0].entry).to eq 'Hund'
    end

    it 'extracts entries containing a non-unique meaning' do
      matching_entries = dictionary.extract_entries_with_meaning('lovely')
      expect(matching_entries.size).to eq 2
      found_entries = matching_entries.map { |word| word.entry }
      expect(found_entries).to include 'schön'
      expect(found_entries).to include 'hübsch'
    end

    it 'returns empty array when no entry matches meaning' do
      matching_entries = dictionary.extract_entries_with_meaning('example')
      expect(matching_entries.size).to eq 0
    end

    it 'only returns entries with matching whole words in meaning' do
      matching_entries = dictionary.extract_entries_with_meaning('hand')
      expect(matching_entries.size).to eq 1
      expect(matching_entries[0].entry).to eq 'Hand'
    end
  end

  describe '#edit_entry' do
    it 'edits the entry field of a given entry' do
      expect(dictionary.exists_entry? 'Bier').to be false
      expect(dictionary.exists_entry? 'Haut').to be true
      dictionary.edit_entry('Haut', 'Entry', 'Bier')

      expect(dictionary.exists_entry? 'Bier').to be true
      expect(dictionary.exists_entry? 'Haut').to be false
      dictionary.edit_entry('Bier', 'Entry', 'Haut')

      expect(dictionary.exists_entry? 'Bier').to be false
      expect(dictionary.exists_entry? 'Haut').to be true
    end

    it 'edits the meaning field of a given entry' do
      original_meaning = dictionary.extract_entry('Haut').meaning
      dictionary.edit_entry('Haut', 'Meaning', 'not skin')

      expect(dictionary.extract_entry('Haut').meaning).to eq 'not skin'
      dictionary.edit_entry('Haut', 'Meaning', original_meaning)
      expect(dictionary.extract_entry('Haut').meaning).to eq original_meaning
    end

    it 'edits the example field of a given entry' do
      original_examples = dictionary.extract_entry('Haut').examples
      dictionary.edit_entry('Haut', 'Examples', 'useless example')

      expect(dictionary.extract_entry('Haut').examples).to eq 'useless example'
      dictionary.edit_entry('Haut', 'Examples', original_examples)
      expect(dictionary.extract_entry('Haut').examples).to eq original_examples
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



describe '#add_entry' do
    it 'adds nouns to the database' do
      dictionary = German::Dictionary.new
      example_noun = Noun.new({"entry" => "example_noun",
                               "meaning" => "meaning",
                               "gender" => "gender",
                               "plural" => "plural",
                               "genetive" => "genetive",
                               "examples" => "examples",
                              })

      expect(example_noun.entry).to eq 'Hund'
    end

=end