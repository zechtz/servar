defmodule Servy.Parser do

  alias Servy.Conv, as: Conv

  def parse(request) do
    [top, params_string] = request |> String.split("\n\n")
    [request_line | header_lines] = top |> String.split("\n")

    [method, path, _] = request_line |> String.split(" ")

    headers = parse_headers(header_lines, %{})
    params = parse_params(headers["Content-Type"], params_string)

    %Conv{
      method: method ,
      path: path,
      params: params,
      headers: headers
    }
  end

  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  def parse_params(_, _), do: %{}

  def parse_headers([head | tail], headers) do
    [key, value] = String.split(head, ": ")
    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  def parse_headers([], headers), do: headers
end
