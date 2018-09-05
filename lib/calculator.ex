defmodule Calculator do
  use Hooks

  def reduce(ops, initial) do
    ops
    |> Enum.filter(fn {op, n} -> supported?(op, n, initial) end)
    |> Enum.reduce(initial, fn {op, n}, acc -> execute(op, n, acc) end)
  end

  defp execute(:add, n, acc) when is_number(n) and is_number(acc), do: acc + n
  defp execute(:subtract, n, acc) when is_number(n) and is_number(acc), do: acc - n

  defp execute(:output, _n, acc) do
    IO.puts("total=#{inspect(acc)}")
    acc
  end
end
