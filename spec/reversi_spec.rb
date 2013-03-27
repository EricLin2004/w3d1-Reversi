require 'rspec'
require 'reversi.rb'

describe Board do
  subject(:board) {Board.new}

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
    #REV should this be doesn't flip?
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


  describe '#make_move' do
    before(:each) do
      board.pos[3][3] = :white
      board.pos[4][3] = :white
      board.pos[3][4] = :white
      board.pos[4][4] = :white
    end

    # REV not sure why this flipping pieces is neccessary
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
    # REV returns false if moves avalible?
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
  let(:board) {double('board')}
  let(:player1) {double('player1')}
  let(:player2) {double('player2')}
  let(:game){Game.new}
=begin #REV: didn't finish this
  describe '#run' do
    before do
      player1.stub(:color) {:black}
      player1.stub(:get_move) {[3,2]}
      player2.stub(:color) {:white}
      player2.stub(:get_move) {[4,2]}
      board.stub(:game_over?) {true}
      board.stub(:count_pieces) {{:black => 3, :white => 3}}
      board.stub(:who_won) {:black}
      board.stub(:valid_move?) {false}
      game.stub(:play_turn)
      game.player1 = player1
      game.player2 = player2
      game.gameboard = board
    end

    it 'player should receive get_move call' do
      player1.should_receive(:get_move)
      game.run
    end
  end
=end
  describe '#play_turn' do
    it "adds one piece per turn until game_over?" do
      player1.stub(:get_move) {[5,4]}
      game.gameboard.starting_board
      expect do
        game.play_turn(player1.get_move)
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