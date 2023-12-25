defmodule Day10 do
  def run() do
    Code.require_file("MyFunctions.exs", "../")
    input = MyFunctions.read_file("Input.txt")
    #input = MyFunctions.read_file("Test.txt")

    input
    |> Enum.chunk_while(
      [cycle: 0, reg: 1],
      &chunk_fn/2,
      &after_fn/1)
    |> IO.inspect
    |> Enum.map(fn x -> x[:cycle] * x[:reg_at_start] end)
    |> Enum.sum
  end

  def chunk_fn(elt, acc) do
    IO.inspect(acc)
    cyc = acc[:cycle]
    reg = acc[:reg]

    output = cond do
      rem(cyc - 19, 40) == 0 -> cyc + 1
      String.contains?(elt, "addx") && rem(cyc - 18, 40) == 0 -> cyc + 2
      true -> nil
    end

    newacc = cond do
      elt == "noop"-> [cycle: cyc + 1, reg: reg]

      String.contains?(elt, "addx") ->
        "addx " <> number = elt
        n = String.to_integer(number)
        [cycle: cyc + 2, reg: reg + n]
    end

    cond do
      output != nil -> {:cont, [cycle: output, reg_at_start: reg], newacc}
      true -> {:cont, newacc}
    end
  end

  def after_fn(acc) do
    {:cont, []}
  end
end

IO.inspect(Day10.run(), label: "Result")
