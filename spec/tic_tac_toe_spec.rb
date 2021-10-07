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

  describe "#place_marks" do
    subject(:game_marks) {described_class.new}

    context "when position_arr is an array of integers" do
      context "when position_arr has 4 positions" do
        let(:positions) {[1,2,5,9]}

        it "calls position_to_grid_coords 4 times" do
          expect(game_marks).to receive(:position_to_grid_coords).exactly(4).times
          game_marks.place_marks(positions)
        end

        it "places 4 marks accordingly" do
          expect { game_marks.place_marks(positions) }.to change {game_marks.board}.to([["X", "O", " "],[" ", "X", " "],[" ", " ", "O"]])
        end
      end

      context "when start_index is 1 (player O)" do
        let(:positions) {[1,2,5,9]}
        it "places marks accordingly" do
          expect { game_marks.place_marks(positions, 1) }.to change {game_marks.board}.to([["O", "X", " "],[" ", "O", " "],[" ", " ", "X"]])
        end
      end
    end

    context "when position_arr is not an array of integers" do
      let(:positions){["milk", 4, "13", {taco:4}]}

      it "returns nil" do
        expect(game_marks.place_marks(positions)).to be_nil
      end
    end
  end

  describe "#winner?" do
    context "when there are three of the same mark in a row" do
      context "when the marks are 'X's" do
        let(:game_winner_row) {described_class.new([1,4,2,5,3])}
        before do
          allow(game_winner_row).to receive(:puts)
          allow(game_winner_row).to receive(:check_horizontal_win).and_return(["X","X","X"])
        end

        it "displays winner" do
          expect(game_winner_row).to receive(:puts).with("X wins!")
          game_winner_row.winner?
        end
        it "returns true" do
          expect(game_winner_row).to be_winner
        end
      end

      context "when the marks are 'O's" do
        let(:game_winner_row) {described_class.new([1,4,7,5,2,6])}
        before do
          allow(game_winner_row).to receive(:puts)
          allow(game_winner_row).to receive(:check_horizontal_win).and_return(["O","O","O"])
        end

        it "displays winner" do
          expect(game_winner_row).to receive(:puts).with("O wins!")
          game_winner_row.winner?
        end
        it "returns true" do
          expect(game_winner_row).to be_winner
        end
      end
    end

    context "when there are three of the same mark in a column" do
      context "when the marks are 'X's" do
        let(:game_winner_col) {described_class.new([2,1,5,4,8])}
        before do
          allow(game_winner_col).to receive(:puts)
          allow(game_winner_col).to receive(:check_horizontal_win).and_return(["X","X","X"])
        end

        it "displays winner" do
          expect(game_winner_col).to receive(:puts).with("X wins!")
          game_winner_col.winner?
        end
        it "returns true" do
          expect(game_winner_col).to be_winner
        end
      end

      context "when the marks are 'O's" do
        let(:game_winner_col) {described_class.new([2,3,1,6,5,9])}
        before do
          allow(game_winner_col).to receive(:puts)
          allow(game_winner_col).to receive(:check_horizontal_win).and_return(["O","O","O"])
        end

        it "displays winner" do
          expect(game_winner_col).to receive(:puts).with("O wins!")
          game_winner_col.winner?
        end
        it "returns true" do
          expect(game_winner_col).to be_winner
        end
      end
    end

    context "when there are three of the same mark on a diagonal" do
      context "when the diagonal is top left to bottom right" do
        context "when the marks are 'X's" do
          let(:game_winner_diag) {described_class.new([1,4,5,8,9])}
          before do
            allow(game_winner_diag).to receive(:puts)
            allow(game_winner_diag).to receive(:all_valid_and_same?).and_return(true)
          end

          it "displays winner" do
            expect(game_winner_diag).to receive(:puts).with("X wins!")
            game_winner_diag.winner?
          end
          it "returns true" do
            expect(game_winner_diag).to be_winner
          end
        end
      end

      context "when the diagonal is bottom left to top right" do
        context "when the marks are 'O's" do
          let(:game_winner_diag) {described_class.new([1,7,9,5,6,3])}
          before do
            allow(game_winner_diag).to receive(:puts)
          end

          it "displays winner" do
            expect(game_winner_diag).to receive(:puts).with("O wins!")
            game_winner_diag.winner?
          end
          it "returns true" do
            expect(game_winner_diag).to be_winner
          end
        end
      end
    end

    context "when the board does not have three consecutive matching marks anywhere" do
      context "when the board is full" do
        let(:game_winner_full) {described_class.new([1,5,4,7,3,2,8,6,9])}
        before do
          allow(game_winner_full).to receive(:puts)
        end
        it "puts 'Draw!'" do
          expect(game_winner_full).to receive(:puts).with("Draw!")
          game_winner_full.winner?
        end

        it "returns true" do
          expect(game_winner_full).to be_winner
        end
      end

      context "when the board is not full" do
        let(:game_winner_not_full) {described_class.new([1,2,3,4])}
        it "returns false" do
          expect(game_winner_not_full).not_to be_winner
        end
      end
    end
  end

  describe "#check_horizontal_win" do
    let(:x){"X"}
    let(:o){"O"}
    context "when there is no winner" do
      let(:game_horiz){described_class.new([1,2,3,4])}

      it "returns nil" do
        expect(game_horiz.check_horizontal_win).to be_nil
      end
    end

    context "when there is a winner(X) in the first row" do
      let(:game_horiz){described_class.new([1,4,2,5,3])}

      before do
        allow(game_horiz).to receive(:all_valid_and_same?).and_return(true,false,false)
      end

      it "returns ['X','X','X']" do
        expect(game_horiz.check_horizontal_win).to eql([x,x,x])
      end
    end

    context "when there is a winner(O) in the second row" do
      let(:game_horiz){described_class.new([1,4,7,5,2,6])}

      before do
        allow(game_horiz).to receive(:all_valid_and_same?).and_return(false,true,false)
      end

      it "returns ['O','O','O']" do
        expect(game_horiz.check_horizontal_win).to eql([o,o,o])
      end
    end

    context "when there is a winner(X) in the third row" do
      let(:game_horiz){described_class.new([7,4,8,5,9])}

      before do
        allow(game_horiz).to receive(:all_valid_and_same?).and_return(false,false,true)
      end

      it "returns ['X','X','X']" do
        expect(game_horiz.check_horizontal_win).to eql([x,x,x])
      end
    end
  end

  describe "#all_valid_and_same?" do
    let(:x){"X"}
    let(:o){"O"}
    let(:game_valid_same){described_class.new}
    context "when chars are all valid and same char" do
      let(:arr_valid_same){[x,x,x]}

      it "returns true" do
        expect(game_valid_same).to be_all_valid_and_same(arr_valid_same)
      end
    end

    context "when chars are all valid, but different chars" do
      let(:arr_valid_not_same){[x,o,x]}

      it "returns false" do
        expect(game_valid_same).to_not be_all_valid_and_same(arr_valid_not_same)
      end
    end

    context "when chars are not all valid" do
      let(:arr_not_valid){["M",1,o]}

      it "returns false" do
        expect(game_valid_same).to_not be_all_valid_and_same(arr_not_valid)
      end
    end
  end

  describe "#row_col_flipped_board" do
    let(:x){"X"}
    let(:o){"O"}
    let(:b){" "}
    context "when the board is empty" do
      let(:game_flip_empty){described_class.new}

      it "returns flipped board" do
        expect(game_flip_empty.row_col_flipped_board).to eql([[b,b,b],[b,b,b],[b,b,b]])
      end
    end

    context "when the board is partially full" do
      let(:game_flip_partial){described_class.new([1,2,3,4,5])}

      it "returns flipped board" do
        expect(game_flip_partial.row_col_flipped_board).to eql([[x,o,b],[o,x,b],[x,b,b]])
      end
    end

    context "when the board is full" do
      let(:game_flip_full){described_class.new([1,2,3,4,5,6,8,7,9])}

      it "returns flipped board" do
        expect(game_flip_full.row_col_flipped_board).to eql([[x,o,o],[o,x,x],[x,o,x]])
      end
    end
  end

  describe "#board_full?" do
    context "when board is empty" do
      let(:game_full_empty){described_class.new}

      it "returns false" do
        expect(game_full_empty).to_not be_board_full
      end
    end

    context "when board is partially full" do
      let(:game_full_partial){described_class.new([1,2,3,4,5])}

      it "returns false" do
        expect(game_full_partial).to_not be_board_full
      end
    end

    context "when board is almost full" do
      let(:game_full_almost){described_class.new([1,2,3,4,5,6,8,7])}

      it "returns false" do
        expect(game_full_almost).to_not be_board_full
      end
    end

    context "when board is full" do
      let(:game_full_almost){described_class.new([1,2,3,4,5,6,8,7,9])}

      it "returns true" do
        expect(game_full_almost).to be_board_full
      end
    end
  end
end