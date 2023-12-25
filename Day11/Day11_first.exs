defmodule Monkey do
  defstruct [key: nil, items: [], operation: nil, test: nil, true_next: nil, false_next: nil]
end

defmodule Day11 do
  def run() do
    Code.require_file("MyFunctions.exs", "../")
    input = MyFunctions.read_file("Input.md")
    #input = MyFunctions.read_file("Test.md")

    monkeys = input
    |> Enum.map(fn x -> String.trim(x) end)
    |> Enum.chunk_while(
      %Monkey{},
      &chunk_fn/2,
      &after_fn/1)
    |> Map.new(fn monkey -> {monkey.key, monkey} end)

    IO.inspect(monkeys, charlists: :as_lists)

    {:ok, agent} = Agent.start_link(fn -> %{0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0} end)

    monkeys
    |> do_round(agent)
    |> do_round(agent)
    |> do_round(agent)
    |> do_round(agent)
    |> do_round(agent)

    |> do_round(agent)
    |> do_round(agent)
    |> do_round(agent)
    |> do_round(agent)
    |> do_round(agent)

    |> do_round(agent)
    |> do_round(agent)
    |> do_round(agent)
    |> do_round(agent)
    |> do_round(agent)

    |> do_round(agent)
    |> do_round(agent)
    |> do_round(agent)
    |> do_round(agent)
    |> do_round(agent)
    |> IO.inspect

    result = Agent.get(agent, fn x -> x end)
    Agent.stop(agent)
    result
  end

  def chunk_fn(elt, acc) do
    cond do
      String.contains?(elt, "Starting items:") ->
        list = String.replace(elt,"Starting items: ", "")
        |> String.split(", ")
        |> Enum.map(&String.to_integer/1)
        {:cont, %{acc | items: list}}

      String.contains?(elt, "Operation:") ->
        f = String.replace(elt,"Operation: new = old ","")
        |> get_operation
        {:cont, %{acc | operation: f}}

      String.contains?(elt, "Test: divisible by") ->
        x = String.replace(elt,"Test: divisible by ", "")
        |> String.to_integer
        {:cont, %{acc | test: x}}

      String.contains?(elt, "If true:") ->
        x = String.replace(elt,"If true: throw to monkey ", "")
        |> String.to_integer
        {:cont, %{acc | true_next: x}}

      String.contains?(elt, "If false:") ->
        x = String.replace(elt,"If false: throw to monkey ", "")
        |> String.to_integer
        {:cont, %{acc | false_next: x}}

      String.contains?(elt, "Monkey ") ->
        x = String.replace(elt,"Monkey ", "")
        |> String.replace(":", "")
        |> String.to_integer
        {:cont, %{acc | key: x}}

      elt == "" -> {:cont, acc, %Monkey{}}
    end
  end

  def after_fn(acc) do
    {:cont, acc, []}
  end

  def do_turn(monkeys, key, agent) do
    monkey = monkeys[key]

    cond do
      monkey == nil -> monkeys
      monkey.items == [] -> monkeys
      true ->

      Agent.update(agent, fn counts -> %{counts | key => counts[key] + 1} end)

      [x | tail] = monkey.items
      y = div(monkey.operation.(x), 3)

      to_key =
        case rem(y, monkey.test) == 0 do
          true -> monkey.true_next
          false -> monkey.false_next
        end

      to_monkey = monkeys[to_key]

      new_monkey = %{monkey | items: tail}
      new_to_monkey = %{to_monkey | items: to_monkey.items ++ [y]}

      new_monkeys = %{monkeys | key => new_monkey, to_key => new_to_monkey}
      case tail do
        [] -> new_monkeys
        _ -> do_turn(new_monkeys, key, agent)
      end

    end
  end

  def do_rounds(monkeys, _, 0), do: monkeys

  def do_rounds(monkeys, agent, number_of_rounds) do
    newmonkeys = do_round(monkeys, agent)
    do_rounds(newmonkeys, agent, number_of_rounds - 1)
  end

  def do_round(monkeys, agent) do
    monkeys
    |> do_turn(0, agent)
    |> do_turn(1, agent)
    |> do_turn(2, agent)
    |> do_turn(3, agent)
    |> do_turn(4, agent)
    |> do_turn(5, agent)
    |> do_turn(6, agent)
    |> do_turn(7, agent)
  end

  def get_operation(str) do
    cond do
      String.contains?(str, "* old") -> fn x -> x * x end

      String.contains?(str, "+ ") ->
        n = String.replace(str, "+ ", "")
        |> String.to_integer()
        fn x -> x + n end

      String.contains?(str, "* ") ->
        n = String.replace(str, "* ", "")
        |> String.to_integer()
        fn x -> x * n end
    end
  end
end

IO.puts("Result:")
IO.inspect(Day11.run(), charlists: :as_lists)
