defmodule Calendrical.RataDie do

  @moduledoc """
  The Rata Die format is very useful to convert between two calendrical representations.

  It counts days, starting at 0001-01-01T00:00 of the proleptic Gregorian Calendar.

  This implementation of Rata Die also counts inter-day fractions. To allow for exact precision without
  depending on external libraries, a very simple rational number implementation has been included.
  This also makes converting to Rata Die easier.
  """

  defstruct [:days, :num, :denom]

  defmodule InvalidRataDieFractionError do
    defexception message: "Invalid Rata Die Fraction"
  end


  def new(day, num \\ 0, denom \\ 1)

  def new(_day, _num, denom) when denom <= 0 do
    raise InvalidRataDieFractionError, "Invalid Rata Die Fraction: denominator has to be larger than zero!"
  end



  def new(_day, num, denom) when abs(num) > denom do
    raise InvalidRataDieFractionError, "Invalid Rata Die Fraction: numerator #{num} should be smaller than denominator #{denom}"
  end

  def new(days, num, denom) when num < 0 do
    days = days - 1
    num = denom + num
    new(days, num, denom)
  end

  def new(day, num, denom) do
    gcd = Calendrical.Helper.gcd(num, denom)
    %__MODULE__{days: day, num: div(num, gcd), denom: div(denom, gcd)}
  end

  def epoch do
    new(0,0,1)
  end

  defmodule Period do
    defstruct [:days, :num, :denom]

    def new(day \\ 0, num \\ 0, denom \\ 1)

    def new(_day, _num, denom) when denom <= 0 do
      raise InvalidRataDieFractionError, "Invalid Rata Die Fraction: denominator has to be larger than zero!"
    end

    def new(_day, num, denom) when abs(num) > denom do
      raise InvalidRataDieFractionError, "Invalid Rata Die Fraction: numerator #{num} should be smaller than denominator #{denom}"
    end

    def new(days, num, denom) when num < 0 do
      days = days - 1
      num = denom + num
      new(days, num, denom)
    end

    def new(day, num, denom) do
      gcd = Calendrical.Helper.gcd(num, denom)
      %__MODULE__{days: day, num: div(num, gcd), denom: div(denom, gcd)}
    end

    def absolute(period = %__MODULE__{}) do
      new(abs(period.days), abs(period.num), period.denom)
    end

    def negate(period = %__MODULE__{}) do
      new(-period.days, -period.num, period.denom)
    end

  end

  def add_period(rd = %__MODULE__{}, period = %Period{}) do
    days = rd.days + period.days
    denom = rd.denom * period.denom
    num = rd.num * period.denom - period.num * rd.denom
    new(days, num, denom)
  end

  def subtract_period(rd = %__MODULE__{}, period = %Period{}) do
    add_period(rd, period |> Period.negate)
  end

  def diff(rd1 = %__MODULE__{}, rd2 = %__MODULE__{}) do
    days = rd2.days - rd1.days
    denom = rd1.denom * rd2.denom
    num = rd2.num * rd1.denom - rd1.num * rd2.denom
    Period.new(days, num, denom)
  end

  def abs_diff(rd1 = %__MODULE__{}, rd2 = %__MODULE__{}) do
    diff(rd2, rd1)
    |> Period.absolute
  end

end
