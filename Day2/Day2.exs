defmodule Day2 do
  def run() do
    input =
    case File.read("Input2.txt") do
        {:ok, body} -> String.split(body, "\r\n")
        {:error, message} -> message
    end

    input
    |> Enum.map(fn item -> String.split(item) end)
    |> Enum.map(fn list -> get_move(list) end)
    |> Enum.reduce(0, fn move, acc -> acc + newscore(move) end)
  end

  defp get_move([first | [last]]) do
    [them: first, me: last]
  end

  defp score([them: them, me: "X"]) do
    gamescore = case them do
      "A" -> 3
      "B" -> 0
      "C" -> 6
    end
    gamescore + 1
  end

  defp score([them: them, me: "Y"]) do
    gamescore = case them do
      "A" -> 6
      "B" -> 3
      "C" -> 0
    end
    gamescore + 2
  end

  defp score([them: them, me: "Z"]) do
    gamescore = case them do
      "A" -> 0
      "B" -> 6
      "C" -> 3
    end
    gamescore + 3
  end

  defp newscore([them: them, me: "X"]) do
    movescore = case them do
      "A" -> 3
      "B" -> 1
      "C" -> 2
    end
    movescore + 0
  end

  defp newscore([them: them, me: "Y"]) do
    movescore = case them do
      "A" -> 1
      "B" -> 2
      "C" -> 3
    end
    movescore + 3
  end

  defp newscore([them: them, me: "Z"]) do
    movescore = case them do
      "A" -> 2
      "B" -> 3
      "C" -> 1
    end
    movescore + 6
  end
end

test = Day2.run()
IO.inspect(test, label: "result")
