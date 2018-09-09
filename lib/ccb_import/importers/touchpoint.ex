require Logger

defmodule CcbImport.Importers.TouchPoint do

  def import_file(filepath) do
    contents = File.read!(filepath)
    {headers, rows} = Enum.reduce String.split(contents, "\n"), {nil, []}, fn(line, {headers, rows}) ->
      cond do
        headers == nil -> 
          {headers, _cnt} = Enum.reduce String.split(line, ","), {%{}, 0}, fn(header, {headers, cnt}) ->
            {Map.put(headers, cnt, header), cnt + 1}
          end
          {headers, rows}
        true -> 
          {row, _cnt} = Enum.reduce String.split(line, ","), {%{}, 0}, fn(value, {row, cnt}) ->
            {Map.put(row, headers[cnt], value), cnt + 1}
          end
          {headers, rows ++ [row]}
      end
    end

    attribute_search = [
      ["Email"],
      ["FirstName", "LastName"]
    ]
    Enum.reduce rows, [], fn(row, users_to_import) ->
      case match_individual(attribute_search, row) do
        {:error, reason} -> Logger.error("Failed to execute individual search:  #{inspect reason}")
        nil -> 
          Logger.debug("User '#{row["FirstName"]} #{row["LastName"]}' does not exist, importing...")
        individual -> 
          Logger.debug("User '#{row["FirstName"]} #{row["LastName"]}' exists, updating...")
      end
    end
  end

  def match_individual([], _attribute_values), do: nil
  def match_individual([attribute_list | remaining_attributes], attribute_values) do
    case individual_search(attribute_list, attribute_values) do
      {:error, reason} -> {:error, reason}
      nil -> match_individual(remaining_attributes, attribute_values)
      individual -> individual
    end
  end

  def individual_search(attribute_list, attribute_values) do
    params = Enum.reduce attribute_list, %{}, fn(touchpoint_attribute, params) ->
      Map.put(params, to_ccb_search_attribute_name(touchpoint_attribute), URI.encode(attribute_values[touchpoint_attribute]))
    end

    case CcbApiEx.Api.IndividualSearch.search(params) do
      {:error, reason} -> {:error, reason}
      [] -> 
        Logger.debug("Unable to find a user match based on attribute(s) #{inspect params}")
        nil
      individuals ->
        if length(individuals) > 1 do
          {:error, "Multiple users were found for attribute(s) #{inspect params}"}            
        else
          List.first(individuals)
        end
    end    
  end

  def to_ccb_search_attribute_name(touchpoint_attribute) do
    cond do
      touchpoint_attribute == "Email" -> "email"
      touchpoint_attribute == "FirstName" -> "first_name"
      touchpoint_attribute == "LastName" -> "last_name"
      true -> ""
    end
  end

  def to_ccb([], ccb_rows), do: ccb_rows
  def to_ccb([row | remaining_rows], ccb_rows) do
    ccb_row = %{
      "Individual ID" => "TODO",
      "Family ID" => "TODO",
      "Family Position" => "TODO",
      "First Name" => row["FirstName"],
      "Last Name" => row["LastName"],
      "Legal First Name" => "",
      "Limited Access User" => "Limited Access",
      "Listed" => "TODO",
      "Inactive/Remove" => "TODO",
      "Campus" => "",
      "Email" => "Email",
      "Mailing Street" => "Address",
      "Mailing Street Line 2" => "Address2",
      "Mailing City" => "City",
      "Mailing State" => "State",
      "Mailing Postal Code" => "Zip",
      "Mailing Country" => "Country",
      "Mailing Carrier Route" => "",
      "Mobile Phone" => "CellPhone",
      "Mobile Carrier" => "",
      "Home Phone" => "HomePhone",
      "Work Phone" => "WorkPhone",
      "Emergency Phone" => "",
      "Emergency Name" => "",
      "Date of Birth" => "BirthDate",
      "Marital Status" => "TODO",

    }
  end
end