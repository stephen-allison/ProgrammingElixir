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


defmodule Primes do

  def is_prime(2), do: True
  def is_prime(n) do
    not Enum.any?(Stream.map(2..round(:math.sqrt(n)), &(rem(n,&1) == 0)))
  end


  def upto(n) do
    for x <- 2..n, is_prime(x), do: x
  end

end


defmodule Quicksort do

  def qsort([]), do: []
  def qsort([h|t]) do
    {left, right} = Enum.partition(t, fn x -> x < h end)
    qsort(left) ++ [h] ++ qsort(right)
  end

end


defmodule Partition do

  ## set with n entries s1...sn
  ## divide into k partitions
  ## cost of a partition is sum of elements in that partition
  ## want the partitioning with the lowest maximum partition
  ## nb, only calculates that score, not the actual partitions
  ## From The Algorithm Design Manual [Steven S Skiena], p57

  def mincost([s], _k), do: s
  def mincost(list, 1), do: Enum.sum(list)
  def mincost(list, k) do
    for {_, n} <- Enum.with_index(list) do
      {a, b} = Enum.split(list, n+1)
      max(mincost(a, k-1), Enum.sum(b))
    end |> Enum.min
  end

end



