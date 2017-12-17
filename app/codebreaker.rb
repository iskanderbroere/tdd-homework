class Codebreaker
  class Game
    attr_reader :output

    def initialize(output)
      @output = output
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
      run_if_valid_else
      puts_result
      clear_result
    end

    def run_if_valid_else
      if valid
        compare_exact
        compare_number_only
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
    end

    def clear_result
      @result.clear
    end
  end
end
