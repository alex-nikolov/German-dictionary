module German
  class Meaning
    attr_accessor :meaning

    def initialize(german_note = nil, meaning)
      @german_note = german_note if german_note
      @meaning = meaning
    end
  end
end