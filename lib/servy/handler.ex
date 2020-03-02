defmodule Servy.Handler do
  @moduledoc "Handles HTTP requests"

  @pages_path Path.expand("../../public/pages", __DIR__)

  import Servy.Plugins, only: [rewrite_path: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.Conv, only: [full_status: 1]

  alias Servy.Conv, as: Conv
  alias Servy.BearController
  alias Servy.Api.BearController, as: BearApiController

  @doc "Transforms a HTTP request into a HTTP response"
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> route
    |> format_response
  end

  #def route(conv) do
    #route(conv, conv.method, conv.path)
  #end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    # BearController.index(conv)
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    BearApiController.index(conv)
  end

  # name=Baloo&type=Brown
  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    file = @pages_path |> Path.join("about.html")

    case File.read(file) do
      {:ok, contents} ->
        %Conv{ conv | status: 200, resp_body: contents }

      {:error, :enoent} ->
        %Conv{ conv | status: 404, resp_body: "File not found" }

      {:error, reason} ->
        %Conv{ conv | status: 500, resp_body: "Error reading the file #{reason}"}
    end
  end

  def route(%Conv{method: _method, path: path} = conv) do
    %{ conv | status: 404, resp_body: "No #{path} found here" }
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{full_status(conv)}\r
    Content-Type: #{conv.resp_content_type}\r
    Content-Length: #{String.length(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end
end
