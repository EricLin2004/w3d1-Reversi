require 'debugger'
class Board
  attr_accessor :pos

  def initialize
    @pos = Array.new(8) {Array.new(8) {:empty}}
  end

  def starting_board
    @pos[3][3] = :white
    @pos[4][4] = :white
    @pos[3][4] = :black
    @pos[4][3] = :black
  end

  def valid_move?(move, player_color)
    return false if move.count != 2
  #  p 'off'
    return false if off_board?(move)
  #  p 'occ'
    return false if occupied?(move)
 #   p 'flip'
    return false if no_flip?(move, player_color)
 #   p 'off'
    true
  end

  def off_board?(move)
    move[0] < 0 || move[1] < 0 || move[0] > 7 || move[1] > 7
  end

  def occupied?(move)
    @pos[move[0]][move[1]] != :empty
  end

  def no_flip?(move, player_color)
    pieces_to_flip(move, player_color).empty?
  end

  def pieces_to_flip(move, player_color)
    surrounding_spaces = [-1,0,1].product([-1,0,1])
    surrounding_spaces.delete_if {|x| x == [0,0]}
    pieces_to_flip = []

    surrounding_spaces.each do |vec|
      i = 1
      #debugger if move == [7,3]
      y = vec[0]*i + move[0]
      x = vec[1]*i + move[1]
      next if off_board?([y,x])
      space = @pos[y][x]
      next if space == :empty || space.nil?
      next if space == player_color
      direction_spaces = []
      until space == :empty || off_board?([y,x])
        space = @pos[y][x]
        if space == player_color
          pieces_to_flip += direction_spaces
          break
        end
        direction_spaces << [y,x]
        i += 1
        y = vec[0]*i + move[0]
        x = vec[1]*i + move[1]
      end
    end
    pieces_to_flip
  end

  def make_move(move, player_color)
    if valid_move?(move, player_color)
      @pos[move[0]][move[1]] = player_color
      pieces_to_flip(move, player_color).each do |y, x|
        @pos[y][x] = player_color == :black ? :black : :white
      end
    else
      raise "Invalid move."
    end
  end

  def count_pieces
    color_count = Hash.new(0)
    @pos.each do |row|
      row.each do |space|
       if space == :black
         color_count[:black] += 1
       elsif space == :white
         color_count[:white] += 1
       end
      end
    end
    color_count
  end

  def game_over?(player_color)
    if count_pieces.values.inject(&:+) == 64
      true
    else
      @pos.each_with_index do |row, row_index|
        row.each_index do |col_index|
          return false if valid_move?([row_index, col_index], player_color)
        end
      end
      true
    end
  end

  def display
    @pos.each do |row|
      row.each do |space|
        output = "B" if space == :black
        output = "W" if space == :white
        output = "-" if space == :empty
        printf output
      end
      puts
    end
  end

  def who_won
    count_pieces.max_by {|k, v| v}[0]
  end
end


class Game
  attr_reader :current_player
  attr_accessor :gameboard

  def initialize
    @gameboard = Board.new
    @gameboard.starting_board
    @player1 = AIPlayer.new(:black)
    @player2 = AIPlayer.new(:white)
    @current_player = @player1
  end

  def run
    until @gameboard.game_over?(@current_player.color)
      puts
      @gameboard.display
      move = @current_player.get_move(@gameboard)
      until @gameboard.valid_move?(move, @current_player.color)
        puts "move: #{move}"
        puts "Invalid move, try again. ex. 1,2"
        move = @current_player.get_move(@gameboard)
      end
      play_turn(move)
      @current_player = (@current_player == @player1) ? @player2 : @player1
    end

    @gameboard.display
    puts "Black: #{@gameboard.count_pieces[:black]}; " +
         "White: #{@gameboard.count_pieces[:white]}"
    puts "#{@gameboard.who_won}".capitalize + " Player wins!"
  end

  def play_turn(move)
    @gameboard.make_move(move, @current_player.color)
  end
end

class Player
  attr_reader :color

  def initialize(color)
    @color = color
  end

end

class HumanPlayer < Player
  def initialize(color)
    super(color)
  end

  def get_move(board)
    puts "#{color}".capitalize + " Player's Turn, enter your move. ex. 2,4"
    gets.chomp.scan(/\d/).map {|num_string| num_string.to_i}
  end
end

class AIPlayer < Player
  def initialize(color)
    super(color)
  end

  def get_move(board)
    puts "#{color}".capitalize + " Player's Turn"
    best_move = {}
    board.pos.each_with_index do |row, row_index|
      row.each_with_index do |space, col_index|
        if board.valid_move?([row_index, col_index], @color)
          best_move[[row_index, col_index]] =
            board.pieces_to_flip([row_index, col_index], @color).count
        end
      end
    end
    max_value = best_move.max_by {|k,v| v}[1]
    p computer_moves = best_move.keys.select{|key| best_move[key] == max_value}
    computer_moves.sample
  end
end

x = Game.new
x.run