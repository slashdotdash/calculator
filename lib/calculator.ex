defmodule Calculator do
  use Hooks

  def reduce(ops, initial) do
    ops
    |> Enum.filter(fn {op, n} -> supported?(op, n, initial) end)
    |> Enum.reduce(initial, fn {op, n}, acc -> execute(op, n, acc) end)
  end

  defp execute(:add, n, acc) when is_number(n), do: acc + n
  defp execute(:subtract, n, acc) when is_number(n), do: acc - n
end
