defmodule Day3 do
  def run() do
    Code.require_file("MyFunctions.exs", "../")
    input = read_file("Input3.txt")
    #input = read_file("Test.txt")

    input
    |> Enum.map(fn item -> get_repeated_char(item) end)
    |> Enum.map(fn char -> get_charvalue(char) end)
    |> Enum.sum()
  end

  def run2() do
    Code.require_file("MyFunctions.exs", "../")
    input = read_file("Input3.txt")
    #input = read_file("Test.txt")

    input
    |> Enum.map(fn item -> String.to_charlist(item) end)
    |> MyFunctions.to_sublists(3)
    |> Enum.map(fn charlist -> MyFunctions.intersect_all(charlist) end)
    |> Enum.map(fn [char] -> get_charvalue(char) end)
    |> IO.inspect()
    |> Enum.sum()
  end

  def get_repeated_char(item) do
    len = String.length(item)

    str1 = String.slice(item, 0..div(len,2)-1)
    str2 = String.slice(item, div(len,2)..len-1)

    [head | _] = MyFunctions.intersection(String.to_charlist(str1), String.to_charlist(str2))
    head
  end

  def get_charvalue(codepoint) do
    cond do
      ?a <= codepoint && ?z >= codepoint -> codepoint - ?a + 1
      ?A <= codepoint && ?Z >= codepoint -> codepoint - ?A + 27
      true -> 0
    end
  end

  def read_file(filename) do
      case File.read(filename) do
          {:ok, body} -> String.split(body, "\r\n")
          {:error, message} -> IO.inspect(message, label: "Error reading file:")
      end
  end
end

#test = Day3.run()
test = Day3.run2()
IO.inspect(test, label: "Result")
