defmodule Primes do

  def is_prime(2), do: True
  def is_prime(n) do
    not Enum.any?(Stream.map(2..round(:math.sqrt(n)), &(rem(n,&1) == 0)))
  end


  def upto(n) do
    for x <- 2..n, is_prime(x), do: x
  end

end
