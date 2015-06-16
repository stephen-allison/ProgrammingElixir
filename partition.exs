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

  ## dynamic programming approach
  ## partition list into k optimal partitions
  ## returns matrices M and D as maps
  ## see Algorithm Design Manual p58
  def partition(list, k) do
    partial_sums = [0 | Enum.scan(list, &(&1 + &2))]
    n = length(list)

    # m is a lookup telling us the best score
    # for dividing the first i items into j partitions
    #
    # first we set up edge cases
    m = for i <- 1..n, into: %{} do
      # for 1 partition the score is just the sum of the items
      # which was precalculated in partial_sums
      {{i,1}, Enum.fetch!(partial_sums, i)}
    end
    m = for j <- 1..k, into: m do
      # for 1 item then the score is that item, no matter how many partitions
      {{1,j}, Enum.fetch!(list, 0)}
    end


    for i <- 2..n, j <- 2..k, x <- 1..i-1 do
      # x is position of last 'partition edge'
      {i,j,x}
    end
    |> Enum.reduce({m,%{}},
                  fn {i,j,x}, {m,d} ->
                    # move through each partitioning of i items into j partitions
                    # trying different positions for 'x' the new edge
                    # record the best current score for {i,j} in m, and x in d

                    # worst score = highest summing partition
                    # it's either the worst partition to left of 'x' or
                    # the partition to the right
                    worst = max(Map.get(m, {x,j-1}, :inf),
                                Enum.fetch!(partial_sums,i) - Enum.fetch!(partial_sums,x))
                    previous_worst = Map.get(m, {i,j}, :inf)

                    if worst < previous_worst do
                      m = Map.put(m, {i,j}, worst)
                      d = Map.put(d, {i,j}, x) # store position of 'edge'
                    end
                    {m,d}
                  end
                  )
  end

  ## D matrix holds positions of each partition edge
  ## use it here to build list of partitions
  def boundaries(list,1,_), do: [list]
  def boundaries(list,k,d) do
    n = length(list)
    {rest, partition} = Enum.split(list, d[{n,k}])
    [partition | boundaries(rest,k-1,d)]
  end

  ## wrap up partitioning into single function
  def find(list, k) do
    {_m,d} = partition(list, k)
    Enum.reverse(boundaries(list, k, d))
  end

end
