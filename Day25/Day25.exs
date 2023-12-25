defmodule Day25 do
  def run() do
    Code.require_file("MyFunctions.exs", "../")
    input = MyFunctions.read_file("Input.md")
    #input = MyFunctions.read_file("Test.md")

    result = input
    |> Enum.map(fn x -> snafu_to_decimal(x) end)
    |> Enum.sum
    |> print

    snafu = decimal_to_snafu(result)
    |> print
    |> write_list()
  end

  def write_list([]), do: IO.puts("")

  def write_list([head | tail]) do
    IO.write(head)
    write_list(tail)
  end

  def decimal_to_snafu(number, acc \\ []) do
    k = get_highest_power(number)
    a = get_leading_digit(number)

    symbol = get_snafu_symbol(a)
    remainder = number - :math.pow(5,k) * a

    acc = cond do
      acc == [] ->
        for _ <- 0..k, do: 0
      true -> acc
    end
#print(acc)
    acc = List.replace_at(acc, k, symbol)
    cond do
      remainder == 0 -> Enum.reverse(acc)
      true -> decimal_to_snafu(remainder, acc)
    end
  end

  def get_snafu_symbol(a) do
    case a do
      1 -> 1
      2 -> 2
      -1 -> "-"
      -2 -> "="
    end
  end

  def get_leading_digit(number) do
    k = get_highest_power(abs(number))
    s = sign(number)
    cond do
      get_highest_power(abs(number) - :math.pow(5,k)) < k -> s
      true -> 2*s
    end
  end

  def sign(number) do
    cond do
      number == abs(number) -> 1
      true -> -1
    end
  end

  def get_highest_power(number, n \\ 0) do
    number = abs(number)
    digits = for i <- 0..n, do: :math.pow(5,i) * 2

    cond do
      number <= Enum.sum(digits) -> n
      true -> get_highest_power(number, n + 1)
    end
  end

  def snafu_to_decimal(str) do
    list = parse_string(str)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.map(fn {x, i} -> x * :math.pow(5,i) end)
    |> Enum.sum
  end

  def parse_string(str) do
    String.to_charlist(str)
    |> Enum.map(fn x -> List.to_string([x]) end)
    |> Enum.map(fn x -> parse_string_digit(x) end)
  end

  def parse_string_digit(d) do
    cond do
      #d == "=" || d == "-" -> d
      d == "=" -> -2
      d == "-" -> -1
      true -> String.to_integer(d)
    end
  end

  def print(x), do: IO.inspect(x, charlists: :as_lists)
end

IO.puts("Result:")
IO.inspect(Day25.run(), charlists: :as_lists)
