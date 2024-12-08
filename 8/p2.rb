require 'set'

loc = Hash.new{ |hash, key| hash[key] = [] }

array = File.readlines("input.txt").map(&:chomp).map(&:chars)
array.each_with_index do | row, y |
  row.each_with_index do | char, x |
    loc[char] << [x, y] unless char == '.'
  end
end

points = Set.new

loc.each do | char, coords |
  perms = coords.permutation(2).to_a
  perms.each do | (x1, y1), (x2, y2) |
    dx, dy = x2 - x1, y2 - y1
    x, y = x1 + dx, y1 + dy
    while x.between?(0, array.first.size - 1) && y.between?(0, array.size - 1)
      points.add([x, y])
      x += dx
      y += dy
    end
  end
end

puts points.length()