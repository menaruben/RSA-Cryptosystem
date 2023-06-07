defmodule RsaTest do
  use ExUnit.Case
  doctest Rsa

  test "greets the world" do
    assert Rsa.hello() == :world
  end
end
