defmodule ProteinLanguageTest do
  use ExUnit.Case
  doctest ProteinLanguage

  test "greets the world" do
    assert ProteinLanguage.hello() == :world
  end
end
