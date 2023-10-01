defmodule TwoFactorAuthTest do
  use ExUnit.Case
  doctest TwoFactorAuth

  test "greets the world" do
    assert TwoFactorAuth.hello() == :world
  end
end
