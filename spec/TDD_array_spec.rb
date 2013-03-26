require 'rspec'
require 'TDD_array.rb'

describe Array do
  subject(:array) {[1,2,3,2,3]}

  describe "#my_uniq" do
    it "returns a unique array" do
      array.my_uniq.should eq([1,2,3])
    end
  end
end

describe '#two_sum' do
  subject(:arr1) {[-2,2,3,1,0,-1]}
  let(:arr2) {[0,0,-1,2,-2,3,-3]}

  it "Returns location of elements that sum to zero" do
    two_sum(arr1).should eq([[0,1],[3,5]])
  end

  it "Works for double zeros" do
    two_sum(arr2).should eq([[0,1],[3,4],[5,6]])
  end


end

describe Hanoi do
  subject(:game) {Hanoi.new}

  describe '#initialize' do
    it 'should set up towers' do
      game.towers.should == [[3,2,1],[],[]]
    end
  end

  describe '#move' do
    it 'should move a piece' do
      game.move(0,1)
      game.towers.should == [[3,2], [1], []]
    end

    it 'cannot move onto a smaller disc' do
      game.move(0,1)
      expect do
        game.move(0,1)
      end.to raise_error("Can't move onto smaller disc.")
    end

    # REV what about move from empty disc?
  end

  describe '#won?' do
    it 'winning condition 1' do
      # REV why not just pass in these towers through Initialize?
      game.instance_variable_set(:@towers, [[],[3,2,1],[]])
      game.won?.should be_true
    end

    it 'winning condition 2' do
      game.instance_variable_set(:@towers, [[],[],[3,2,1]])
      game.won?.should be_true
    end
  end
end