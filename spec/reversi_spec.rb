require 'rspec'
require 'reversi.rb'

describe Piece do
  subject(:piece) {Piece.new}

  describe '#swap_color' do

  end
end

describe Board do
  subject(:board) {Board.new}
  let(:black_piece) {double(:piece, :color => :black)}
  let(:white_piece) {double(:piece, :color => :white)}

  # it "Should have four pieces in the middle" do
  #   board.pos[3][3].color.should == :black
  #   board.pos[3][3].should == white_piece
  #   board.pos[4][4].should == white_piece
  #   board.pos[3][4].should == black_piece
  #   board.pos[4][3].should == black_piece
  # end

  describe '#valid_move?' do
    let(:off_board_move) {[8,8]}
    let(:occupied_move) {[3,3]}
    let(:doesnt_flip_move) {[2,4]}

    it "the move is on the board" do
      board.valid_move?(off_board_move, :black).should be_false
    end
    it "the move location is empty" do
      board.pos[3][3] = black_piece
      board.valid_move?(occupied_move, :black).should be_false
    end
    it "the move flips an opponent's piece" do 
      # REV The description above should be 'doesn't flip'
      board.pos[2][3] = white_piece
      board.pos[1][3] = black_piece
      board.pos[2][1] = black_piece
      board.valid_move?(doesnt_flip_move, :black).should be_false

    end
  end

  describe '#make_move' do
    it "places a piece" do

    end
  end
end

describe Game do

  describe '#make_board' do

  end
end

# let(:piece) {double(:piece, :swap_color => true)}
# it "" do
#   piece.stub(:swap_color)


