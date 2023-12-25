defmodule Point do
  defstruct [x: nil, y: nil]

  def new(x0, y0) do
    %Point{x: x0, y: y0}
  end
end

defmodule Command do
  defstruct [direction: nil, number: nil]

  def new(dir, num) do
    %Command{direction: dir, number: num}
  end

  def from_string(str) do
    [a, b] = String.split(str, " ")
    %Command{ direction: a, number: String.to_integer(b) }
  end

  def expand(%Command{} = cmd) do
    direction_list = for _ <- 1..cmd.number, do: cmd.direction
    direction_list
  end
end

defmodule Day9 do
  def run() do
    Code.require_file("MyFunctions.exs", "../")
    #input = read_file("Input.txt")
    input = read_file("Test.txt")

    directions = input
    |> Enum.map(fn x -> Command.from_string(x) end)
    |> Enum.map(&Command.expand/1)
    |> Enum.concat()
    |> IO.inspect

    start = %Point{x: 0, y: 0}

    move(start, start, directions)
    |> MyFunctions.distinct
    |> IO.inspect
    |> Enum.count
  end

  def run2() do
    Code.require_file("MyFunctions.exs", "../")
    input = read_file("Input.txt")
    #input = read_file("Test2.txt")

    directions = input
    |> Enum.map(fn x -> Command.from_string(x) end)
    |> Enum.map(&Command.expand/1)
    |> Enum.concat()
    |> IO.inspect

    p = %Point{x: 0, y: 0}
    start = [p, p, p, p, p, p, p, p, p, p]

    move2(start, directions)
    |> MyFunctions.distinct
    |> IO.inspect
    |> Enum.count
  end

  # Part 2
  def move2(rope, directions, acc_list \\ [])

  def move2(rope, [], acc_list) do
    [List.last(rope) | acc_list]
  end

  def move2(rope, directions, acc_list) do
    [dir | rest] = directions
    [head | tail] = rope

    head_new = move_once(head, dir)
    rope_new = movelong([head_new], tail)

    move2(rope_new, rest, [List.last(tail) | acc_list])
  end

  # movelong now needs to cope with head and tail as LISTS
  # Both lists should each be "connected", but the last element of head is "leading" the first element of tail
  def movelong(head, [tailpoint]) do
    t_new = catch_up(List.last(head), tailpoint)
    head ++ [t_new]
  end

  def movelong(head, tail) do
    leader = List.last(head)
    [tailhead | rest] = tail
    tailhead_new = catch_up(leader, tailhead)
    movelong(head ++ [tailhead_new], rest)
  end

  def move(head, tail, directions, acc_list \\ [])

  def move(_, %Point{} = tail, [], acc_list) do
    [tail | acc_list]
  end

  def move(%Point{} = head, %Point{} = tail, directions, acc_list) do
    [dir | rest] = directions

    head_new = move_once(head, dir)
    tail_new = catch_up(head_new, tail)

    move(head_new, tail_new, rest, [tail | acc_list])
  end

  def catch_up(%Point{} = h, %Point{} = t) do
    dx = cond do
      h.x > t.x -> 1
      h.x == t.x -> 0
      h.x < t.x -> -1
    end

    dy = cond do
      h.y > t.y -> 1
      h.y == t.y -> 0
      h.y < t.y -> -1
    end

    cond do
      adjacent?(h, t) -> t
      true -> Point.new(t.x + dx, t.y + dy)
    end
  end

  def adjacent?(%Point{} = h, %Point{} = t) do
      cond do
        abs(h.x - t.x) < 2 && abs(h.y - t.y) < 2 -> true
        true -> false
      end
  end

  def move_once(%Point{} = p, direction) do
    case direction do
      "U" -> %{p | :x => p.x-1}
      "D" -> %{p | :x => p.x+1}
      "R" -> %{p | :y => p.y+1}
      "L" -> %{p | :y => p.y-1}
    end
  end

  def read_file(filename) do
      case File.read(filename) do
          {:ok, body} -> String.split(body, "\r\n")
          {:error, message} -> IO.inspect(message, label: "Error reading file:")
      end
  end
end

IO.inspect(Day9.run2(), label: "Result")
