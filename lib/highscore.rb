require 'sqlite3'

module German
  class HighScore
    attr_reader :time

    def initialize(score, database, name, quiz_name)
      @high_score = score
      @database = database
      @name = name
      @quiz_name = quiz_name

      @time = Time.new
      format_time
    end

    def write_to_table
      high_scores = SQLite3::Database.open @database
      high_scores.results_as_hash = true

      high_scores.execute "INSERT INTO #{@quiz_name} VALUES (#{@high_score},
                                                            '#{@name}',
                                                            '#{@time}')"

      high_scores.close if high_scores
    end

    def self.high_scores_to_s(database, quiz_name)
      self.high_scores(database, quiz_name, '')
    end

    def self.top_five_high_scores_to_s(database, quiz_name)
      additional_attribute = " ORDER BY Highscore DESC LIMIT 5"
      self.high_scores(database, quiz_name, additional_attribute)
    end

    def self.reset(database, quiz_name)
      high_scores = SQLite3::Database.open database
      high_scores.execute "DELETE FROM #{quiz_name}"
    end

    private

    def format_time
      @time = @time.strftime('%F %H:%M:%S')
    end

    def self.high_scores(database, quiz_name, additional_attribute = '')
      high_scores = SQLite3::Database.open database
      high_scores.results_as_hash = true
      run_statement = high_scores.execute "SELECT * FROM #{quiz_name}" +
                                         additional_attribute

      self.generate_string_with_high_scores(run_statement)
    end

    def self.generate_string_with_high_scores(run_statement)
      high_scores_array = []

      run_statement.each do |row|
        high_scores_array << "#{row['Highscore']}\t#{row['Name']}\t" +
                              "#{row['Time']}"
      end

      high_scores_array.join("\n")
    end
  end
end