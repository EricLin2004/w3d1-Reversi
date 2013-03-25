class Array
  def my_uniq
    uniques = []
    self.each do |el|
      uniques << el unless uniques.include?(el)
    end
    uniques
  end
end

def two_sum(array)
  two_sum = []
  array.each_with_index do |el1, ind1|
    array[ind1+1..-1].each_with_index do |el2, ind2|
      ind2 += ind1+1
      if el1 + el2 == 0
        two_sum << [ind1,ind2]
      end
    end
  end
  two_sum
end

class Hanoi
  attr_accessor :towers

  def initialize(size = 3)
    @towers = [[],[],[]]
    size.times do |i|
      @towers[0] << size - i
    end
  end

  def move(start_tower, end_tower)
    @towers[end_tower] << @towers[start_tower].pop
  end
end