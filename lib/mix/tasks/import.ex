require Logger

defmodule Mix.Tasks.Import do
  use Mix.Task

  alias CcbImport.Importers.TouchPoint

  @shortdoc "Import a CSV and generate an output"
  def run(args) do
    parsed_args = parse_args(args)
    import_from(parsed_args[:input_system], parsed_args)
  end

  def import_from("touchpoint", opts) do
    TouchPoint.import_file(opts[:input_filepath])
  end

  def parse_args(args) do
  	Enum.reduce args, %{}, fn(arg, parsed_args) ->
      [name, value] = String.split(arg, "=")
      name = String.replace(name, "--", "")
      Map.put(parsed_args, String.to_atom(name), value)
  	end
  end
end