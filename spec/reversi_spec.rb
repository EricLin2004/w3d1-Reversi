require 'rspec'
require 'reversi.rb'

describe Piece do
  subject(:piece) {Piece.new}
end

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

  describe '#win?' do

  end
end

describe Game do

  describe '#make_board' do
  end
end

# let(:piece) {double(:piece, :swap_color => true)}
# it "" do
#   piece.stub(:swap_color)


