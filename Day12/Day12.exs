defmodule Day12 do
  #@start [0, 0]
  #@finish [2, 5]
  @start [20, 0]
  @finish [20, 120]

  def run() do
    Code.require_file("MyFunctions.exs", "../")
    input = MyFunctions.read_file("Input.md")
    #input = MyFunctions.read_file("Test.md")

    # TRY GOING DOWN FROM FINISH
    matrix = input
    |> Enum.map(fn x -> String.replace(x, "S", "a") end)
    |> Enum.map(fn x -> String.replace(x, "E", "z") end)
    |> Enum.map(fn x -> String.to_charlist(x) end)

    m = Enum.count(matrix)
    n = Enum.count(Enum.at(matrix,0))

    IO.inspect("#{m} X #{n}")

    #alpha = [?a, ?b, ?c, ?d, ?e, ?f, ?g, ?h, ?i, ?j, ?k, ?l, ?m, ?n, ?o, ?p, ?q, ?r, ?s, ?t, ?u, ?v, ?w, ?x, ?y]
    alpha = [?e, ?f, ?g, ?h, ?i, ?j, ?k, ?l, ?m, ?n, ?o, ?p, ?q, ?r, ?s, ?t, ?u, ?v, ?w, ?x, ?y]
    reverse_alpha = Enum.reverse(alpha)

    #repeat(matrix, @finish, 1000, ?y, 1000000000, @finish)
    get_length(matrix, @finish, reverse_alpha)
  end

  def get_length(matrix, start, targets, acc \\ 0)

  def get_length(_, _, [], acc), do: acc

  def get_length(matrix, start, targets, acc) do
    [tgt | rest] = targets
    {path, n} = repeat(matrix, start, 10000, tgt, 1000000000, start)

    IO.inspect(tgt, label: "target")
    IO.inspect(acc, label: "acc")
    print(start)

    [reached | _] = path
    get_length(matrix, reached, rest, acc + n - 1)
  end

  def repeat(matrix, position, number_of_times, target, min, reached) do
    {newposition, n} = random_traverse(matrix, position, target, [position])

    newmin = cond do
      n < min -> n
      true -> min
    end

    reached = cond do
      n < min -> newposition
      true -> reached
    end

    cond do
      number_of_times == 1 -> {reached, newmin}
      true -> repeat(matrix, position, number_of_times - 1, target, newmin, reached)
    end
  end

  def random_traverse(matrix, position, target, path) do
    [i, j] = position
    l = left?(matrix, i, j)
    d = down?(matrix, i, j)
    r = right?(matrix, i, j)
    u = up?(matrix, i, j)

    #IO.inspect("position"); IO.inspect([i,j]); IO.inspect([l,r,u,d]);

    directions =
    [{[i-1,j], u}, {[i+1,j], d}, {[i,j+1], r}, {[i,j-1], l}]
    |> Enum.filter(fn {_, y?} -> y? end)
    |> Enum.map(fn {x, _} -> x end)
    |> Enum.filter(fn x -> !Enum.member?(path, x) end)
    |> Enum.filter(fn x -> x != [10,121] end)

    cond do
      Enum.member?(directions, @start) ->
        IO.inspect(Enum.count(path), label: "COMPLETE!")
        {path, Enum.count(path)}

      entry(matrix, i, j) == target ->
        #IO.inspect(Enum.count(path), label: "GOT TO TARGET")
        #{List.first(directions), Enum.count(path)}
        {path, Enum.count(path)}

      directions == [] ->
        {[], 10000000}

      true ->
        x = Enum.random(directions)
        random_traverse(matrix, x, target, [x | path])
      end
  end

  def down?(matrix, i, j) do
    x = entry(matrix, i, j)
    y = entry(matrix, i+1, j)
   #IO.inspect(x); IO.inspect(y);
    cond do
      x == nil -> false
      y == nil -> false
      y == x-1 || y == x -> true
      true -> false
    end
  end

  def left?(matrix, i, j) do
    x = entry(matrix, i, j)
    y = entry(matrix, i, j-1)
    cond do
      x == nil -> false
      y == nil -> false
      y == x-1 || y == x -> true
      true -> false
    end
  end

  def up?(matrix, i, j) do
    x = entry(matrix, i, j)
    y = entry(matrix, i-1, j)
    cond do
      x == nil -> false
      y == nil -> false
      y == x-1 || y == x -> true
      true -> false
    end
  end

  def right?(matrix, i, j) do
    x = entry(matrix, i, j)
    y = entry(matrix, i, j+1)

    cond do
      x == nil -> false
      y == nil -> false
      y == x-1 || y == x -> true
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

  def print(x), do: IO.inspect(x, charlists: :as_lists)
end

IO.puts("Result:")
IO.inspect(Day12.run(), charlists: :as_lists)
