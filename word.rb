module German
  class Word
    attr_accessor :entry, :meaning, :type

    def initialize(description)
      @entry = extract_entry(description)
      @meaning = extract_meaning(description)
      @type = extract_type(description)
    end

    private

    def extract_entry(description)
      @entry = description.partition('*').first[1..-1]
    end

    def extract_meaning(description)
      @meaning = description.partition('*')[1..2].join
    end

    def extract_type(description)
      word_match = /.+\*(verb|noun|adj)\*.+/.match description
      @type = word_match[1]
    end
  end
end