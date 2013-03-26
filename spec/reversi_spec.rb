require 'rspec'
require 'reversi.rb'

describe Board do
  subject(:board) {Board.new}

  # it "Should have four pieces in the middle" do
  #   board.pos[3][3].should == :black
  #   board.pos[3][3].should == :white
  #   board.pos[4][4].should == :white
  #   board.pos[3][4].should == :black
  #   board.pos[4][3].should == :black
  # end

  describe '#valid_move?' do
    let(:off_board_move) {[8,8]}
    let(:occupied_move) {[3,3]}
    let(:doesnt_flip_move) {[2,4]}

    it "the move is on the board" do
      board.valid_move?(off_board_move, :black).should be_false
    end

    it "the move location is empty" do
      board.pos[3][3] = :black
      board.valid_move?(occupied_move, :black).should be_false
    end

    it "the move flips an opponent's piece" do
      board.pos[2][3] = :white
      board.pos[1][3] = :black
      board.pos[2][1] = :black
      board.valid_move?(doesnt_flip_move, :black).should be_false
    end

    it "Accepts a valid move" do
      board.pos[2][3] = :black
      board.pos[3][3] = :white
      board.pos[4][3] = :white
      board.valid_move?([5,3], :black).should be_true
    end
  end

#  describe '#flip_piece' do
#
#  end

  describe '#make_move' do
    before(:each) do
      board.pos[3][3] = :white
      board.pos[4][3] = :white
      board.pos[3][4] = :white
      board.pos[4][4] = :white
    end

    describe "flipping pieces" do

      it 'flips pieces vertically' do
        board.pos[2][3] = :black
        board.make_move([5,3], :black)
        board.pos[3][3].should == :black && board.pos[4][3].should == :black
      end

      it 'flips pieces horizontally' do
        board.pos[4][2] = :black
        board.make_move([4,5], :black)
        board.pos[4][3].should == :black && board.pos[4][4].should == :black
      end

      it 'flips pieces diagonally' do
        board.pos[2][2] = :black
        board.make_move([5,5], :black)
        board.pos[3][3].should == :black && board.pos[4][4].should == :black
      end

    end
  end

  describe '#game_over?' do
    it 'returns true if board is full' do
      board.pos.each_with_index do |el1, row|
        el1.each_with_index do |el2, col|
          board.pos[row][col] = :black
        end
      end
      board.game_over?(:black).should be_true
    end

    it 'returns true if no moves available' do
      board.pos.each_with_index do |el1, row|
        el1.each_with_index do |el2, col|
          board.pos[row][col] = :white
        end
      end

      board.pos[3][7] = :empty
      board.pos[4][6] = :empty
      board.pos[4][7] = :empty
      board.pos[5][6] = :empty
      board.pos[6][7] = :empty
      board.pos[5][7] = :black

      board.game_over?(:white).should be_true
    end

  end

  describe '#count_pieces' do
    it 'returns a hash of piece counts for each color' do
      board.pos[1][0] = :black
      board.pos[2][0] = :black
      board.pos[3][0] = :white
      board.count_pieces.should == {:black => 2, :white => 1}
    end
  end
end

describe Game do
  subject(:game){Game.new}
  let(:input) {[3,2]}
  let(:player) {double('player', :get_move)}

  describe '#play_turn' do
    it "adds one piece per turn until game_over?" do
      game.gameboard.starting_board
      expect do
        game.play_turn(input)
      end.to change{game.gameboard.count_pieces.values.inject(&:+)}.by(1)
    end
  end

end

describe AIPlayer do
  subject(:tom){AIPlayer.new(:black)}
  let(:board) {Board.new}

  describe '#get_move' do
    it 'takes move that flips the most pieces' do
      board.pos[1][3] = :white
      board.pos[2][3] = :black
      board.pos[2][4] = :white
      board.pos[2][5] = :white
      board.pos[2][6] = :white
      board.pos[3][2] = :white
      board.pos[4][1] = :white
      tom.get_move(board).should == [2,7]
    end
  end
end
