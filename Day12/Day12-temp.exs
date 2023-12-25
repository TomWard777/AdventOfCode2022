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
    |> Enum.map(fn x -> String.to_charlist(x) end)
    |> IO.inspect

    IO.inspect(matrix, charlists: :as_lists)

    m = Enum.count(matrix)
    n = Enum.count(Enum.at(matrix,0))

    IO.inspect("#{m} X #{n}")

    points =
    for i <- 0..m-1, j <- 0..n-1 do
      [i, j]
    end

    points
    |> MyFunctions.to_sublists(n)
    |> IO.inspect

    points
    |> Enum.map(fn y -> print(matrix, y) end)
    |> MyFunctions.to_sublists(n)
    #|> Enum.map(fn x -> Enum.map(x, fn y -> print(matrix, y) end))
  end

  def print(matrix, [i, j]) do
    l = blocks_left?(matrix, i, j)
    d = blocks_down?(matrix, i, j)
    r = blocks_right?(matrix, i, j)
    u = blocks_up?(matrix, i, j)

    cond do
      [i, j] == @start -> "S"
      [i, j] == @finish -> "F"
      l && d -> "L"
      l -> "|."
      d -> "_"
      r -> ".|"
      u -> "^"
      true -> "."
    end
  end

  def blocks_down?(matrix, i, j) do
    x = entry(matrix, i, j)
    y = entry(matrix, i+1, j)

    cond do
      x == nil -> false
      y == nil -> false
      x-1 > y -> true
      true -> false
    end
  end

  def blocks_left?(matrix, i, j) do
    x = entry(matrix, i, j)
    y = entry(matrix, i, j-1)
    cond do
      x == nil -> false
      y == nil -> false
      x-1 > y -> true
      true -> false
    end
  end

  def blocks_right?(matrix, i, j) do
    x = entry(matrix, i, j)
    y = entry(matrix, i, j+1)
    cond do
      x == nil -> false
      y == nil -> false
      x-1 > y -> true
      true -> false
    end
  end

  def blocks_up?(matrix, i, j) do
    x = entry(matrix, i, j)
    y = entry(matrix, i-1, j)
    cond do
      x == nil -> false
      y == nil -> false
      x-1 > y -> true
      true -> false
    end
  end

  def entry(matrix, i, j) do
    size = Enum.count(matrix)
    row = Enum.at(matrix, i)
    cond do
      i < 0 -> nil
      j < 0 -> nil
      i > size - 1 -> nil
      j > size - 1 -> nil
      row == nil -> nil
      true -> Enum.at(row, j)
    end
  end

end

IO.puts("Result:")
IO.inspect(Day12.run(), charlists: :as_lists)
