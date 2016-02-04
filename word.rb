module German
  class Word
    attr_accessor :entry, :meaning, :examples

    def initialize(entry, meaning, examples)
      @entry = entry
      @meaning = meaning
      @examples = examples
    end
  end
end