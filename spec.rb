describe 'Dictionary' do
  it 'loads entries from file' do
    dictionary = German::Dictionary.new('example.txt')
    expect(dictionary.entries.size).to eq 3
    expect(dictionary.entries.has_key? 'Hund').to be true
    expect(dictionary.entries.has_key? 'leisten').to be true
    expect(dictionary.entries.has_key? 'folgen').to be true
  end
end

describe 'Word' do
  it 'parses entry correctly' do
    word = German::Word.new('@example*noun*')
    expect(word.entry).to eq 'example'
    expect(word.meaning).to eq '*noun*'
  end
end

describe 'Hash test' do
  it 'jfsjfja' do
    h = { 1 => 45, 24 => 92 }
    expect(h).to include 1
  end
end