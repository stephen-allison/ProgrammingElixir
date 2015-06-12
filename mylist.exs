defmodule MyList do

  def span(a, a), do: [a]
  def span(a, b), do: [a | span(a+1, b)]


  def sum([]), do: 0
  def sum([head|tail]), do: head + sum(tail)


  def max([]), do: nil

  def max([head|tail]), do: _max(tail, head)

  defp _max([], current_max), do: current_max

  defp _max([head|tail], current_max) do
    _max(tail, max(current_max, head) )
  end


  def map([], _func), do: []

  def map([h | t], func) do
    [func.(h) | map(t, func)]
  end


  def mapsum(list, func) do
    map(list, func) |> sum
  end

end

defmodule MyEnum do

  def all?([]), do: true
  def all?([h | t]), do: h and all?(t)

  def each([a], func), do: func.(a)
  def each([h | t], func) do
    func.(h)
    each(t, func)
  end

  def filter([], _func), do: []
  def filter([h | t], func) do
    if func.(h) do
      [h | filter(t, func)]
    else
      filter(t, func)
    end
  end


  def split(list, n), do: _split(list, n, [])

  defp _split([], _n, _), do: []

  defp _split(list, 0, first_part), do: {first_part, list}

  defp _split([h | t], n, first_part) do
    _split(t, n-1, first_part++[h])
  end


  def take(lst, n) do
    {a, _b} = split(lst, n)
    a
  end


  def flatten([]), do: []

  def flatten([h | t]) when is_list(h) do
    flatten(h) ++ flatten(t)
  end

  def flatten([h | t]) do
    [h | flatten(t)]
  end

end
