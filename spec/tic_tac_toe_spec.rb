require "../lib/tic_tac_toe.rb"

describe TicTacToe do
  describe "#handle_input" do
    context "when player enters 'position' or 'pos'" do
      subject(:game_input){described_class.new}
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
  end
end