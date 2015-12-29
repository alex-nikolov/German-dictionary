module German
  class MeaningGroup
    attr_accessor :metadata, :meanings

    def initialize(metadata = nil, meanings = nil)
      @metadata = String.new
      @meanings = Array.new

      @metadata = metadata if metadata
      @meanings = meanings if meanings
    end
  end
end