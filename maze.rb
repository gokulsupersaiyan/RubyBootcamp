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

  def is_solvable
    queue = Queue.new
    queue.push(@a_pos)
    until queue.empty?
        current_itr = queue.pop
        set_char_at(current_itr.one,current_itr.two)
        # Top
        if current_itr.one - 1 >= 0 && !block?(current_itr.one - 1, current_itr.two)
          return true if get_char_at(current_itr.one - 1, current_itr.two) == 'B'
          queue.push(Couple.new(current_itr.one - 1, current_itr.two))
        end

        # Left
        if current_itr.two - 1 >= 0 && !block?(current_itr.one, current_itr.two - 1)
          return true if get_char_at(current_itr.one ,current_itr.two - 1) == 'B'
          queue.push(Couple.new(current_itr.one, current_itr.two - 1))
        end

        # Bottom
        if current_itr.one + 1 < @length && !block?(current_itr.one + 1, current_itr.two)
          return true if get_char_at(current_itr.one + 1,current_itr.two) == 'B'
          queue.push(Couple.new(current_itr.one + 1, current_itr.two))
        end

        # Right
        if current_itr.two + 1 < @width && !block?(current_itr.one, current_itr.two + 1)
          return true if get_char_at(current_itr.one ,current_itr.two + 1) == 'B'
          queue.push(Couple.new(current_itr.one, current_itr.two + 1))
        end
    end
    false
  end

  def to_s
    %{Length : #{@length}, Width : #{@width}, A pos : #{@a_pos}, B pos : #{@b_pos}}
  end
end

# Case 1
maze_one = Maze.new(MAZE1)
puts maze_one
puts maze_one.is_solvable

# Case 2
maze_two = Maze.new(MAZE2)
puts maze_two
puts maze_two.is_solvable

# Case 3
maze_three = Maze.new(MAZE3)
puts maze_three
puts maze_three.is_solvable
