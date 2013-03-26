require 'debugger'
class Board
  attr_accessor :pos

  def initialize
    @pos = Array.new(8) {Array.new(8) {:empty}}

  end

  def valid_move?(move, player_color)
    return false if off_board?(move)

    return false if occupied?(move)

    return false if no_flip?(move, player_color)

    true
  end

  def off_board?(move)
    move[0] < 0 || move[1] < 0 || move[0] > 7 || move[1] > 7
  end

  def occupied?(move)
    @pos[move[0]][move[1]] != :empty
  end

  def no_flip?(move, player_color)
    surrounding_spaces = [-1,0,1].product([-1,0,1]) #REV nice use of product 
    surrounding_spaces.delete_if {|x| x == [0,0]}

    surrounding_spaces.each do |vec|
      space = @pos[vec[0] + move[0]][vec[1] + move[1]]
      next if space == :empty || space.nil?
      next if space.color == player_color
      i = 3
      until space == :empty || off_board?([vec[0]*i + move[0],vec[1]*i + move[1]])
        return true if space.color == player_color
        space = @pos[vec[0]*i + move[0]][vec[1]*i + move[1]]
        i += 1
      end
    end
    false
  end


end

class Piece
end

class Game
end