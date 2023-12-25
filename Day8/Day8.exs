defmodule Day8 do
  def run2() do
    Code.require_file("MyFunctions.exs", "../")
    input = read_file("Input.txt")
    #input = read_file("Test.txt")

    matrix = input
    |> Enum.map(fn x -> String.split(x, "") end)
    |> Enum.map(fn x -> Enum.filter(x, fn y -> y != "" end) end)
    |> Enum.map(&transform_row/1)
    |> IO.inspect

    size = Enum.count(matrix)

    scores = for i <- 1..size-2, j <- 1..size-2, do: score(matrix, i, j)

    scores
    |> IO.inspect(label: "scores")
    |> Enum.max
  end

  def run() do
    Code.require_file("MyFunctions.exs", "../")
    input = read_file("Input.txt")
    #input = read_file("Test.txt")

    matrix = input
    |> Enum.map(fn x -> String.split(x, "") end)
    |> Enum.map(fn x -> Enum.filter(x, fn y -> y != "" end) end)
    |> Enum.map(&transform_row/1)
    |> IO.inspect

    size = Enum.count(matrix)

    check = for i <- 1..size-2, j <- 1..size-2, is_visible?(matrix, i, j), do: {i,j}

    check
    |> IO.inspect(label: "inner visible trees")

    Enum.count(check) + 4 * (size - 1)
  end

  def score(matrix, i, j) do
    IO.inspect({i,j})
    ht = Enum.at(Enum.at(matrix, i), j)

    a = look_left(matrix, i, j, ht)
    b = look_right(matrix, i, j, ht)
    c = look_up(matrix, i, j, ht)
    d = look_down(matrix, i, j, ht)
    IO.inspect([a,b,c,d])
    a * b * c * d
  end

  def look_right(matrix, i, j, height, acc \\ 0) do
    next = entry(matrix, i, j+1)
    cond do
      next == nil -> acc
      next >= height -> acc + 1
      next < height -> look_right(matrix, i, j+1, height, acc + 1)
    end
  end

  def look_left(matrix, i, j, height, acc \\ 0) do
    next = entry(matrix, i, j-1)
    cond do
      next == nil -> acc
      j < 0 -> acc
      next >= height -> acc + 1
      next < height -> look_left(matrix, i, j-1, height, acc + 1)
    end
  end

  def look_down(matrix, i, j, height, acc \\ 0) do
    next = entry(matrix, i+1, j)
    cond do
      next == nil -> acc
      next >= height -> acc + 1
      next < height -> look_down(matrix, i+1, j, height, acc + 1)
    end
  end

  def look_up(matrix, i, j, height, acc \\ 0) do
    next = entry(matrix, i-1, j)
    cond do
      next == nil -> acc
      i < 0 -> acc
      next >= height -> acc + 1
      next < height -> look_up(matrix, i-1, j, height, acc + 1)
    end
  end

  def is_visible?(matrix, i, j) do
      size = Enum.count(matrix)
      ht = Enum.at(Enum.at(matrix, i), j)

      up = for m <- 0..i-1, do: Enum.at(Enum.at(matrix, m), j)
      down = for m <- i+1..size-1, do: Enum.at(Enum.at(matrix, m), j)

      left = for n <- 0..j-1, do: Enum.at(Enum.at(matrix, i), n)
      right = for n <- j+1..size-1, do: Enum.at(Enum.at(matrix, i), n)

      cond do
        ht > Enum.max(up) -> true
        ht > Enum.max(left) -> true
        ht > Enum.max(right) -> true
        ht > Enum.max(down) -> true
        true -> false
      end
  end

  def entry(matrix, i,j) do
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

  def transform_row(list) do
    list
    |> Enum.filter(fn x -> x != "" end)
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def read_file(filename) do
      case File.read(filename) do
          {:ok, body} -> String.split(body, "\r\n")
          {:error, message} -> IO.inspect(message, label: "Error reading file:")
      end
  end
end

test = Day8.run2()
IO.inspect(test, label: "Result")
