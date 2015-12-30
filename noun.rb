require_relative 'word'

module German
  class Noun < Word
    attr_reader :gender, :plural, :genetive

    def initialize(description)
      super

      @gender = extract_gender(description)
      @plural = extract_plural(description)
      @genetive = extract_genetive(description)
    end

    private

    def extract_gender(description)
      matched_gender = /.+\*gender:(der|die|das)\*.+/.match description
      @gender = matched_gender[1]
    end

    def extract_plural(description)
      matched_plural = /.+\*plural:(.+)\*.+/.match description
      @plural = matched_plural[1]
    end

    def extract_genetive(description)
      matched_genetive = /.+\*gen:(.+)\*.+/.match description
      @genetive = matched_genetive[1]
    end
  end
end