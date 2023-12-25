defmodule Ball do
  defstruct [centre: [0, 0], radius: 0]

  def from_points([a, b], [x, y]) do
    r = abs(a-x) + abs(b-y)
    %Ball{centre: [a, b], radius: r}
  end
end

defmodule Day15 do
  def run() do
    Code.require_file("MyFunctions.exs", "../")
    input = MyFunctions.read_file("Input.md")
    #input = MyFunctions.read_file("Test.md")

    data = input
    |> Enum.map(fn x -> get_pair_of_points(x) end)

    sensors = Enum.map(data, fn [p, _] -> p end)
    beacons = Enum.map(data, fn [_, q] -> q end)

    #yvalue = 10
    #yvalue = 2000000
    #xmax = 20
    xmax = 4000000
    ymax = xmax

    IO.inspect(Enum.count(data), label: "Before")

    balls = Enum.map(data, fn [p, q] -> Ball.from_points(p, q) end)
    |> Enum.filter(fn b -> ball_meets_target_region(b, xmax, ymax) end)

    IO.inspect(Enum.count(balls), label: "After")

    #scanned = get_scanned_points(balls, yvalue)
    #beaconset = MapSet.new(beacons)
    #results = MapSet.to_list(MapSet.difference(scanned, beaconset))

    #results
    #|> Enum.filter(fn [_, y] -> y == yvalue end)
    #|> Enum.count()
  end

  def ball_meets_target_region(%Ball{} = b, xmax, ymax) do
    [x, y] = b.centre
    r = b.radius
    x + r >= 0 && x - r <= xmax && y + r >= 0 && y - r <= ymax
  end

  def ball_meets_target_line(%Ball{} = b, yvalue) do
    [x, y] = b.centre
    abs(y - yvalue) <= b.radius
  end

  def get_scanned_points(balls, yvalue, acc \\ MapSet.new())

  def get_scanned_points([], _, acc), do: acc

  def get_scanned_points(balls, yvalue, acc) do
    [b | tail] = balls

    IO.inspect(Enum.count(balls), label: "Balls left")

    set = MapSet.new(get_ball_points_fixed_y(b, yvalue))
    get_scanned_points(tail, yvalue, MapSet.union(set, acc))
  end

  def get_ball_points_in_region(%Ball{} = ball, xmax, ymax) do
    [a, b] = ball.centre
    r = ball.radius
    for x <- -r..r, y <- -r..r, abs(x) + abs(y) < do
      [a + x, yvalue]
    end
  end

  def get_ball_points_fixed_y(%Ball{} = ball, yvalue) do
    [a, b] = ball.centre
    r = ball.radius
    for x <- -r..r, abs(x) <= r - abs(yvalue - b) do
      [a + x, yvalue]
    end
  end

  def get_ball_points(%Ball{} = ball) do
    [a, b] = ball.centre
    r = ball.radius
    for x <- -r..r, y <- -r..r, abs(x) + abs(y) <= r do
      [a + x, b + y]
    end
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
