defmodule CalculatorTest do
  use ExUnit.Case

  test "calculates supported ops" do
    ops = [{:add, 10}, {:subtract, 5}, {:unsupported, 1}]

    assert Calculator.reduce(ops, 0) == 5
  end

  test "calculates ops with guard clause" do
    ops = [{:add, 10}, {:add, "foo"}, {:subtract, 5}, {:unsupported, 1}]

    assert Calculator.reduce(ops, 0) == 5
  end

  test "calculates ops with and guard clause" do
    ops = [{:add, 10}, {:add, "foo"}, {:subtract, 5}, {:unsupported, 1}]

    assert Calculator.reduce(ops, :invalid) == :invalid
  end
end
