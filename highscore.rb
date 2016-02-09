require 'sqlite3'

module German
  class Highscore
    attr_reader :time

    def initialize(score, database, name, quiz_name)
      @highscore = score
      @database = database
      @name = name
      @quiz_name = quiz_name

      @time = Time.new
      format_time
    end

    def write_to_table
      highscores = SQLite3::Database.open @database
      highscores.results_as_hash = true

      highscores.execute "INSERT INTO #{@quiz_name} VALUES(#{@highscore},
                                                          '#{@name}',
                                                          '#{@time}')"

      highscores.close if highscores
    end

    def self.highscores_to_s(database, quiz_name)
      self.highscores(database, quiz_name, '')
    end

    def self.top_five_highscores_to_s(database, quiz_name)
      self.highscores(databse, quiz_name, 'LIMIT 5 ORDER BY Highscore DESC')
    end

    def self.reset(database, quiz_name)
      highscores = SQLite3::Database.open database
      highscores.execute "DELETE FROM #{quiz_name}"
    end

    private

    def format_time
      @time = @time.strftime('%F %H:%M:%S')
    end

    def self.highscores(database, quiz_name, additional_attribute = '')
      highscores = SQLite3::Database.open database
      highscores.results_as_hash = true
      run_statement = highscores.execute "SELECT * FROM #{quiz_name}" +
                                         additional_attribute

      self.generate_string_with_highscores(run_statement)
    end

    def self.generate_string_with_highscores(run_statement)
      highscores_array = []

      run_statement.each do |row|
        highscores_array << "#{row['Highscore']}\t#{row['Name']}\t" +
                              "#{row['Time']}"
      end

      highscores_array.join("\n")
    end
  end
end

# rspec highscore_spec.rb --require ./highscore.rb --colour --format documentation