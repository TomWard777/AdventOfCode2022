defmodule Ball do
  defstruct [centre: [0, 0], radius: 0]

  def from_points([a, b], [x, y]) do
    r = abs(a-x) + abs(b-y)
    %Ball{centre: [a, b], radius: r}
  end
end

defmodule Day15 do
  #@bound 20
  @bound 4000000

  def run() do
    Code.require_file("MyFunctions.exs", "../")
    input = MyFunctions.read_file("Input.md")
    #input = MyFunctions.read_file("Test.md")

    data = input
    |> Enum.map(fn x -> get_pair_of_points(x) end)

    sensors = Enum.map(data, fn [p, _] -> p end)
    beacons = Enum.map(data, fn [_, q] -> q end)

    balls = Enum.map(data, fn [p, q] -> Ball.from_points(p, q) end)

    #yresult = scan(balls)
    #pts = get_scanned_points(balls, yresult)

    #answer = get_answer(pts)
    #IO.inspect([answer, yresult])
    #4000000 * answer + yresult

    # 2743
    scan_y(balls, 0)
    #IO.inspect(point, label: "Point")
    #[u, v] = point
    #4000000 * u + v
  end

  def scan_y(balls, yval \\ 0) do
    filtered_balls = Enum.filter(balls, fn b -> ball_meets_target_line(b, yval) end);
    intervals = get_intervals(filtered_balls, yval)
    cond do
      yval > @bound -> nil
      check_intervals(intervals) -> scan_y(balls, yval + 1)
      true -> yval
    end
  end

  def check_intervals(list) do
    list = Enum.sort(list, fn [a, b], [c, d] -> a <= c end)
    do_sorted_intervals_span?(list)
  end

  def do_sorted_intervals_span?([[a, b], [c, d]]), do: b >= c - 1

  def do_sorted_intervals_span?(list) do
    [h1 | [h2 | tail]] = list
    [a, b] = h1
    [c, d] = h2
    cond do
      b >= c -> do_sorted_intervals_span?([[a, max(b, d)] | tail])
      true ->
        IO.inspect(b+1, label: "Aaaaah!")
        false
    end
  end

  def simplify_two_intervals([a, b], [c, d]) do
    cond do
      b >= c - 1 -> [[a, max(b, d)]]
      true -> [[a, b], [c, d]]
    end
  end

  def get_intervals(balls, yvalue) do
    Enum.map(balls, fn b -> ball_interval_on_line(b, yvalue) end)
  end

  def ball_interval_on_line(%Ball{} = b, yvalue) do
    #cond do
     # !ball_meets_target_line(b, yvalue) -> []
    #end
    [x, y] = b.centre
    k = b.radius - abs(y - yvalue)
    [x - k, x + k]
  end

  def ball_contains_point?(%Ball{} = b, x, y) do
    [u, v] = b.centre
    abs(x - u) + abs(y - v) <= b.radius
  end

  def ball_meets_target_line(%Ball{} = b, yvalue) do
    [x, y] = b.centre
    abs(y - yvalue) <= b.radius
  end

  def get_pair_of_points(str) do
    [s1, s2] =
      String.replace(str, ["Sensor at x="], "")
    |> String.split(": closest beacon is at x=")

    p = String.split(s1, ", y=")
    |> Enum.map(fn x -> String.to_integer(x) end)

    q = String.split(s2, ", y=")
    |> Enum.map(fn x -> String.to_integer(x) end)
    [p, q]
  end

  def print(x), do: IO.inspect(x, charlists: :as_lists)
end

IO.puts("Result:")
IO.inspect(Day15.run(), charlists: :as_lists)
