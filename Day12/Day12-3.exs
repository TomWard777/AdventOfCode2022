defmodule Day12 do
  #@start [0, 0]
  #@finish [2, 5]
  @start [20, 0]
  @finish [20, 120]

  def run() do
    Code.require_file("MyFunctions.exs", "../")
    input = MyFunctions.read_file("Input.md")
    #input = MyFunctions.read_file("Test.md")

    matrix = input
    |> Enum.map(fn x -> String.replace(x, "S", "a") end)
    |> Enum.map(fn x -> String.replace(x, "E", "z") end)
    |> Enum.map(fn x -> String.to_charlist(x) end)

    m = Enum.count(matrix)
    n = Enum.count(Enum.at(matrix,0))

    IO.inspect("#{m} X #{n}")

    repeat(matrix, @start, 100000000000)
  end

  def repeat(matrix, position, number_of_times, min \\ 1000000) do
    n = random_traverse(matrix, position)
    new_min = cond do
      min > n -> n
      true -> min
    end

    cond do
      number_of_times == 1 -> new_min
      true -> repeat(matrix, position, number_of_times - 1, new_min)
    end
  end

  def random_traverse(matrix, position, path \\ [@start]) do
    [i, j] = position
    l = left?(matrix, i, j)
    d = down?(matrix, i, j)
    r = right?(matrix, i, j)
    u = up?(matrix, i, j)

    #IO.inspect("position"); IO.inspect([i,j]); IO.inspect([l,r,u,d]);

    directions =
    [{[i-1,j], u}, {[i+1,j], d}, {[i,j+1], r}, {[i,j-1], l}]
    |> Enum.filter(fn {x, y?} -> y? end)
    |> Enum.map(fn {x, _} -> x end)
    |> Enum.filter(fn x -> !Enum.member?(path, x) end)

    cond do
      directions == [] ->
        100000000

      Enum.member?(directions, @finish) ->
        IO.inspect(Enum.count(path), label: "COMPLETE!")

      true ->
        x = Enum.random(directions)
        random_traverse(matrix, x, [x | path])
      end
  end

  def down?(matrix, i, j) do
    x = entry(matrix, i, j)
    y = entry(matrix, i+1, j)
    cond do
      x == nil -> false
      y == nil -> false
      x+2 > y -> true
      true -> false
    end
  end

  def left?(matrix, i, j) do
    x = entry(matrix, i, j)
    y = entry(matrix, i, j-1)
    cond do
      x == nil -> false
      y == nil -> false
      x+2 > y -> true
      true -> false
    end
  end

  def up?(matrix, i, j) do
    x = entry(matrix, i, j)
    y = entry(matrix, i-1, j)
    cond do
      x == nil -> false
      y == nil -> false
      x+2 > y -> true
      true -> false
    end
  end

  def right?(matrix, i, j) do
    x = entry(matrix, i, j)
    y = entry(matrix, i, j+1)

    cond do
      x == nil -> false
      y == nil -> false
      x+2 > y -> true
      true -> false
    end
  end

  def entry(matrix, i, j) do
    m = Enum.count(matrix)
    n = Enum.count(Enum.at(matrix, 0))

    row = Enum.at(matrix, i)
    cond do
      i < 0 -> nil
      j < 0 -> nil
      i > m - 1 -> nil
      j > n - 1 -> nil
      row == nil -> nil
      true -> Enum.at(row, j)
    end
  end

end

IO.puts("Result:")
IO.inspect(Day12.run(), charlists: :as_lists)
