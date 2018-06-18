def skip_tracks_old(arr, i)
  start = inc = i % arr.size
  count = 1
  while inc > 0 && count < arr.size do
    c = start
    while (c + inc) % arr.size != start do
      before = (c - inc) % arr.size
      arr[before], arr[c] = arr[c], arr[before]
      c = c + 1
      count = count + 1
    end
    start = start - 1
    count = count + 1
  end
end

# brute force
def skip_tracks_one(arr ,i)
  i = i % arr.size
  while i > 0 do
    temp = arr[0]
    for itr in 0...arr.size
      arr[itr] = arr[itr + 1]
    end
    arr[arr.size - 1] = temp
    i -= 1
  end
end

# inbuilt method
def skip_tracks_two(arr,i)
  arr.rotate!(i)
end

# using extra space
def skip_tracks_three(arr, i)
  i = i % arr.size
  temp_arr = arr[i...(arr.size)] + arr[0...i]
  arr.each_index { |index| arr[index] = temp_arr[index]}
end

# double rotation
def skip_tracks_four(arr, i)
  i = i % arr.size
  mirror_array(arr, 0, i)
  mirror_array(arr, i + 1, arr.size - 1)
  mirror_array(arr, 0, arr.size - 1)
end

def mirror_array(array, from, to)
  while from < to
    array[from], array[to] = array[to], array[from]
    from += 1
    to -= 1
  end
end

play_list = ['1','2','3','4','5','6','7','8']
# skip_tracks_one(play_list, 3)
# skip_tracks_two(play_list, -1)
# skip_tracks_three(play_list, -1)
skip_tracks_old(play_list, 2)
puts play_list
