defmodule CcbImport.MixProject do
  use Mix.Project

  def project do
    [
      app: :ccb_import,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [
        :logger,
        #:ccb_api_ex,
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      #{:ccb_api_ex, git: "https://github.com/msawka/ccb_api_ex.git", branch: "master"},      
    ]
  end
end
