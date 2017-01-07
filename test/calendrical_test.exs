defmodule CalendricalTest do
  use ExUnit.Case
  doctest Calendrical

  alias Calendrical.RataDie, as: RD

  test "creating a Rata Die works" do
    assert RD.new(1,2,3) == %RD{days: 1, num: 2, denom: 3}
    assert RD.new(-10,2,3) == %RD{days: -10, num: 2, denom: 3}
    assert RD.new(736336,1,86400) == %RD{days: 736336, num: 1, denom: 86400}
  end

  test "Rata Die raises when building bad fraction" do
    assert_raise RD.InvalidRataDieFractionError, fn -> RD.new(1,2,0) end
    assert_raise RD.InvalidRataDieFractionError, fn -> RD.new(1,20,10) end
    assert_raise RD.InvalidRataDieFractionError, fn -> RD.new(1,-20,10) end
  end

  test "Negative fractions are normalized" do
    assert RD.new(10,-2,3) == %RD{days: 9, num: 1, denom: 3}
  end

end
