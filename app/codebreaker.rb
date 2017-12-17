class Codebreaker
  class Game
    attr_reader :output

    def initialize(output)
      @output = output
      @input = []
      @result = ''
    end

    def to_array(input)
      input.each_char.map(&:to_i)
    end

    def start(secret_number)
      @secret_number = to_array(secret_number)
      output.puts 'Welcome to Codebreaker'
      output.puts 'Enter guess:'
    end

    def guess(input)
      @input = to_array(input)
      run_if_valid
    end

    def run_if_valid
      if valid
        compare_exact
        compare_number_only
        puts_result
      else
        output.puts 'Try guessing a number with four digits'
      end
    end

    def valid
      @input.length == 4
    end

    def compare_exact
      @input.each_with_index do |n, index|
        if @secret_number[index] == n
          @result.prepend('+')
          @input -= [n]
        end
      end
    end

    def compare_number_only
      match = @input & @secret_number
      match.each { @result << '-' }
    end

    def puts_result
      output.puts @result
      @result.clear
    end
  end
end
