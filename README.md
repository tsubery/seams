# Seams

Seams is a micro library that helps isolate dependencies under test environment. There are multiple approaches to achieve test isolation: dependency injection, using a dependency registry or using mocking libraries.
This library design goals are 
* Reducing "magic" by explicity specifying what can mocked.
* Minimize changes to production code
* Minimize runtime overhead

This is achieved by using dynamic lookup when compiling under test environment while calling modules directly on other environments. It means production code is slightly different from test code which could be a deal breaker. If you are not sure about the safety of this solution you can look at the macro used to differentiate the environments and see for yourself.

## Installation

The package can be installed by adding `seams` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:seams, "~> 0.1.0"}
  ]
end
```

## Usage

The syntax is identical to Kernel.defdelegate/2
```
defmodule Controller do
  Seams.defseam post(args), to: Http, as: http_post
end

defmodule FakeHttp do
  def post(args), do: "posted #{inspect(args)}"
end


defmodule PaymentTest do
  use Seams

  test "no change by default" do
    Seams.replace(Http, FakeHttp)
    assert Controller.post("123") == "posted 123"
  end
end

```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/seams](https://hexdocs.pm/seams).

