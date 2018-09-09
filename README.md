# CcbImport

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ccb_import_from_tp` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ccb_import, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ccb_import](https://hexdocs.pm/ccb_import).

## Usage

```
mix import --input_system=touchpoint --input_filepath=people.csv
```