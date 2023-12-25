defmodule Day1 do
  def run() do
    elves = 
    case File.read("Input1.txt") do
        {:ok, body} -> String.split(body, "\r\n\r\n")
        {:error, message} -> message
    end

    elves = Enum.map(elves, fn elf -> String.split(elf, "\r\n") end)

    elves
    |> Enum.map(fn elf -> total_cals(elf) end)
    |> Enum.sort(:desc)
  end

  defp total_cals(string_list) do
    string_list
    |> Enum.map(fn str -> String.to_integer(str) end)
    |> Enum.reduce(0, fn x, acc -> x + acc end)
  end  
end

test = Day1.run()
IO.inspect(test, label: "result")