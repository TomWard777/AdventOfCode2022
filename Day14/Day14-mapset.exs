defmodule Day14 do
  @max_y_test  9
  @max_y  165

  def run() do
    Code.require_file("MyFunctions.exs", "../")
    input = MyFunctions.read_file("Input.md")
    #input = MyFunctions.read_file("Test.md")

    initial = input
    |> Enum.map(fn x -> get_points(x) end)
    |> print()
    |> Enum.map(fn pts -> get_path(pts) end)
    |> Enum.concat

    rocks = MapSet.new(initial)

    ymax = rocks
    |> Enum.map(fn [x, y] -> y end)
    |> Enum.max
    |> IO.inspect(label: "Max y co-ordinate")

    xmin = rocks
    |> Enum.map(fn [x, y] -> x end)
    |> Enum.min
    |> IO.inspect(label: "Min x co-ordinate")

    xmax = rocks
    |> Enum.map(fn [x, y] -> x end)
    |> Enum.max
    |> IO.inspect(label: "Max x co-ordinate")

    grid = for y <- 0..ymax, x <- xmin..xmax,  do: [x,y]

    #extra = for x <- xmin - 300..xmax + 300,  do: [x,ymax + 2]
    #rocks = rocks ++ extra

    grid
    |> Enum.map(fn x -> draw(rocks, x) end)
    |> MyFunctions.to_sublists(ymax + 1)
    |> IO.inspect

    IO.puts("Calculating...")
    drop_sand(rocks, ymax + 2)
  end

  def draw(blocks, p) do
    cond do
      MapSet.member?(blocks, p) -> "#"
      true -> "."
    end
  end

  def drop_sand(blocks, yfloor, acc \\ 0) do
    p = move_sand_grain_to_rest(blocks, yfloor, [500, 0])
    cond do
      p == [500, 0] ->
        IO.puts("Result")
        acc + 1
      p == nil ->
        IO.puts("Result")
        acc
      true ->
        cond do
          rem(acc, 100) == 0 -> IO.inspect(acc)
          true ->
        end
        newblocks = MapSet.put(blocks, p)
        drop_sand(newblocks, yfloor, acc + 1)
    end
  end

  def move_sand_grain_to_rest(blocks, yfloor, [x,y]) do
    [x1, y1] = move_sand_grain_once(blocks, [x, y])
    cond do
      y1 == yfloor - 1 ->
        [x1, y1] # Grain has landed on floor
      [x1, y1] == [x, y] ->
        [x, y] # Grain has come to rest
      y > 165 ->
        nil # Grain has fallen into abyss
      true ->
        move_sand_grain_to_rest(blocks, yfloor, [x1,y1])
    end
  end

  def move_sand_grain_once(blocks, [x, y]) do
    cond do
      MapSet.member?(blocks, [x, y]) -> nil # Source blocked
      !MapSet.member?(blocks, [x, y+1]) -> [x, y+1]
      !MapSet.member?(blocks, [x-1, y+1]) -> [x-1, y+1]
      !MapSet.member?(blocks, [x+1, y+1]) -> [x+1, y+1]
      true -> [x, y] # Grain has come to rest
    end
  end

  def get_points(str) do
    String.split(str, " -> ")
    |> Enum.map(fn x -> String.split(x, ",") end)
    |> Enum.map(fn [a, b] -> [String.to_integer(a), String.to_integer(b)] end)
  end

  def get_path(point_list, acc \\ []) do
    [v | [w | tail]] = point_list
    newacc = MyFunctions.distinct(acc ++ get_path_segment(v, w))
    cond do
      tail == [] -> newacc
      true -> get_path([w | tail], newacc)
    end
  end

  def get_path_segment([i,j], [k,l]) do
    cond do
      i == k -> get_horizontal_path([i,j], [k,l])
      j == l -> get_vertical_path([i,j], [k,l])
      true -> raise("Pair of points are wrong")
    end
  end

  def get_horizontal_path([i, j], [_, l]) do
    [j, l] = cond do
      j > l -> [l, j]
      true -> [j, l]
    end

    for m <- 0..l-j do
      [i, j + m]
    end
  end

  def get_vertical_path([i, j], [k, _]) do
    [i, k] = cond do
      i > k -> [k, i]
      true -> [i, k]
    end

    for m <- 0..k-i do
      [i + m, j]
    end
  end

  def print(x), do: IO.inspect(x, charlists: :as_lists)
end

IO.puts("Result:")
IO.inspect(Day14.run(), charlists: :as_lists)
