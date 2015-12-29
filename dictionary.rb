require 'io/console'
require 'avl_tree'

require_relative 'noun'
require_relative 'verb'

module German
  class Dictionary
    attr_reader :entries, :verbs

    def initialize(file_name)
      lines_read = IO.readlines(file_name)
      @entries = AVLTree.new
      @verbs = AVLTree.new

      parse_lines_to_entries(lines_read)
    end

    def add_noun(noun)
      @entries[noun.entry] = noun.meaning
    end

    def add_verb(verb)
      @entries[verb.entry] = verb.meaning
      @verbs[verb.entry] = verb.meaning
    end

    def add_adj(adj)
      @entries[adj.entry] = adj.meaning
    end

    private

    def parse_word_type(line)
      if line.include? '*noun*'
        'noun'
      elsif line.include? '*verb*'
        'verb'
      elsif line.include? '*adj*'
        'adj'
      end
    end

    def parse_lines_to_entries(lines)
      new_entries_indexes = lines_with_new_entries(lines)
      puts new_entries_indexes.to_s
      new_entries_indexes.each do |word_first_line, word_last_line|
        word_lines = lines[word_first_line..word_last_line].join
        case parse_word_type(lines[word_first_line])
          when 'noun'
            add_noun(Noun.new(word_lines))
          when 'verb'
            add_verb(Verb.new(word_lines))
          when 'adj'
            add_adj(Adj.new(word_lines))
        end
      end
    end

    def lines_with_new_entries(lines)
      new_entries_start_indexes = Array.new
      lines.each_with_index do |line, index|
        if line[0] == '@'
          new_entries_start_indexes << index
        end
      end

      new_entries_end_indexes = new_entries_start_indexes.map { |index| index - 1 }
      new_entries_end_indexes.shift
      new_entries_end_indexes << lines.length - 1
      Hash[new_entries_start_indexes.zip new_entries_end_indexes]
    end
  end
end