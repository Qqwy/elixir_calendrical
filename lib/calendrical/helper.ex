defmodule Calendrical.Helper do
  @doc """
  Calculates the Greatest Common Denominator of two numbers.
  
  """
  def gcd(a, 0), do: abs(a)
  def gcd(0, b), do: abs(b)
  def gcd(a, b), do: gcd(b, Kernel.rem(a,b))
end
