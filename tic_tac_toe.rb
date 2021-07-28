class TicTacToe
  attr_reader :board, :show_position

  PLAYERS = ["X", "O"]

  def initialize
    @show_position = true
    @curr_player_index = 0
    @board = Array.new(3) { Array.new(3, " ") }
  end

  public

  def play
    show_board
    puts
    until winner?
      print "Enter a position to make your mark (1-9), or 'position' \n" \
            "or 'pos' to toggle the numbered position display: "
      input = gets.chomp.strip
      if input == "position" || input == "pos"
        @show_position = !self.show_position
        show_board
        puts
        next
      elsif valid_digit?(input)
        pos = input.to_i
      end
    end
  end

  def show_board
    display = []
    position = 1
    self.board.each_index do |row_index|
      row = []
      self.board[row_index].each_index do |col_index|
        if self.show_position
          row << position.to_s
          position += 1
        else
          row << self.board[row_index][col_index]
        end
      end
      display << row
    end

    display.each do |row|
      print row
      puts
    end
  end

  private

  def place_mark(position)
  end

  def winner?
    false
  end

  def digit?(char)
    char.is_a? String && char.length == 1 && char >= "0" && char <= "9"
  end

  def valid_digit?(char)
    digit?(char) && char.to_i != 0
  end

  def valid_position?(pos)
  end
#here---------------------------------------------------
  def to_grid_coords(position)
    if position.is_a? Integer && position.between(1, 9)
      position -= 1
      return [position / 3, position % 3]
    end
    nil
  end
end

game = TicTacToe.new

game.play
