defmodule Seams.Mixfile do
  use Mix.Project

  def project do
    [
      app: :seams,
      version: "0.1.0",
      elixir: "~> 1.4",
      start_permanent: Mix.env == :prod,
      description: "Micro library to allow test dependency isolation",
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
    ]
  end

  defp package do
    [
     name: :seams,
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["Gal Tsubery"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/tsubery/seams"}
   ]
  end
end
