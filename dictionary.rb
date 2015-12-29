module German
  class Dictionary
    def initialize(file_name)
      @lines_read = file_name.readlines
      parse_lines_to_entries
    end

    def add_noun(noun)
      @entries << noun
    end

    def add_verb(verb)
      @entries << verb
    end

    def add_adj(adj)
      @entries << adj
    end

    private

    def parse_word_type(line)
      if line.includes? '*noun*'
        'noun'
      elsif line.includes? '*verb*'
        'verb'
      elsif line.includes? '*adj*'
        'adj'
      end
    end

    def parse_lines_to_entries(lines)
      new_entries_indexes = lines_with_new_entries(lines)
      new_entries_indexes.each_with_index do |new_entry_index, index_of_index|
        case parse_word_type(lines[new_entry_index])
          when 'noun'
            add_noun(Noun.new(lines[new_entry_index...index_of_index]).join)
          when 'verb'
            add_verb(Verb.new(lines[new_entry_index...index_of_index]).join)
          when 'adj'
            add_adj(Adj.new(lines[new_entry_index...index_of_index]).join)
          end
        end
      end
    end

    def lines_with_new_entries(lines)
      new_entries_indexes = Array.new
      lines.each_with_index do |line, index|
        if line.first == '@'
          new_entries_indexes << index
        end
      end

      new_entries_indexes << lines.size
    end
  end
end