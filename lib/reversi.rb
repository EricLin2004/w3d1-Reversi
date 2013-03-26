require 'debugger'
class Board
  attr_accessor :pos

  def initialize
    @pos = Array.new(8) {Array.new(8) {:empty}}

  end

  def valid_move?(move, player_color)
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
      space = @pos[vec[0] + move[0]][vec[1] + move[1]]
      next if space == :empty || space.nil?
      next if space == player_color
      i = 2
      direction_spaces = [[vec[0] + move[0],vec[1] + move[1]]]
      until space == :empty || off_board?([vec[0]*i + move[0],vec[1]*i + move[1]])
        if space == player_color
          pieces_to_flip += direction_spaces
          break
        end
        direction_spaces << [vec[0]*i + move[0],vec[1]*i + move[1]]
        space = @pos[vec[0]*i + move[0]][vec[1]*i + move[1]]
        i += 1
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


end

class Piece
  attr_accessor :color

  def initialize(color)
    @color = color
  end
end

class Game
end