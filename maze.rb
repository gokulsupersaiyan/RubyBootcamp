require_relative 'couple'

MAZE1 = 
%{#####################################
# #   #     #A        #     #       #
# # # # # # ####### # ### # ####### #
# # #   # #         #     # #       #
# ##### # ################# # #######
#     # #       #   #     # #   #   #
##### ##### ### ### # ### # # # # # #
#   #     #   # #   #  B# # # #   # #
# # ##### ##### # # ### # # ####### #
# #     # #   # # #   # # # #       #
# ### ### # # # # ##### # # # ##### #
#   #       #   #       #     #     #
#####################################}

MAZE2 = %{#####################################
# #       #             #     #     #
# ### ### # ########### ### # ##### #
# #   # #   #   #   #   #   #       #
# # ###A##### # # # # ### ###########
#   #   #     #   # # #   #         #
####### # ### ####### # ### ####### #
#       # #   #       # #       #   #
# ####### # # # ####### # ##### # # #
#       # # # #   #       #   # # # #
# ##### # # ##### ######### # ### # #
#     #   #                 #     #B#
#####################################}

MAZE3 = %{#####################################
# #   #           #                 #
# ### # ####### # # # ############# #
#   #   #     # #   # #     #     # #
### ##### ### ####### # ##### ### # #
# #       # #  A  #   #       #   # #
# ######### ##### # ####### ### ### #
#               ###       # # # #   #
# ### ### ####### ####### # # # # ###
# # # #   #     #B#   #   # # #   # #
# # # ##### ### # # # # ### # ##### #
#   #         #     #   #           #
#####################################}

class Maze

  attr_accessor :length, :width

  def initialize(maze)
    @maze = maze
    lines = maze.split(/\n/)
    @length = lines.length
    @width = lines[0].length
    @a_pos = get_position_for_index(maze.index('A'))
    @b_pos = get_position_for_index(maze.index('B'))
  end

  def get_char_at(row, column)
    @maze[row * @width + column + row]
  end

  def set_char_at(row, column , char = '#')
    @maze[row * @width + column + row] = '#'
  end

  def block?(row, column)
    get_char_at(row, column) == '#'
  end

  def get_position_for_index(index)
    raise ArgumentError, 'Invalid index' if index < 0
    Couple.new(index / (@width + 1), index % (@width + 1))
  end

  def solvable?
    solve
    @result.one
  end

  def steps
    solve
    @result.two
  end

  def to_s
    %{Length : #{@length}, Width : #{@width}, A pos : #{@a_pos}, B pos : #{@b_pos}}
  end

  private

  def solve
    return @result if @is_solved
    queue = Queue.new
    queue.push(@a_pos)
    memoize = Array.new(@length) { Array.new(@width, 0) }
    min = Float::INFINITY

    until queue.empty?
        current_itr = queue.pop
        set_char_at(current_itr.one, current_itr.two)
        distance = memoize[current_itr.one][current_itr.two]
        next if distance > min
        # Top
        if current_itr.one - 1 >= 0 && !block?(current_itr.one - 1, current_itr.two)
          queue.push(Couple.new(current_itr.one - 1, current_itr.two))
          memoize[current_itr.one - 1][current_itr.two] = distance + 1
          min = distance if get_char_at(current_itr.one - 1, current_itr.two) == 'B'
        end

        # Left
        if current_itr.two - 1 >= 0 && !block?(current_itr.one, current_itr.two - 1)
          queue.push(Couple.new(current_itr.one, current_itr.two - 1))
          memoize[current_itr.one][current_itr.two - 1] = distance + 1
          min = distance if get_char_at(current_itr.one ,current_itr.two - 1) == 'B'
        end

        # Bottom
        if current_itr.one + 1 < @length && !block?(current_itr.one + 1, current_itr.two)
          queue.push(Couple.new(current_itr.one + 1, current_itr.two))
          memoize[current_itr.one + 1][current_itr.two] = distance + 1
          min = distance if get_char_at(current_itr.one + 1,current_itr.two) == 'B'
        end

        # Right
        if current_itr.two + 1 < @width && !block?(current_itr.one, current_itr.two + 1)
          queue.push(Couple.new(current_itr.one, current_itr.two + 1))
          memoize[current_itr.one][current_itr.two + 1] = distance + 1
          min = distance if get_char_at(current_itr.one ,current_itr.two + 1) == 'B'
        end
    end
    @result = Couple.new(min < Float::INFINITY, min)
    @is_solved = true
    @result
  end
end

# Case 1
maze_one = Maze.new(MAZE1)
puts maze_one
puts maze_one.solvable?
puts maze_one.steps

# Case 2
maze_two = Maze.new(MAZE2)
puts maze_two
puts maze_two.solvable?
puts maze_two.steps

# Case 3
maze_three = Maze.new(MAZE3)
puts maze_three
puts maze_three.solvable?
puts maze_three.steps
