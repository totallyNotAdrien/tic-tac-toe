require "pry-byebug"

class TicTacToe
  attr_reader :board, :show_position, :curr_player_index

  PLAYERS = ["X", "O"]

  def initialize(board_setup_arr = [])
    @show_position = true
    @curr_player_index = 0
    @board = Array.new(3) { Array.new(3, " ") }
    place_marks(board_setup_arr) unless board_setup_arr.empty?
  end

  public

  def play
    show_board(self.board)
    puts
    until winner?
      display_turn_info

      input = gets.chomp.strip
      puts

      handle_input(input)
    end
  end

  def show_board(board_to_show)
    display = []
    position = 1
    board_to_show.each_index do |row_index|
      row = []
      board_to_show[row_index].each_index do |col_index|
        if self.show_position
          if PLAYERS.include?(mark = board_to_show[row_index][col_index])
            row << mark
          else
            row << position.to_s
          end
          position += 1
        else
          row << board_to_show[row_index][col_index]
        end
      end
      display << row
    end

    display.each do |row|
      print row
      puts
    end
    puts
  end

  def handle_input(input)
    if input == "position" || input == "pos"
      @show_position = !self.show_position
      show_board(self.board)
      puts
    elsif valid_digit?(input) && valid_position?(position = input.to_i)
      place_mark(position)
    else
      show_board(self.board)
    end
  end

  def valid_digit?(char)
    digit?(char) && char.to_i != 0
  end

  def digit?(char)
    char.is_a?(String) && char.length == 1 && char >= "0" && char <= "9"
  end

  def valid_position?(position)
    row, col = position_to_grid_coords(position)
    if row && col
      val = self.board[row][col]
      return !PLAYERS.include?(val)
    end
    false
  end

  def position_to_grid_coords(position)
    if position.is_a?(Integer) && position.between?(1, 9)
      position -= 1
      return [position / 3, position % 3]
    end
    nil
  end

  def place_mark(position)
    row, col = position_to_grid_coords(position)
    if row && col
      @board[row][col] = PLAYERS[self.curr_player_index]
      @curr_player_index = (self.curr_player_index + 1) % 2
      show_board(self.board)
    end
  end

  def place_marks(position_arr, start_index = 0)
    return unless position_arr.all? {|pos| pos.is_a?(Integer)}

    @curr_player_index = start_index % 2
    position_arr.each do |pos|
      row, col = position_to_grid_coords(pos)
      if row && col
        @board[row][col] = PLAYERS[self.curr_player_index]
        @curr_player_index = (self.curr_player_index + 1) % 2
      end
    end
  end

  def winner?
    #horizontal
    winning_arrangement = check_horizontal_win(self.board)

    #vertical
    unless winning_arrangement
      flipped_board = row_col_flipped_board
      winning_arrangement = check_horizontal_win(flipped_board)
    end

    #diagonal
    #top left to bottom right
    unless winning_arrangement
      arr = [self.board[0][0], self.board[1][1], self.board[2][2]]
      winning_arrangement = arr if all_valid_and_same?(arr)
    end

    #bottom left to top right
    unless winning_arrangement
      arr = [self.board[2][0], self.board[1][1], self.board[0][2]]
      winning_arrangement = arr if all_valid_and_same?(arr)
    end

    #win or draw
    if winning_arrangement
      puts "#{winning_arrangement[0]} wins!"
      return true
    elsif board_full?
      puts "Draw!"
      return true
    end
    false
  end

  def check_horizontal_win(board_to_check)
    winning_arrangement = board_to_check.select do |row|
      all_valid_and_same?(row)
    end

    unless winning_arrangement.empty?
      winning_arrangement.flatten!
      winning_arrangement_index = nil

      board_to_check.each_index do |row|
        winning_arrangement_index = row if board_to_check[row].all? do |mark|
          mark == winning_arrangement[0]
        end
      end

      return winning_arrangement
    end
    nil
  end

  def all_valid_and_same?(arr)
    arr.is_a?(Array) && arr.all? { |mark| PLAYERS.include?(mark) && mark == arr[0] }
  end

  def row_col_flipped_board
    flipped_board = Array.new(3) { Array.new(3, " ") }
    self.board.each_index do |row|
      self.board[row].each_index do |col|
        flipped_board[row][col] = self.board[col][row]
      end
    end
    flipped_board
  end

  def board_full?
    spaces = self.board.flatten
    spaces.all? { |mark| PLAYERS.include?(mark) }
  end

  private

  def display_turn_info
    print "Player #{PLAYERS[self.curr_player_index]}'s Turn\n"
    puts
    print "Enter a position to make your mark (1-9), or 'position' \n" \
          "or 'pos' to toggle the numbered position display: "
  end
end

# game = TicTacToe.new
# game.play
