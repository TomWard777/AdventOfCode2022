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
    point = scan_y(balls, 2743)
    IO.inspect(point, label: "Point")
    [u, v] = point
    4000000 * u + v
  end

  def get_answer(pts, x \\ 1) do
    cond do
      MapSet.member?(pts, x) -> get_answer(pts, x + 1)
      true -> x
    end
  end

  def scan_y(balls, yval \\ 0) do
    filtered_balls = Enum.filter(balls, fn b -> ball_meets_target_line(b, yval) end);

    result = scan_x(filtered_balls, yval)
    cond do
      result == nil ->
        IO.inspect(yval, label: "y value")
        scan_y(balls, yval + 1)
      true ->
        result
    end
  end

  def scan_x(balls, yval, xval \\ 0) do
    cond do
      is_beacon_here?(balls, xval, yval) -> [xval, yval]

      xval == @bound -> nil

      true -> scan_x(balls, yval, xval + 1)
    end
  end

  def is_beacon_here?([], _xvalue, _yvalue), do: true

  def is_beacon_here?(balls, xvalue, yvalue) do
    [b | tail] = balls
    cond do
      ball_contains_point?(b, xvalue, yvalue) -> false
      true -> is_beacon_here?(tail, xvalue, yvalue)
    end
  end

  def scan(balls, yvalue \\ 0) do
    filtered_balls = Enum.filter(balls, fn b -> ball_meets_target_line(b, yvalue) end);

    s = get_scanned_points(filtered_balls, yvalue)
    size = MapSet.size(s)
    IO.inspect(yvalue)
    cond do
      size < @bound ->
        IO.inspect(yvalue, label: "Answer y")
        yvalue
      yvalue > @bound -> nil
      true -> scan(balls, yvalue + 1)
    end
  end

  def ball_contains_point?(%Ball{} = b, x, y) do
    [u, v] = b.centre
    abs(x - u) + abs(y - v) <= b.radius
    #true
  end

  def ball_meets_target_line(%Ball{} = b, yvalue) do
    [x, y] = b.centre
    abs(y - yvalue) <= b.radius
  end

  def get_scanned_points(balls, yvalue, acc \\ MapSet.new())

  def get_scanned_points([], _, acc), do: acc

  def get_scanned_points(balls, yvalue, acc) do
    [b | tail] = balls
    set = MapSet.new(get_ball_points_fixed_y(b, yvalue))
    get_scanned_points(tail, yvalue, MapSet.union(set, acc))
  end

  def get_ball_points_fixed_y(%Ball{} = ball, yvalue) do
    [a, b] = ball.centre
    r = ball.radius
    for x <- -r..r, a + x > 0, a + x <= @bound, abs(x) <= r - abs(yvalue - b), do: a + x
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
