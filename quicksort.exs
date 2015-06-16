defmodule Quicksort do

  def qsort([]), do: []
  def qsort([h|t]) do
    {left, right} = Enum.partition(t, fn x -> x < h end)
    qsort(left) ++ [h] ++ qsort(right)
  end

end
