defmodule Day10 do
  def run() do
    Code.require_file("MyFunctions.exs", "../")
    input = MyFunctions.read_file("Input.txt")
    #input = MyFunctions.read_file("Test.txt")

    text = input
    |> Enum.chunk_while(
      [cycle: 0, reg: 1],
      &chunk_fn/2,
      &after_fn/1)

    text
    |> Enum.join
    |> String.split("\n")
  end

  def chunk_fn(elt, acc) do
    cyc = acc[:cycle]
    reg = acc[:reg]

    newacc = cond do
      elt == "noop"-> [cycle: cyc + 1, reg: reg]

      String.contains?(elt, "addx") ->
        "addx " <> number = elt
        n = String.to_integer(number)
        [cycle: cyc + 2, reg: reg + n]
    end

    newline? = cond do
      rem(cyc + 1, 40) == 0 -> true
      String.contains?(elt, "addx") && rem(cyc + 2, 40) == 0 -> true
      true -> false
    end

    newline_splits_printout? = cond do
      String.contains?(elt, "addx") && rem(cyc + 1, 40) == 0 -> true
      true -> false
    end

    #IO.inspect({cyc, reg, newline?, newline_splits_printout?})

    printout = cond do
      String.contains?(elt, "addx") -> get_two_step_printout(cyc, reg, newline_splits_printout?)
      abs(rem(cyc, 40) - reg) < 2 -> "#"
      true -> "."
    end

    cond do
      newline? && !newline_splits_printout? -> {:cont, printout <> "\n", newacc}
      true -> {:cont, printout, newacc}
    end
  end

  def after_fn(acc) do
    {:cont, "", []}
  end

  def get_two_step_printout(cyc, reg, newline_splits_printout?) do
    x = rem(cyc, 40)
    first = cond do
      abs(reg - x) < 2 -> "#"
      true -> "."
    end

    y = rem(cyc + 1, 40)
    second = cond do
      abs(reg - y) < 2 -> "#"
      true -> "."
    end

    case newline_splits_printout? do
      true -> first <> "\n" <> second
      false -> first <> second
    end
  end
end

IO.inspect(Day10.run())
