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

  def on_definition(env, _kind, :execute, [_op, _n, _acc] = args, guards, _body) do
    Module.put_attribute(env.module, :executes, {args, guards})
  end

  def on_definition(_env, _kind, _func, _args, _guards, _body) do
  end

  defmacro before_compile(env) do
    executes = Module.get_attribute(env.module, :executes)

    supported_ops =
      Enum.map(executes, fn {[op, n, acc], guards} ->
        quote do
          defp supported?(unquote(op), _n, _acc) do
            true
          end
        end
      end)

    quote do
      unquote(supported_ops)

      defp supported?(op, n, _initial) do
        false
      end
    end
  end
end
