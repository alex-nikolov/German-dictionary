require_relative 'word'

module German
  class Verb < Word
    attr_reader :forms, :auxiliary, :trans, :case

    def initialize(description)
      super

      @forms = extract('forms', description)
      @auxiliary = extract('aux', 'haben|sein', description)
      @transitive = extract('trans', 'true|false', description)
      @case = extract('case', 'akk|dat', description)
    end

    private

    def extract(item, possible_values = '.+', description)
      matched_data = /.+\*#{item}:(#{possible_values})\*.+/.match description
      matched_data[1]
    end
  end
end