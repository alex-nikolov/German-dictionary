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

    it 'edits the gender of a noun' do
      original_gender = dictionary.extract_entry('Haut').gender
      dictionary.edit_entry('Haut', 'Gender', 'der')

      expect(dictionary.extract_entry('Haut').gender).to eq 'der'
      dictionary.edit_entry('Haut', 'Gender', original_gender)
      expect(dictionary.extract_entry('Haut').gender).to eq original_gender
    end

    it 'edits the plural of a noun' do
      original_plural = dictionary.extract_entry('Haut').plural
      dictionary.edit_entry('Haut', 'Plural', 'Hauten')

      expect(dictionary.extract_entry('Haut').plural).to eq 'Hauten'
      dictionary.edit_entry('Haut', 'Plural', original_plural)
      expect(dictionary.extract_entry('Haut').plural).to eq original_plural
    end

    it 'edits the genetive of a noun' do
      original_genetive = dictionary.extract_entry('Haut').genetive
      dictionary.edit_entry('Haut', 'Genetive', 'Hauten')

      expect(dictionary.extract_entry('Haut').genetive).to eq 'Hauten'
      dictionary.edit_entry('Haut', 'Genetive', original_genetive)
      expect(dictionary.extract_entry('Haut').genetive).to eq original_genetive
    end

    it 'edits the comparative form of an adjective' do
      original_comparative = dictionary.extract_entry('kalt').comparative
      dictionary.edit_entry('kalt', 'Comparative', 'comparative')

      expect(dictionary.extract_entry('kalt').comparative).to eq 'comparative'
      dictionary.edit_entry('kalt', 'Comparative', original_comparative)
      expect(dictionary.extract_entry('kalt').comparative).to eq original_comparative
    end

    it 'edits the superlative form of an adjective' do
      original_superlative = dictionary.extract_entry('kalt').superlative
      dictionary.edit_entry('kalt', 'Superlative', 'superlative')

      expect(dictionary.extract_entry('kalt').superlative).to eq 'superlative'
      dictionary.edit_entry('kalt', 'Superlative', original_superlative)
      expect(dictionary.extract_entry('kalt').superlative).to eq original_superlative
    end

    it 'edits the case of a verb' do
      original_case = dictionary.extract_entry('anschauen').case
      dictionary.edit_entry('anschauen', 'Used_case', 'dat')

      expect(dictionary.extract_entry('anschauen').case).to eq 'dat'
      dictionary.edit_entry('anschauen', 'Used_case', original_case)
      expect(dictionary.extract_entry('anschauen').case).to eq original_case
    end

    it 'edits the preposition used with a verb' do
      original_preposition = dictionary.extract_entry('anschauen').preposition
      dictionary.edit_entry('anschauen', 'Preposition', 'auf')

      expect(dictionary.extract_entry('anschauen').preposition).to eq 'auf'
      dictionary.edit_entry('anschauen', 'Preposition', original_preposition)
      expect(dictionary.extract_entry('anschauen').preposition).to eq original_preposition
    end

    it 'edits the quality of a verb to be separable' do
      original_separable = dictionary.extract_entry('anschauen').separable
      dictionary.edit_entry('anschauen', 'Separable', 'no')

      expect(dictionary.extract_entry('anschauen').separable).to eq 'no'
      dictionary.edit_entry('anschauen', 'Separable', original_separable)
      expect(dictionary.extract_entry('anschauen').separable).to eq original_separable
    end

    it 'edits the forms of a verb' do
      original_forms = dictionary.extract_entry('anschauen').forms
      dictionary.edit_entry('anschauen', 'Forms', 'anschauen-anschun-angeschauen')

      expect(dictionary.extract_entry('anschauen').forms).to eq 'anschauen-anschun-angeschauen'
      dictionary.edit_entry('anschauen', 'Forms', original_forms)
      expect(dictionary.extract_entry('anschauen').forms).to eq original_forms
    end

    it 'edits the quality of a verb to be transitive' do
      original_transitive = dictionary.extract_entry('anschauen').transitive
      dictionary.edit_entry('anschauen', 'Transitive', 'no')

      expect(dictionary.extract_entry('anschauen').transitive).to eq 'no'
      dictionary.edit_entry('anschauen', 'Transitive', original_transitive)
      expect(dictionary.extract_entry('anschauen').transitive).to eq original_transitive
    end

    it 'raises an exception when entry is not found' do
      expect{ dictionary.edit_entry('Missing', 'Forms', '-') }.to raise_error(StandardError, /Entry not found/)
    end

    it 'raises an exception when attempting to edit an invalid field' do
      expect{ dictionary.edit_entry('kalt', 'Forms', '-') }.to raise_error(StandardError, /Invalid field/)
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