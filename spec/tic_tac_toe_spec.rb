require "../lib/tic_tac_toe.rb"

describe TicTacToe do
  describe "#handle_input" do
    subject(:game_input){described_class.new}

    context "when player enters 'position' or 'pos'" do
      let(:input) {String.new("position")}

      before do
        allow(game_input).to receive(:show_board)
      end

      it "toggles display of the numbered positions" do
        display_state = game_input.show_position
        expect {game_input.handle_input(input)}.to change {game_input.instance_variable_get(:@show_position)}.to(!display_state)
      end

      it "sends show_board" do
        expect(game_input).to receive(:show_board).once
        game_input.handle_input(input)
      end
    end

    context "when input is valid digit" do
      before do
        allow(game_input).to receive(:valid_digit?).and_return(true)
        allow(game_input).to receive(:place_mark)
      end

      context "when input is valid position" do
        before do
          allow(game_input).to receive(:valid_position?).and_return(true)
        end

        it "sends place_mark" do
          expect(game_input).to receive(:place_mark).once
          game_input.handle_input("3")
        end
      end

      context "when input is NOT valid position" do
        before do
          allow(game_input).to receive(:valid_position?).and_return(false)
          allow(game_input).to receive(:show_board)
        end

        it "does not send place_mark" do
          expect(game_input).not_to receive(:place_mark)
          game_input.handle_input("10")
        end

        it "sends show_board" do
          expect(game_input).to receive(:show_board).once
          game_input.handle_input("10")
        end
      end
    end

    context "when input is NOT valid digit" do
      before do
        allow(game_input).to receive(:valid_digit?).and_return(false)
        allow(game_input).to receive(:place_mark)
        allow(game_input).to receive(:show_board)
      end

      it "does not send place_mark" do
        expect(game_input).not_to receive(:place_mark)
        game_input.handle_input("123")
      end

      it "sends show_board" do
        expect(game_input).to receive(:show_board).once
        game_input.handle_input("123")
      end

      #do not need to test specifically valid_position? here because "input"
      #refers to the same thing for both methods, so if input is not a valid digit,
      #it can't be a valid position. valid_digit? must come before valid_position?
    end
  end

  describe "#valid_digit?" do
    subject(:game_valid_digit) {described_class.new}

    context "when char is digit" do
      before do
        allow(game_valid_digit).to receive(:digit?).and_return(true)
      end

      context "when char is not '0'" do
        it "returns true" do
          char = "5"
          expect(game_valid_digit).to be_valid_digit(char)
        end
      end

      context "when char is '0'" do
        it "returns false" do
          char = "0"
          expect(game_valid_digit).not_to be_valid_digit(char)
        end
      end
    end

    context "when char is not digit" do
      before do
        allow(game_valid_digit).to receive(:digit?).and_return(false)
      end

      it "returns false" do
        char = "milk"
        expect(game_valid_digit).not_to be_valid_digit(char)
      end
    end
  end

  describe "#digit?" do
    subject(:game_digit) {described_class.new}
    context "when char is a single-character string between '0' and '9'" do
      it "returns true" do
        char = "7"
        expect(game_digit).to be_digit(char)
      end
    end

    context "when char is not a string" do
      it "returns false" do 
        char = 7
        expect(game_digit).not_to be_digit(char)
      end
    end

    context "when char is not a single character" do 
      it "returns false" do
        char = "77"
        expect(game_digit).not_to be_digit(char)
      end
    end

    context "when char is not between '0' and '9'" do
      it "returns false" do
        char = "T"
        expect(game_digit).not_to be_digit(char)
      end
    end
  end

  describe "#valid_position?" do
    subject(:game_position) {described_class.new}

    context "when position is in bounds" do
      let(:position) {4}

      context "when position is available" do
        it "returns true" do
          board = game_position.board
          board[0][0] = "X"
          board[1][1] = "O"
          #game_position.show_board(game_position.board)
          expect(game_position).to be_valid_position(position)
        end
      end

      context "when position is already taken" do
        it "returns false" do
          board = game_position.board
          board[0][0] = "X"
          board[1][0] = "O"
          #game_position.show_board(game_position.board)
          expect(game_position).not_to be_valid_position(position)
        end
      end
    end

    context "when position is out of bounds" do
      it "returns false" do
        position = 10
        expect(game_position).not_to be_valid_position(position)
      end
    end
  end

  describe "#position_to_grid_coords" do
    subject(:game_coords) {described_class.new}

    context "when position is an integer between 1 and 9" do
      context "when position is 4" do
        it "returns [1,0]" do
          position = 4
          expect(game_coords.position_to_grid_coords(position)).to eql([1,0])
        end
      end

      context "when position is 9" do
        it "returns [2,2]" do
          position = 9
          expect(game_coords.position_to_grid_coords(position)).to eql([2,2])
        end
      end

      context "when position is 1" do
        it "returns [0,0]" do
          position = 1
          expect(game_coords.position_to_grid_coords(position)).to eql([0,0])
        end
      end
    end

    context "when position is not an integer" do
      it "returns nil" do
        position = 1.0
        expect(game_coords.position_to_grid_coords(position)).to be_nil
      end
    end

    context "when position is not between 1 and 9" do
      it "returns nil" do
        position = 10
        expect(game_coords.position_to_grid_coords(position)).to be_nil
      end
    end
  end

  describe "#place_mark" do
    subject(:game_place) {described_class.new}
    before do
      allow(game_place).to receive(:show_board)
    end

    context "when position is between 1 and 9" do
      context "when curr player is 'X'" do
        before do
          allow(game_place).to receive(:curr_player_index).and_return(0)
        end
        context "when position is 4" do
          it "changes board[1][0] to 'X'" do
            position = 4
            expect {game_place.place_mark(position)}.to change {game_place.board[1][0]}.to("X")
          end
        end
      end

      context "when curr player is 'O'" do
        before do
          allow(game_place).to receive(:curr_player_index).and_return(1)
        end
        context "when position is 8" do
          it "changes board[2][1] to 'O'" do
            position = 8
            expect {game_place.place_mark(position)}.to change {game_place.board[2][1]}.to("O")
          end
        end
      end
    end

    context "when position is out of bounds" do 
      context "when position is 0" do
        it "does not change board" do
          position = 0
          expect {game_place.place_mark(position)}.not_to change {game_place.board}
        end
      end

      context "when position is 14" do
        it "does not change board" do
          position = 14
          expect {game_place.place_mark(position)}.not_to change {game_place.board}
        end
      end
    end
  end
end