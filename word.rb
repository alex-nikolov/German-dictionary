module German
  class Word
    attr_accessor :entry, :meaning

    def initialize(description)
      @entry = extract_entry(description)
      @meaning = extract_meaning(description)
    end

    private

    def extract_entry(description)
      @entry = description.partition('*').first[1..-1]
    end

    def extract_meaning(description)
      @meaning = description.partition('*')[1..2].join
    end
  end
end