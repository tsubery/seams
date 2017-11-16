defmodule Seams do
  alias __MODULE__, as: Self

  @doc """
  Replaces a module implementation for a module
  """
  def replace(from, to) do
    exists?() || init()
    true = :ets.insert(Self, {from, to})
  end

  @doc """
  Clears all previous defined replacements
  """
  def reset(), do: exists?() && :ets.delete_all_objects(Self)

  defp lookup(key) do
    case :ets.lookup(Self, key) do
      [{_, val}] -> val
      _ -> nil
    end
  end

  @doc false
  def call(module, fun_name, args) do
    target = exists?() && lookup(module) || module
    apply(target, fun_name, args)
  end


  defp exists?(), do: :ets.info(Self) != :undefined
  defp init(), do: Self = :ets.new(Self, [:named_table])

  @doc """
    Macro that defines function calls that can be replaced under test
  """

  defmacro defseam(funs, opts) do
    funs = Macro.escape(funs, unquote: true)
    quote bind_quoted: [funs: funs, opts: opts] do
      target = Keyword.get(opts, :to) ||
        raise ArgumentError, "expected to: to be given as argument"

      for fun <- List.wrap(funs) do
        {name, args, as, as_args} = Kernel.Utils.defdelegate(fun, opts)

        if Mix.env == :test do
          def unquote(name)(unquote_splicing(args)) do
            Self.call(unquote(target), unquote(as), unquote(as_args))
          end
        else
          def unquote(name)(unquote_splicing(args)) do
            unquote(target).unquote(as)(unquote_splicing(as_args))
          end
        end
      end
    end
  end

  use ExUnit.CaseTemplate

  setup do
    on_exit &Seams.reset/0
    :ok
  end
end
