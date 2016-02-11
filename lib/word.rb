module German
  class Word
    attr_accessor :entry, :meaning, :examples

    def initialize(database_hash)
      @entry = database_hash['Entry']
      @meaning = database_hash['Meaning']
      @examples = database_hash['Examples']
    end
  end
end