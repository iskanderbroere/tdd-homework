require 'spec_helper'
require 'codebreaker' # load the file in app/codebreaker.rb

RSpec.describe Codebreaker do
  let(:game)    { Codebreaker::Game.new(output) }
  let(:output)  { double('output').as_null_object } # dont touch this

  context "when I start playing" do
    let(:secret_number) { '1234' }

    it "prints a greeting" do
      expect(output).to receive(:puts).with('Welcome to Codebreaker')

      game.start(secret_number)
    end

    it "asks for the first guess" do
      expect(output).to receive(:puts).with('Enter guess:')

      game.start(secret_number)
    end
  end

  describe "#guess" do
    context "[A] basic set up" do
      let(:secret_number) { '1234' }

      it "does not contain a getting started implementation" do
        game.start(secret_number)
        input = '1234'
        expect(output).not_to receive(:puts).with("you typed '1234'")

        game.guess(input)
      end

      context "wrong formatted guesses" do
        it "gives guidance" do
          game.start(secret_number)
          expect(output).to receive(:puts).with("Try guessing a number with four digits").twice

          game.guess('333')
          game.guess('55555')
        end

        it "does not leak answers" do
          game.start(secret_number)
          expect(output).not_to receive(:puts).with("+++")

          game.guess('123')
        end
      end

      context "correct formatted guess" do
        it "gives no guidance" do
          input = '4444'
          game.start(secret_number)
          expect(output).to_not receive(:puts).with("Try guessing a number with four digits")

          game.guess(input)
        end

        it "answers just once" do
          game.start(secret_number)
          expect(output).to receive(:puts).at_most(:once)
          game.guess('1234')
        end
      end
    end

    context "[B] with no matches" do
      let(:secret_number) { '2345' }

      it "sends a mark with ''" do
        game.start(secret_number)
        input = '6666'

        expect(output).to receive(:puts).with('')

        game.guess(input)
      end
    end

    context "[C] with 1 match" do
      let(:secret_number) { '3456' }

      it "A number match sends a mark with '-'" do
        game.start(secret_number)
        input = '4777'
        expect(output).to receive(:puts).with('-')

        game.guess(input)
      end

      it "An exact match sends a mark with '+'" do
        game.start(secret_number)
        input = '3777'
        expect(output).to receive(:puts).with('+')

        game.guess(input)
      end
    end

    context "[D] with 2 matches" do
      let(:secret_number) { '4567' }

      it "2 number matches sends a mark with '--'" do
        game.start(secret_number)
        input = '5611'
        expect(output).to receive(:puts).with('--')

        game.guess(input)
      end

      it "1 number match and 1 exact match (in that order) sends a mark with '+-'" do
        game.start(secret_number)
        input = '5161'
        expect(output).to receive(:puts).with('+-')

        game.guess(input)
      end

      it "1 exact match and 1 number match (in that order) sends a mark with '+-'" do
        game.start('1234')
        input = '4151'
        expect(output).to receive(:puts).with('+-')

        game.guess(input)
      end
    end

    context "[E] with 3 matches" do
      let(:secret_number) { '5678' }

      it "3 exact matches sends a mark with '+++'" do
        game.start(secret_number)
        input = '5671'
        expect(output).to receive(:puts).with('+++')

        game.guess(input)
      end

      it "3 number matches sends a mark with '---'" do
        game.start(secret_number)
        input = '9567'
        expect(output).to receive(:puts).with('---')

        game.guess(input)
      end

      it "2 exact matches and 1 number match (in that order) sends a mark with '++-'" do
        game.start(secret_number)
        input = '5607'
        expect(output).to receive(:puts).with('++-')

        game.guess(input)
      end

      it "1 exact match, 1 number match and 1 exact match (in that order) sends a mark with '++-'" do
        game.start(secret_number)
        input = '5760'
        expect(output).to receive(:puts).with('+--')

        game.guess(input)
      end

      it "1 number match and 2 exact matches (in that order) sends a mark with '++-'" do
        game.start(secret_number)
        input = '8670'
        expect(output).to receive(:puts).with('++-')

        game.guess(input)
      end
    end

    context "[F] with 4 matches" do
      let(:secret_number) { '6789' }

      it "4 exact matches sends a mark with '++++'" do
        game.start(secret_number)
        input = '6789'
        expect(output).to receive(:puts).with('++++')

        game.guess(input)
      end

      it "4 number matches sends a mark with '----'" do
        game.start(secret_number)
        input = '9876'
        expect(output).to receive(:puts).with('----')

        game.guess(input)
      end

      it "1 number match, 2 exact matches, and 1 number match (in that order) sends a mark with '++--'" do
        game.start(secret_number)
        input = '9786'
        expect(output).to receive(:puts).with('++--')

        game.guess(input)
      end
    end

    context "[G] with ambiguous matches" do
      let(:secret_number) { '1234' }
      it "number matches just count once" do
        game.start(secret_number)
        input = '5111'
        expect(output).to receive(:puts).with('-')

        game.guess(input)
      end

      it "an exact match at the start overrules a number match" do
        game.start(secret_number)
        input = '1111'
        expect(output).to receive(:puts).with('+')

        game.guess(input)
      end

      it "a number match at the end overrules a number match" do
        game.start(secret_number)
        input = '4444'
        expect(output).to receive(:puts).with('+')

        game.guess(input)
      end
    end
  end
end
