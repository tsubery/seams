defmodule SeamsTest do
  use Seams

  defmodule A do
    def call, do: :a
    def call2(arg), do: {:a, arg}
  end

  defmodule B do
    def call, do: :b
    def call2(arg), do: {:b, arg}
  end

  defmodule Subject do
    Seams.defseam call(), to: A
    Seams.defseam call2(arg), to: A
  end

  test "works" do
    assert Subject.call == :a
    assert Subject.call2(:test) == {:a, :test}
    Seams.replace(A, B)
    assert Subject.call == :b
    assert Subject.call2(:test) == {:b, :test}
    Seams.reset()
    assert Subject.call == :a
    assert Subject.call2(:test) == {:a, :test}
  end

  test "morerr" do
    assert Subject.call == :a
    assert Subject.call2(:test) == {:a, :test}
  end
end
