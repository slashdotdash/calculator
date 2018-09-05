defmodule Hooks do
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)

      Module.register_attribute(
        __MODULE__,
        :executes,
        accumulate: true,
        persist: false
      )

      @on_definition {unquote(__MODULE__), :on_definition}
      @before_compile {unquote(__MODULE__), :before_compile}
    end
  end

  def on_definition(env, _kind, :execute, args, guards, _body) do
    Module.put_attribute(env.module, :executes, {args, guards})
  end

  def on_definition(_env, _kind, _func, _args, _guards, _body) do
  end

  defmacro before_compile(env) do
    executes = Module.get_attribute(env.module, :executes)

    supported_ops =
      Enum.map(executes, fn {args, guards} ->
        guard = combine_guards(guards)

        quote generated: true do
          defp supported?(unquote_splicing(args)) when unquote(guard) do
            true
          end
        end
      end)

    quote generated: true do
      unquote(supported_ops)

      # Operations are not supported by default.
      defp supported?(_op, _n, _initial) do
        false
      end
    end
  end

  # Combine list of guard clauses to single guard using `or`.
  defp combine_guards(guards)

  defp combine_guards([]), do: nil

  defp combine_guards(guards) do
    Enum.reduce(guards, fn guard, acc ->
      quote do: unquote(acc) or unquote(guard)
    end)
  end
end
