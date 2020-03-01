defmodule Servy.BearController do

  alias Servy.Wildthings
  alias Servy.Bear

  @templates_path Path.expand("../../public/templates", __DIR__)

  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)

    # TODO: Transform the bears into an HTML list
    content =
      @templates_path
      |> Path.join("index.eex")
      |> EEx.eval_file(bears: bears)

    %{ conv | status: 201, resp_body: content }
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    content =
      @templates_path
      |> Path.join("show.eex")
      |> EEx.eval_file(bear: bear)

    %{ conv | status: 200, resp_body: content}
  end

  def create(conv, %{"name" => name, "type" => type} = params) do
    IO.puts "Params: #{inspect(params)}"
    %{ conv | status: 201, resp_body: "Created a #{type} bear named #{name}!" }
  end
end
