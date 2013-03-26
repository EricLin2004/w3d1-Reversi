require 'rspec'
require 'TreeNode.rb'

describe TreeNode do
  subject(:root) {TreeNode.new(4)}


  describe '#initialize' do
    it 'Creates empty array of children' do
      root.children.should == []
    end

    it "Sets a value" do
      root.value.should_not == nil
    end
  end

  describe '#add_child' do
    let(:child) {TreeNode.new(4)}

    before do
      root.add_child(child)
    end

    it 'Should add to parent.children array' do
      expect do
        root.add_child(TreeNode.new(5))
      end.to change(root.children, :count).by(1)
    end

    it 'Sets parent correctly' do
      child.parent.should == root
    end

    it "Doesn't add duplicate children" do
      expect do
        root.add_child(child)
      end.to raise_error("Already a child of this node.")
    end
  end

  describe '#delete_child' do
    let(:child) {TreeNode.new(4)}

    before(:each) do
      root.add_child(child)
      root.delete_child(child)
    end

    it 'remove parent from child node' do
      root.children.should == []
    end

    it 'remove child from parent node' do
      child.parent.should == nil
    end
  end
end

describe "#bfs" do
  subject(:root) {TreeNode.new(1)}
  let(:dad) {TreeNode.new(2)}
  let(:aunt) {TreeNode.new(3)}
  let(:grandchild) {TreeNode.new(4)}

  before(:all) do
    root.add_child(dad)
    root.add_child(aunt)
    dad.add_child(grandchild)
  end

  it "Finds the correct node" do
    bfs(4, root).should == grandchild
  end

  it "Checks nodes in the correct order" do
    aunt.should_receive(:value).ordered
    grandchild.should_receive(:value).ordered
    bfs(4, root)
  end
end

describe "#dfs" do
  subject(:root) {TreeNode.new(1)}
  let(:dad) {TreeNode.new(2)}
  let(:aunt) {TreeNode.new(3)}
  let(:grandchild) {TreeNode.new(4)}

  before(:all) do
    root.add_child(dad)
    root.add_child(aunt)
    dad.add_child(grandchild)
  end

  it "Finds the correct node" do
    dfs(4, root).should == grandchild
  end

  it "Checks nodes in the correct order" do
    grandchild.should_receive(:value).ordered
    aunt.should_receive(:value).ordered
    dfs(3, root)
  end
end
