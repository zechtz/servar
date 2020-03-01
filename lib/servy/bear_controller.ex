defmodule Servy.BearController do

  alias Servy.Wildthings
  alias Servy.Bear

  @templates_path Path.expand("../../public/templates", __DIR__)

  def index(conv) do
    items =
      Wildthings.list_bears()
      |> Enum.filter(&Bear.is_grizzly/1)
      |> Enum.sort(&Bear.order_asc_by_name/2)
      |> Enum.map(&bear_item/1)
      |> Enum.join

    # TODO: Transform the bears into an HTML list

    %{ conv | status: 201, resp_body: "#{items}" }
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{ conv | status: 200, resp_body: "<h1>Bear #{bear.id}: #{bear.name}"}
  end

  def create(conv, %{"name" => name, "type" => type} = params) do
    IO.puts "Params: #{inspect(params)}"
    %{ conv | status: 201, resp_body: "Created a #{type} bear named #{name}!" }
  end

  defp bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end
end
