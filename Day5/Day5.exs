defmodule Day5 do
  def run() do
    #Code.require_file("MyFunctions.exs", "../")
    input = read_file("Array.txt")
    moves_input = read_file("Moves.txt")
    #input = read_file("TestArray.txt")
    #moves_input = read_file("TestMoves.txt")

    item_lists =
    input
    |> Enum.map(fn item -> String.replace_leading(item, "[", "") end)
    |> Enum.map(fn item -> String.replace_trailing(item, "]", "") end)
    |> Enum.map(fn item -> String.split(item, ["] [", "  [", "]  ", "    "]) end)
    |> IO.inspect
    |> transpose()
    |> IO.inspect
    |> Enum.map(fn item -> Enum.map(item, fn x -> String.trim(x) end) end)
    |> Enum.map(fn item -> Enum.filter(item, fn x -> x != "" end) end)

    moves =
    moves_input
    |> Enum.map(fn item -> get_move_from_string(item) end)
    |> IO.inspect

    {:ok, agent} = Agent.start_link(fn -> item_lists end)
    IO.inspect(Agent.get(agent, fn x -> x end), label: "Initial state")

    Enum.each(moves, fn x -> do_move2(agent, x) end)

    result =
    Agent.get(agent, fn x -> x end)
    |> IO.inspect(label: "Final state")
    |> Enum.map(fn [x | _] -> x end)
    |> Enum.join

    Agent.stop(agent)
    result
  end

  def transpose(rows) do
    rows
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
  end

  def get_move_from_string(str) do
    [amt, from, to] = String.split(str, ["move ", " from ", " to "])
    |> Enum.filter(fn x -> x != "" end)
    |> Enum.map(fn x -> String.to_integer(x) end)

    [amt: amt, from: from - 1, to: to - 1]
  end

  def do_move(agent, [amt: amt, from: from, to: to]) do
    for _n <- 1..amt do
      Agent.update(agent, fn x -> do_single_move(x, from, to) end)
    end
  end

  def do_move2(agent, [amt: amt, from: from, to: to]) do
    #IO.inspect(Agent.get(agent, fn x -> x end), label: "before")
    lists = Agent.get(agent, fn x -> x end)

    fromlist = Enum.at(lists, from)
    tolist = Enum.at(lists, to)

    newlists = lists
    |> List.replace_at(from, Enum.slice(fromlist, amt..Enum.count(fromlist)))
    |> List.replace_at(to, Enum.slice(fromlist, 0..amt-1) ++ tolist)

    Agent.update(agent, fn _ -> newlists end)
    #IO.inspect(Agent.get(agent, fn x -> x end), label: "after")
  end

  def do_single_move(lists, from, to) do
    [fromhead | fromtail] = Enum.at(lists, from)
    tolist = Enum.at(lists, to)

    lists
    |> List.replace_at(from, fromtail)
    |> List.replace_at(to, [fromhead | tolist])
  end

  def read_file(filename) do
      case File.read(filename) do
          {:ok, body} -> String.split(body, "\r\n")
          {:error, message} -> IO.inspect(message, label: "Error reading file:")
      end
  end
end

test = Day5.run()
IO.inspect(test, label: "Result")
