class TreeNode
  attr_reader :children, :value
  attr_accessor :parent

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def add_child(child = TreeNode.new)
    child.parent = self
    if @children.include?(child)
      raise "Already a child of this node."
    else
      @children << child
    end
  end

  def delete_child(child)
    @children.delete_at(@children.index(child))
    child.parent = nil
  end
end

def bfs(target, root)
  queue = [root]
  until queue.empty?
    current = queue.shift
    if current.value == target
      return current
    else
      queue += current.children
    end
  end
  nil
end

def dfs(target, root)
  queue = [root]
  until queue.empty?
    current = queue.shift
    if current.value == target
      return current
    else
      queue = current.children + queue
    end
  end
  nil
end