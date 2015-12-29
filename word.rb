module German
  class Word
    attr_accessor :entry, :meaning_groups

    def initialize(entry, meaning_groups = nil)
      @entry = entry
      @meaning_groups = Array.new

      @meaning_groups = meaning_groups if meaning_groups
    end
  end
end