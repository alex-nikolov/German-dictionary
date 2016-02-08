require 'sqlite3'

module German
  class Highscore
    attr_reader :time

    def initialize(score, database, name)
      @highscore = score
      @database = database
      @name = name

      @time = Time.new
      format_time
    end

    def write_to_table
      highscores = SQLite3::Database.open @database
      highscores.results_as_hash = true

      highscores.execute "INSERT INTO Highscores VALUES(#{@highscore},
                                                        '#{@name}',
                                                        '#{@time}')"

      highscores.close if highscores
    end

    def self.highscores_to_s(database)
      self.highscores(database, '')
    end

    def self.top_five_highscores_to_s(database)
      self.highscores(databse, 'LIMIT 5 ORDER BY Highscore DESC')
    end

    def self.reset(database)
      highscores = SQLite3::Database.open database
      highscores.execute "DELETE FROM Highscores"
    end

    private

    def format_time
      @time = @time.strftime('%F %H:%M:%S')
    end

    def self.highscores(database, additional_attribute = '')
      highscores = SQLite3::Database.open database
      highscores.results_as_hash = true
      run_statement = highscores.execute "SELECT * FROM Highscores" +
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