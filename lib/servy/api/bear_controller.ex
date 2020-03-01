defmodule Servy.Api.BearController do

  alias Servy.Wildthings
  alias Servy.Bear

  def index(conv) do
    json =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)
      |> Jason.encode!

    %{ conv | status: 200, resp_content_type: "application/json", resp_body: json  }
  end
end
